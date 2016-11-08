window.MyDomino = window.MyDomino || {};
window.MyDomino.pages = window.MyDomino.pages || {};

window.MyDomino.pages["profile_steps-checkout"] = function(args){
    $('#btn-apply').on('click', function(){
      var partnerCode = $('#profile_partner_code').val();
      $.ajax({
        type: "POST",
        url: '/profiles/' + args.checkout.profileId + '/apply-partner-code',
        data: { '_method':'PUT', 'profile': {'partner_code': partnerCode }},
        dataType: "script" // you want a difference between normal and ajax-calls, and json is standard
      }).success(function(json){
          console.log("success", json);
      });
    });

    singleSubmit();
    //mobile
    $(window).scrollTop(0)
};