
var categoryExclusions = {
    rooftop_solar: [ 'offsite_solar' ],
    offsite_solar: [ 'rooftop_solar' ],
    electric_heat_pump: [ 'geothermal_heat_pump' ],
    geothermal_heat_pump: [ 'electric_heat_pump'],
    hybrid_car: [ 'plug_in_hybrid', 'electric_car' ],
    plug_in_hybrid: [ 'hybrid_car', 'electric_car' ],
    electric_car: [ 'hybrid_car', 'plug_in_hybrid' ]
};

// the cache for all the city, state, zip data retrieved from the server
var locationCache = {};

// the keys of all of the currently selected categories
var selectedCategories = [];

// stores all of the data for the currently selected location
var locationData;

function calculatorInit() {
    $( '#city_or_zip' ).typeahead({
        hint: true,
        minLength: 2
    }, {
        display: function( data ) {
            return formatCityState( data );
        },
        source: getSuggestions,
        templates: {
            empty: 'No results found',
            suggestion: function ( data ) {
                return '<p>' + formatCityState( data ) + '</p>';
            }
        }
    }).bind( 'typeahead:select', function( event, suggestion ) {
        retrieveLocationData(suggestion.id);
    });

    loadGeolocatedLocationData();
    $( '.calculator .btn' ).click( categoryChange );
}

$( calculatorInit ); // For direct page loads
$( document ).on( 'page:load', calculatorInit ); // For following links

function getSuggestions( query, sync, async ) {
    if( !query || query.length < 2 ) {
        sync();
        async();
        return;
    }

    var searchKey = query.substring( 0, 2 ).toLowerCase();

    // search cached results
    if( searchKey in locationCache ) {
        sync( findMatches( query, locationCache[ searchKey ] ) );
        async();
        return;
    }

    $.ajax({ url: '/typeahead/' + searchKey })
    .done( function( data ) {
        locationCache[searchKey] = data;
        sync();
        async( findMatches( query, data ) );
    });
}

// Collapses string by removing all spaces and commas and making lower-case.
function flattenString( str ) {
    return str.replace( /[, ]/g, '' ).toLowerCase();
}

function findMatches( query, data ) {
    var matches = [];

    // extract 5 results from location cache based on search key
    var i = 0;
    while( matches.length < 5 && i < data.length ) {
        var entry = data[ i++ ];
        var e = flattenString( entry.city + entry.state );
        var q = flattenString( query );
        if( e.indexOf( q ) >= 0 )
            matches.push( entry );
    }

    return matches;
}

function loadGeolocatedLocationData() {
    var geolocation = $( '#city_or_zip' ).val();
    if( !geolocation ) return;
    $.ajax({ url: '/typeahead/' + geolocation })
    .done( function( data ) {
        if( data.length > 0 ) { retrieveLocationData( data[0].id ) };
    });
}

function retrieveLocationData(locationId) {
    $.ajax({
        url: '/calculate',
        data: { id: locationId },
        method: 'post'
    })
    .done( setLocationData );
}

function formatCityState( cityState ) {
    return toTitleCase( cityState.city ) + ', ' + cityState.state.toUpperCase();
}

function toTitleCase( str ) {
    return str.replace( /([^\W_]+[^\s-]*) */g, function( txt ) {
        return txt.charAt( 0 ).toUpperCase() + txt.substr(1).toLowerCase();
    });
}

function setLocationData( data ) {
    $( '.calculator-result-total span#city' )
        .text( formatCityState( data ) + "." );
    locationData = data;
    resetCategoryMessage();
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
        $.each( categoryExclusions[ name ], function( index, value ) {
            $( '.btn#' + value ).removeClass( 'active' );
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
    if( selectedCategories.length == 0 || !locationData ) {
        $( '.calculator-result' ).removeClass( 'active' );
        return;
    }

    $( '.result-category' ).removeClass( 'active' );
    var lastElement = selectedCategories[ selectedCategories.length-1 ];
    var resultObj = $( '.result-category#' + lastElement );
    resultObj.addClass( 'active' );
    $( '.calculator-result-total span#total' ).text( '$' + totalPrice() );
    $( '.calculator-result' ).addClass( 'active' );
}

function totalPrice() {
    var total = 0;
    $.each( selectedCategories, function( index, value ) {
        total += locationData[ this ];
    });
    return total;
}
