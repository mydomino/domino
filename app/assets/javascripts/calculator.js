
var categoryData = {
    rooftop_solar: {
        id: 1,
        exclusivity: [2]
    },
    offsite_solar: {
        id: 2,
        exclusivity: [1]
    },
    led: {
        id: 3,
        exclusivity: []
    },
    hybrid_car: {
        id: 7,
        exclusivity: [8, 9]
    },
    plug_in_hybrid: {
        id: 8,
        exclusivity: [7, 9]
    },
    electric_car: {
        id: 9,
        exclusivity: [7, 8]
    }
};

// stores all of the data for the currently selected location
var locationData;

// instantiate the bloodhound suggestion engine
var engine = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    identify: function(obj) { return obj.id; },
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
    $('#city_or_zip').typeahead({
        hint: true,
        minLength: 2
    }, {
        display: function(data) {
            return formatCityState(data);
        },
        source: engine.ttAdapter(),
        templates: {
            empty: 'No results found',
            suggestion: function (data) {
                return '<p>' + formatCityState(data) + '</p>';
            }
        }
    }).bind('typeahead:select', function(event, suggestion) {
        $.ajax({
            url: '/calculate',
            data: {id: suggestion.id},
            method: 'post'
        })
        .done(setLocationData);
    });

    $.each(categoryData, function(key, value) {
        $('.btn#' + key).click(key, categoryChange);
    });
}

$(document).ready( calculatorInit ); // For direct page loads
$(document).on( 'page:load', calculatorInit ); // For following links

function formatCityState(cityState) {
    return toTitleCase(cityState.city) + ', ' + cityState.state.toUpperCase();
}

function toTitleCase(str) {
    return str.replace(/([^\W_]+[^\s-]*) */g, function(txt) {
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
}

function setLocationData(data) {
    //$('.calculator-result-total span#total').text("$1234");
    $('.calculator-result-total span#city').text(formatCityState(data) + ".");
    locationData = data;
}

function categoryChange(obj) {
    if( $('.btn#' + obj.data ).hasClass('active'))
        $('.result-category#' + obj.data).removeClass('active');
    else
        $('.result-category#' + obj.data).addClass('active');
}