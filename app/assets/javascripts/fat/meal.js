modulejs.define('meal', function() {
  return function(id, name, size) {
    this.id = id;
    this.size = size;
    this.name = name;
    this.foods = {};
    this.addFood = function(food) {
      this.foods[food.category] = food;
    };
    this.removeFood = function(food) {
      delete this.foods[food.category]
    };
    this.setSize = function(size) {
      this.size = size;
    };
  };
});