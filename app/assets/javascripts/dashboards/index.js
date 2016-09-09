window.MyDomino = window.MyDomino || {};
window.MyDomino.pages = window.MyDomino.pages || {};

window.MyDomino.pages["dashboards-index"] = function(){
  var clipboard = new Clipboard('.fa-link');

  clipboard.on('success', function(e) {
    alert('Sign up link copied to clipboard.')
  });

  $('.dashboard-record').hover(function () {
      $(this).find('.fa-times').removeClass('display-none');
      $(this).addClass('bg-gray-05');
    }, function () {
      $(this).find('.fa-times').addClass('display-none');
      $(this).removeClass('bg-gray-05');
    }
  );
};