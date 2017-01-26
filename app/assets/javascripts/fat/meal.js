modulejs.define('meal', function(){
  
  return {
    proto: {
      size: 1,
      foods: {}
    },
    makeMeal: function(name){
      var meal = Object.create(this.proto);
      meal.name = name;
      return meal;
    }
  };

});