modulejs.define('fat_day', function(){
  return function(){
    var $mealItem,
        $carbonFootprint,
        $slider,
        //$gauge,
        $btnCarbonFootprint,
        showCarbonFootprint,
        fatDayFields;
        // totalPoints;

    // $gauge = $('#gauge .gauge-arrow').cmGauge();

    // totalPoints = 0;
    // $('#gaugeDemo .gauge-arrow').trigger('updateGauge', NewValue);

    $mealItem = $('.meal-item');

    $btnCarbonFootprint = $('#btn-carbon-footprint');
    $carbonFootprint = $('#carbon-footprint');

    // fatDayFields is the JS object that tracks the state of the meal tracker
    // This object will be the payload sent to the service to create the required
    // resources rails side
    fatDayFields = {
      breakfast: {
        meal_size: 1
      },
      lunch: {
        meal_size: 1
      }, 
      dinner: {
        meal_size: 1
      }
    };

    var sliderValueMap = ["Less", "Average", "More"];

    $slider = $( ".slider" ).slider({
      range: "min",
      animate: "fast",
      min:0,
      max: 2,
      step: 1,
      value: 1,
      create: function( event, ui ) {
      },
      slide: function( event, ui ) {
        $(this).parent().siblings('#txt-meal-size').html(sliderValueMap[ui.value]);
        var meal_type = $(this).data('meal-type');
        fatDayFields[meal_type].meal_size = ui.value;
      }
    });

    showCarbonFootprint = function(){
      $btnCarbonFootprint.fadeOut('slow', function(){
        $carbonFootprint.html("<h1 class='gray-80'>10 lbs C02</h1>");
        $carbonFootprint.fadeIn('slow');
      });
    };


    $mealItem.on('click', function(e){
      $(this).toggleClass('bg-blue bg-white');
      var food_type = $(this).data('food-type');
      var meal_type = $(this).data('meal-type');
      
      if($(this).hasClass('bg-blue')){
        fatDayFields[meal_type][food_type] = {portion: 50};
      }
      else {
        delete fatDayFields[meal_type][food_type]
      }
      // debuggin
      window.fatDayFields = fatDayFields;
    });

    $btnCarbonFootprint.on('click', function(){
      $(this).prop('disabled', true);
      // Send meal information to server
      // Server will save info for meal_day
      // Server responds with carbon footprint
      $.post( "/food-action-tracker", fatDayFields )
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