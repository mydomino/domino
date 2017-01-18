function track_lead_creation()
{
  ga('send', 'event', 'lead', 'created');
  //_fbq.push(['track','6028103428047',{}]);
  //heap.track('lead creation', {});
  // window['optimizely'] = window['optimizely'] || [];
  // window['optimizely'].push(["trackEvent", "leadCreated"]);
  //goog_report_conversion();
}
// function animate_form_success(thankYouText)
// {
//   $('.errors').hide()
//   var form = $('form');
//   var inputs = $('form input');
//   var button = $('form input[type="submit"]');

//   setTimeout(function()
//   {
//     button.val('Thanks!')
//     $('<p style="clear:both;">'+thankYouText+'</p>').insertAfter(button);
//     button.addClass('complete')
//     inputs.attr('disabled', 'true')
//   });

// }

// function animate(element, animation, callback)
// {
//   element.addClass('animated ' + animation);
//   element.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
//     element.removeClass('animated ' + animation);
//   });
//   element.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', callback);
// }