modulejs.define('fat_day', function(){
  Meal = modulejs.require('meal');
  FoodType = modulejs.require('food_type');

  return function(mealTypes, foodTypes){
    window.mt = mealTypes;
    var $mealItem,
        $carbonFootprint,
        $slider,
        //$gauge,
        $btnCarbonFootprint,
        showCarbonFootprint,
        fatDayFields,
        meals,
        foods;

    // $gauge = $('#gauge .gauge-arrow').cmGauge();

    // totalPoints = 0;
    // $('#gaugeDemo .gauge-arrow').trigger('updateGauge', NewValue);

    $mealItem = $('.meal-item');

    $btnCarbonFootprint = $('#btn-carbon-footprint');
    $carbonFootprint = $('#carbon-footprint');

    // fatDayFields is the JS object that tracks the state of the meal tracker
    // This object will be the payload sent to the service to create the required
    // resources rails side
    meals = {};
    foods = {};

    // Create meal objects
    for(var i = 0; i < mealTypes.length; i++){
      var id = mealTypes[i].id 
      var name = mealTypes[i].name;
      var size = 1;

      meals[name] = new Meal(id, name, size);
    }
    // window.meals = meals;
    // Create food type objects
    for(var i = 0; i < foodTypes.length; i++){
      var id = foodTypes[i].id;
      var category = foodTypes[i].category;
      foods[category] = new FoodType(id, category);
    }

    var sliderValueMap = ["Less", "Average", "More"];

    $slider = $( ".slider" ).slider({
      range: "min",
      animate: "fast",
      min:0,
      max: 2,
      step: 1,
      slide: function( event, ui ) {
        $(this).parent().siblings('#txt-meal-size').html(sliderValueMap[ui.value]);
        var meal_type = $(this).data('meal-type');
        meals[meal_type].setSize(ui.value);
        console.log(ui.value);
      }
    }).each( function(){
      $(this).slider({
        value: $(this).data('value')
      });
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
        meals[meal_type].addFood(foods[food_type]);
      }
      else {
        delete meals[meal_type].removeFood(foods[food_type]);
      }
    });

    $btnCarbonFootprint.on('click', function(){
      $(this).prop('disabled', true);
      console.log(meals);
      // // Send meal information to server
      // // Server will save info for meal_day
      // // Server responds with carbon footprint
      $.post( "/food-action-tracker", {meals: JSON.stringify(meals)}, "json")
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