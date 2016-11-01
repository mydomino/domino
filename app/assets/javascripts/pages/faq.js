window.MyDomino = window.MyDomino || {};
window.MyDomino.pages = window.MyDomino.pages || {};

window.MyDomino.pages["pages-faq"] = function(){
  $('#accordion').find('.accordion-toggle').click(function(){
    //Expand or collapse this panel
    if ( $(this).hasClass('closed') ){
      $('span.toggle', this).html("-");
      $('.accordion-toggle').addClass('closed');
      $(this).removeClass('closed');

    } else {
      $('span.toggle', this).html("+");
      $(this).addClass('closed');
    }
    // $('span.toggle').not($('span.toggle', this)).addClass('closed');
    $('span.toggle').not($('span.toggle', this)).html('+')
    $(this).next().slideToggle('fast');
    //Hide the other panels
    $(".accordion-content").not($(this).next()).slideUp('fast');
  });
};
