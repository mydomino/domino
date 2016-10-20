var init = function(){
  var dataScript = document.body.getAttribute("id");
  window.MyDomino = window.MyDomino || {};

  if (MyDomino.pages && MyDomino.pages[dataScript]) {
    MyDomino.currentPage = new MyDomino.pages[dataScript](args);
  }
}