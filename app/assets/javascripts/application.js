// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require typeahead.bundle

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

var init = function() {
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
var formatCityState = function(cityState) {
    return toTitleCase(cityState.city) + ', ' + cityState.state.toUpperCase();
}

$(document).ready( init ); // For direct page loads
$(document).on( 'page:load', init ); // For following links

function toTitleCase(str) {
    return str.replace(/([^\W_]+[^\s-]*) */g, function(txt) {
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
}