modulejs.define('myhome', function(){
  return function() {
    var $wtLink;

    $wtLink = $('#wt-link');
    
    $wtLink.on('click', function() {
      alert('test');
    });
  };
});