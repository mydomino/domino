function track_lead_creation()
{
  ga('send', 'event', 'lead', 'created');
  _fbq.push(['track','6028103428047',{}]);
  heap.track('lead creation', {});
  window['optimizely'] = window['optimizely'] || [];
  window['optimizely'].push(["trackEvent", "leadCreated"]);
  goog_report_conversion();
}
function animate_form_success()
{
  $('.errors').hide()
  var form = $('form');
  var inputs = $('form input');
  var button = $('form input[type="submit"]');

  inputs.attr('disabled', 'true')
  setTimeout(function()
  {
    button.val('Thanks!')
    $('<p style="clear:both;">We will be in touch soon.</p>').insertAfter(button);
    button.addClass('complete')
  });

}

function animate(element, animation, callback)
{
  element.addClass('animated ' + animation);
  element.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
    element.removeClass('animated ' + animation);
  });
  element.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', callback);
}