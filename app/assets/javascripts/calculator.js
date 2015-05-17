
var categoryExclusions = {
    rooftop_solar: [ 'offsite_solar' ],
    offsite_solar: [ 'rooftop_solar' ],
    electric_heat_pump: [ 'geothermal_heat_pump' ],
    geothermal_heat_pump: [ 'electric_heat_pump'],
    hybrid_car: [ 'plug_in_hybrid', 'electric_car' ],
    plug_in_hybrid: [ 'hybrid_car', 'electric_car' ],
    electric_car: [ 'hybrid_car', 'plug_in_hybrid' ]
};

// the keys of all of the currently selected categories
var selectedCategories = [];

// stores all of the data for the currently selected location
var locationData;

// instantiate the bloodhound suggestion engine
var engine = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    identify: function( obj ) { return obj.id; },
    remote: {
        url: '/typeahead/%QUERY',
        wildcard: '%QUERY'
    },
    limit: 5
});

// initialize the bloodhound suggestion engine
engine.initialize();

function calculatorInit() {
    // instantiate the typeahead UI
    $( '#city_or_zip' ).typeahead({
        hint: true,
        minLength: 2
    }, {
        display: function( data ) {
            return formatCityState( data );
        },
        source: engine.ttAdapter(),
        templates: {
            empty: 'No results found',
            suggestion: function ( data ) {
                return '<p>' + formatCityState( data ) + '</p>';
            }
        }
    }).bind( 'typeahead:select', function( event, suggestion ) {
        $.ajax({
            url: '/calculate',
            data: { id: suggestion.id },
            method: 'post'
        })
        .done( setLocationData );
    });

    $( '.calculator .btn' ).click( categoryChange );
}

$( calculatorInit ); // For direct page loads
$( document ).on( 'page:load', calculatorInit ); // For following links

function formatCityState( cityState ) {
    return toTitleCase( cityState.city ) + ', ' + cityState.state.toUpperCase();
}

function toTitleCase( str ) {
    return str.replace( /([^\W_]+[^\s-]*) */g, function( txt ) {
        return txt.charAt( 0 ).toUpperCase() + txt.substr(1).toLowerCase();
    });
}

function setLocationData( data ) {
    //$('.calculator-result-total span#total').text("$1234");
    $( '.calculator-result-total span#city' )
        .text( formatCityState( data ) + "." );
    locationData = data;
}

function categoryChange( obj ) {
    if( this.classList.contains( 'active' ) )
        removeCategory( this.id );
    else
        addCategory( this.id );

    resetCategoryMessage();
}

function addCategory( name ) {
    selectedCategories.push( name );

    // remove any exclusive categories
    if( name in categoryExclusions ) {
        $.each(categoryExclusions[name], function( index, value ) {
            $( '.btn#' + value).removeClass('active');
            removeCategory( value );
        });
    };
}

function removeCategory( name ) {
    var found = 0;
    while( ( found = selectedCategories.indexOf( name, found ) ) !== -1 ) {
        selectedCategories.splice( found, 1 );
    }
}

function resetCategoryMessage() {
    if( selectedCategories.length == 0 ) {
        $( '.calculator-result' ).removeClass( 'active' );
        return;
    }

    $( '.result-category' ).removeClass( 'active' );
    var lastElement = selectedCategories[ selectedCategories.length-1 ];
    var resultObj = $( '.result-category#' + lastElement );
    resultObj.addClass('active');
    $( '.calculator-result' ).addClass( 'active' );
}