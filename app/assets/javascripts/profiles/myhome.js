modulejs.define('myhome', function(){
  return (function() {    
    $(document).ready(function(){
      $('li.complete, li.incomplete').on('click', function(){
        window.location = $(this).data('link');
      });
    });
  }());
});