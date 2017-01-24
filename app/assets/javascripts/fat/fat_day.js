modulejs.define('fat_day', function(){
  return function(){
    var $mealItem,
        $mealSize,
        $carbonFootprint,
        //$gauge,
        $btnCarbonFootprint,
        showCarbonFootprint;
        // totalPoints;

    // $gauge = $('#gauge .gauge-arrow').cmGauge();

    // totalPoints = 0;
    // $('#gaugeDemo .gauge-arrow').trigger('updateGauge', NewValue);

    $mealItem = $('.meal-item');
    $mealSize = $('.meal-size');

    $btnCarbonFootprint = $('#btn-carbon-footprint');
    $carbonFootprint = $('#carbon-footprint')

    showCarbonFootprint = function(){
      $btnCarbonFootprint.fadeOut('slow', function(){
        $carbonFootprint.html("<h1 class='gray-80'>10 lbs C02</h1>");
        $carbonFootprint.fadeIn('slow');
      });
    };

    $mealItem.on('click', function(){
      $(this).toggleClass('bg-blue bg-white');
    });

    $mealSize.on('click', function(){
      var mealType = $(this).data('meal-type');
      $(this).toggleClass('bg-blue bg-white');
      $('.meal-size[data-meal-type="' + mealType + '"]').not(this).removeClass('bg-blue').addClass('bg-white');
    });

    $btnCarbonFootprint.on('click', function(){
      $(this).prop('disabled', true);
      // Send meal information to server
      // Server will save info for meal_day
      // Server responds with carbon footprint
      $.post( "/food-action-tracker", { name: "John", time: "2pm" } )
        .done(function(){ showCarbonFootprint(); })
        .fail(function(){ console.log('Error!'); });
    });

    // $mealItem.on('click', function(){
    //   var $this = $(this);
    //   var points = $(this).data('points');

    //   $(this).toggleClass('bg-white bg-blue');
    //   if($this.hasClass('bg-blue')){
    //     totalPoints += points;
    //   }else{
    //     totalPoints -= points;
    //   }
    //   $('#gauge .gauge-arrow').trigger('updateGauge', totalPoints);
    // });

  };
});