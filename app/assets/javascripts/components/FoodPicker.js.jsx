class FoodPicker extends React.Component {
  //didntEat: (fatDay.meal_day.carbon_footprint == 1.06 && Object.keys(fatDay.foods).length == 0) ? true : false,
  constructor(props){
    super(props);

    this.state = {
      nextView: false,
      didntEat: false,
      foods: this.props.foods
    }
  }
  didntEat() {
    let foods = Object.assign({}, this.state.foods);

    for (var food in foods) {
      let selector = "foodtype" + food;
      this.refs[selector].removeFood();
      delete foods[food];
    }
    this.setState(
      {
        foods: foods,
        didntEat: true
      }, 
      this.props.updateFoods(foods)
    );
  }
  addFood(f) {
    let food_base = {size: null, food_type_id: null};
    let food = Object.assign(food_base, f);

    let foods = Object.assign({}, this.state.foods);
    foods[food.food_type_id] = food;

    this.setState(
      {
        foods: foods,
        didntEat: false
      }, 
      this.props.updateFoods(foods)
    );
  }
  removeFood(f) {
    let foods = Object.assign({}, this.state.foods);
    delete foods[f.food_type_id];
    
    this.setState(
      {
        foods: foods
      }, this.props.updateFoods(foods)
    );
  }
  render() {
    var that = this;
    var foodTypes = this.props.foodTypes.map(function(foodType, index){
                      return <FoodType  index={index}
                                        ref={"foodtype" + (index+1)}
                                        removeFood={(f)=>that.removeFood(f)}
                                        addFood={(f)=>that.addFood(f)}
                                        sizeInfo={that.props.foodSizeInfo[foodType.id]}
                                        food={that.state.foods[foodType.id]} 
                                        index={index}
                                        key={foodType.name}
                                        foodType={foodType} />
                    });
    return (
      <div id="food-picker" className={((this.state.nextView) ? "display-none fadeOut" : "fadeIn") + " animated"}>
        <div className='col-12 p2'>
          {foodTypes}
        </div>
        <div className="center p2">
         <a onClick={()=>this.didntEat()} >
            <button id="btn-didnt-eat"
              className={(this.state.didntEat ? "border " : null) + " fill-x mt1 btn btn-sm btn-secondary border-gray-2"}
              style={{backgroundColor: (this.state.didntEat ? "#00ccff" : "white"), height:54}} >

              <span className="flex items-center justify-center">
                <img src="/fat_icons/i-empty.png" className="icon-m mr1"/>
                {"I ate none of these"}
              </span>
            </button>
          </a>
        </div>
      </div> 
    );
  }
}
