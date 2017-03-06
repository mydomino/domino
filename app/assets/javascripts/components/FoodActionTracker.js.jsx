class FoodActionTracker extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      date: this.props.fatDay.date,
      method: (this.props.fatDay.meal_day.id == null) ? 'POST' : 'PATCH',
      meal_day: this.props.fatDay.meal_day,
      foods: this.props.fatDay.foods,
      didntEat: (this.props.fatDay.meal_day.carbon_footprint == 0) ? true : false
    };
  }
  addFood(f) {
    let food_base = {size: null, food_type_id: null};

    let foods = Object.assign({}, this.state.foods);
    let food = Object.assign(food_base, f);
    foods[food.food_type_id] = food;

    this.setState({
      foods: foods,
      didntEat: false
    },this.getCarbonFootprint);
  }
  removeFood(f) {

    let foods = Object.assign({}, this.state.foods);
    delete foods[f.food_type_id];

    this.setState({
      foods: foods
    }, this.getCarbonFootprint);
  }
  render() {
    var that = this;
    var foodTypes = this.props.fatDay.food_types.map(function(foodType, index){
                      return <FoodType  index={index}
                                        ref={"foodtype" + (index+1)}
                                        removeFood={(f)=>that.removeFood(f)} 
                                        addFood={(f)=>that.addFood(f)} 
                                        sizeInfo={that.props.foodSizeInfo[foodType.id]} 
                                        food={that.state.foods[foodType.id]} index={index} 
                                        key={foodType.name} 
                                        foodType={foodType} 
                                        updateFoodSize={(f)=>that.updateFoodSize(f)} />
                    });

    return (
      <div className='remodal-bg'>
        <CarbonFootprint ref="cf"
          cf={this.state.meal_day.carbon_footprint}
          getCarbonFootprint={()=>this.getCarbonFootprint()}
          method={this.state.method} />

        <div className='clearfix bg-white'>
          <div className='col-12 p2'>
            {foodTypes}
          </div>
        </div>

        <div className="flex flex-column sm-row justify-center mx2 mt1 mb0">
          <a onClick={()=>this.didntEat()} className="sm-mr2">
            <button id="btn-didnt-eat" 
                    className={(this.state.didntEat ? "border-none " : null) + "col col-12 btn btn-md btn-secondary"} 
                    style={{backgroundColor: (this.state.didntEat ? "white" : null), height:54}}>
              <span className="flex items-center justify-center">
                <img src="/fat_icons/i-empty.png" className="icon-m mr1"/>
                {"Didn't Eat"}
                </span>
            </button>
          </a>
          <a href={'/food/results/' + this.state.date.split("-").join("/")}>
            <button className="col-12 mt1 sm-mt0 btn btn-md btn-primary btn-primary--hover">Finish</button>
          </a>
        </div>
      </div>
    );
  }
  didntEat() {
    let foods = Object.assign({}, this.state.foods);

    for (var food in foods) {
      let selector = "foodtype" + food;
      this.refs[selector].setState({
        active: false
      });
      delete foods[food];
    }

    this.setState({
      foods: foods,
      didntEat: true
    }, this.getCarbonFootprint);
  }
  getCarbonFootprint(){
    // Ajax request to get cf calculation from server
    let that = this;
    
    // client side calculation of cf
    let foods = Object.assign({}, this.state.foods);
    let foodTypes = Object.assign({}, this.props.fatDay.food_types);

    let foodSizeCfs = [];
    for(let food in foods){
      let obj = foods[food];
      let foodTypeIndex = obj.food_type_id - 1;
      let foodType = foodTypes[foodTypeIndex];

      foodSizeCfs.push({size: obj.size, cf: foodType.carbon_footprint, avgSize: foodType.average_size});
    }
    carbon_footprint =  foodSizeCfs.map(function(el){
                                      return (el.cf*(el.size/100)*el.avgSize);
                                    }).reduce(function(a,b){
                                      return a + b;
                                    }, 0);

    carbon_footprint += 1064;
    carbon_footprint = +((carbon_footprint/1000).toFixed(2));
    that.refs.cf.setCarbonFootprint(carbon_footprint);

    $.post( "/food", { _method: that.state.method, fat_day: that.state }, "json")
      .done(function(data){
        that.setState({
          method: 'PATCH',
          meal_day: data.meal_day,
          foods: data.foods
        });
      })
      .fail(function(){ console.log('Error!'); });
  };
}
FoodActionTracker.defaultProps = {
  foodSizeInfo : {
    "1" : {
        // Fruits avg: 95 cal
        "0" : "None!",
        "50" : "Just a few pieces, around 50 calories",
        "100" : "Average, around 100 calories",
        "150" : "A lot, around 150 calories",
        "200" : "Fruit monster, around 200 calories"
    },
    "2" : {
      // Veg avg: 122 cal
      "0" : "None!",
      "50" : "Just a little, around 60 calories",
      "100" : "Average, around 120 calories",
      "150" : "A lot, around 180 calories",
      "200" : "A crap load, around 240 calories"
    },
    "3" : {
      // Dairy avg: 278 cal
      "0" : "None!",
      "50" : "Only a little, around 140 calories",
      "100" : "Average, around 280 calories",
      "150" : "A lot, around 420 calories",
      "200" : "I went nuts, around 560 calories"
    },
    "4" : {
      // Grains avg: 618 cal
      "0" : "None!",
      "50" : "A little bit, around 310 calories",
      "100" : "Average, around 620 calories",
      "150" : "More than average, around 930 calories",
      "200" : "I love my carbs! Around 1240 calories"
    },
    "5" : {
      // Fish, poultry, pork avg: 238 cal
      "0" : "None!",
      "50" : "Half portion, around 120 calories ",
      "100" : "Average, around 240 calories",
      "150" : "I had seconds, around 360 calories",
      "200" : "I pigged out! Around 480 calories"
    },
    "6" : {
      // Beef and lamb avg: 156 cal
      // a 12 oz steak is about 900 calories
      "0" : "None!",
      "50" : "Only a little bit, around 80 calories.",
      "100" : "Average, around 160 calories",
      "150" : "A burger, around 230 calories.",
      "200" : "A big burger, around 310 calories"
    }
  }
};
