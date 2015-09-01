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
  form = $('form');
  inputs = $('form input');
  inputs.attr('disabled', 'true')
  $('form input[type="submit"]').val('completed')
  //form.addClass('animated fadeOutDown').hide();
  //success = $('.success');
  //success.show().addClass('animated fadeInDown');
}

function animate(element, animation, callback)
{
  element.addClass('animated ' + animation);
  element.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
    element.removeClass('animated ' + animation);
  });
  element.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', callback);
}