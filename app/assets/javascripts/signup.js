function track_lead_creation()
{
  ga('send', 'event', 'lead', 'created');
  _fbq.push(['track','6031072723663',{}]);
  heap.track('lead creation', {});
  window['optimizely'] = window['optimizely'] || [];
  window['optimizely'].push(["trackEvent", "leadCreated"]);
}
function animate_form_success()
{
  form = $('form');
  form.addClass('animated fadeOutDown');
  success = $('.success');
  success.show().addClass('animated fadeInDown');
}