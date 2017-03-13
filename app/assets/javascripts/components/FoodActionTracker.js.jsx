class FoodActionTracker extends React.Component {
  constructor(props){
    super(props);

    let fatDay = this.props.fatDay;
    let mealDayNull = fatDay.meal_day.id == null ? true : false;

    this.state = {
      date: fatDay.date,
      method: mealDayNull ? 'POST' : 'PATCH',
      meal_day: fatDay.meal_day,
      foods: fatDay.foods,
      didntEat: (fatDay.meal_day.carbon_footprint == 1.06 && Object.keys(fatDay.foods).length == 0) ? true : false,
      results: !mealDayNull,
      nextView:!mealDayNull
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
  updateGraph(d) {
    this.refs.results.updateGraph(d);
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
      <div className='remodal-bg '>
        <div className='max-width-3 mx-auto py2'>
          <CarbonFootprint ref="cf"
            cf={this.state.meal_day.carbon_footprint}
            getCarbonFootprint={()=>this.getCarbonFootprint()}
            method={this.state.method} />

          <div className='clearfix rounded-bottom bg-white p2 relative'>
            
            <div id="food-picker" style={{zIndex: 1}} style={{opacity: (this.state.nextView ? 0 : 1)}}>
              <div className='col-12 p2'>
                {foodTypes}
              </div>
              <div className="center px2">
               <a onClick={()=>this.didntEat()} >
                  <button id="btn-didnt-eat"
                    className={(this.state.didntEat ? "border " : null) + " fill-x mt2 btn btn-md btn-secondary"}
                    style={{backgroundColor: (this.state.didntEat ? "#00ccff" : "white"), height:54}} >

                    <span className="flex items-center justify-center">
                      <img src="/fat_icons/i-empty.png" className="icon-m mr1"/>
                      {"Ate none of these"}
                    </span>
                  </button>
                </a>
              </div>
            </div> {/* end food-picker */}

            <div id="results-summary" className={(this.state.nextView ? "" : "hidden ") + "absolute center top-0 left-0 right-0 p2"} style={{opacity: (this.state.nextView ? 1 : 0)}}>
              <h1>What it means</h1>
              <hr/>
              <p className="left-align">
                Quisque porta orci ac diam maximus blandit. Nullam in libero ante. Donec nec ante lorem. Lorem ipsum dolor sit amet,
                consectetur adipiscing elit. Praesent consequat, orci eu tempus sodales, risus massa aliquet velit, a faucibus felis
                nisl vel velit. Integer interdum quis nisi eu pretium. Donec congue massa eget nulla ultricies semper.
              </p>
              <button onClick={() => this.showFoodPicker()} id="btn-food-picker" className="btn btn-md btn-primary btn-primary--hover">Back</button>
            </div> {/* end results-summary */}
          </div>
        </div> 
        <div className="flex flex-column sm-row justify-center m2 mb0">
          <a onClick={()=>this.getResults()} >
            <button disabled={!this.state.results} style={{visibility: (this.state.nextView ? "hidden" : "visible")}} className={(this.state.results ? "btn-primary--hover " : "") + "btn btn-md btn-primary"}>See results</button>
          </a>
        </div>
        <div className={((this.state.results) ? "block" : "display-none")}>
          <Results ref="results" graph_params={this.props.fatDay.graph_params} />
        </div>
      </div>
    );
  }
  showFoodPicker() {
    this.setState({
      nextView: false
    });
  }
  getResults() {
    this.setState({
      nextView: true
    });
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
          foods: data.foods,
          graph_params: data.graph_params,
          results: true
        }, function(){
          this.updateGraph(this.state.graph_params);
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
