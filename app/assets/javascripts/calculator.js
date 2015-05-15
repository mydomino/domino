
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

var calculatorInit = function() {
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
            url: "/calculate",
            data: {id: suggestion.id},
            method: 'post'
        })
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
