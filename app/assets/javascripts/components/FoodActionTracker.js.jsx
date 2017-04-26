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
      graph_params: fatDay.graph_params,
      results: !mealDayNull,
      nextView: false
    };
  }
  updateFoods(foods) {
    this.setState({
        foods: foods
      }, function(){this.getCarbonFootprint()}
    );
  }
  updateGraph(d) {
    this.refs.results.updateGraph(d);
  }
  render() {
    var that = this;
    return (
      <div className='remodal-bg'>
        <div className='max-width-3 mx-auto p1'>
          <CarbonFootprint ref="cf"
            cf={this.state.meal_day.carbon_footprint}
            getCarbonFootprint={()=>this.getCarbonFootprint()}
            method={this.state.method} />

          <div className='bg-gray-1 clearfix rounded-bottom px2 pb2 relative'>

            <FoodPicker ref='foodPicker'
                        nextView={this.state.nextView}
                        foodTypes={this.props.fatDay.food_types}
                        foods={this.state.foods}
                        foodSizeInfo={this.props.foodSizeInfo} 
                        updateFoods={(f)=>this.updateFoods(f)}
                        removeFood={(f)=>this.removeFood(f)} />

            <ResultsSummary nextView={this.state.nextView}
                            toggleView={()=>this.toggleView()}
                            carbonFootprint={this.state.meal_day.carbon_footprint}
                            points={this.state.meal_day.points}
                            foods={this.state.foods} />

          </div>
        </div>
        <div className="center mt1 mb3">
          <a onClick={()=>this.toggleView()} >
            <button disabled={!this.state.results} style={{display: (this.state.nextView ? "none" : "inherit")}} className={(this.state.results ? "btn-primary--hover " : "") + "btn btn-lg btn-primary bold"}>See results</button>
          </a>
        </div>
        <div className={((this.state.nextView) ? "inherit" : "display-none")}>
          <Results ref="results" prevWeek={this.props.fatDay.prev_week} graph_params={this.props.fatDay.graph_params} />
        </div>
      </div>
    );
  }
  componentDidMount() {
    $('.smooth-scroll').on('click', function(){
      var target = $(this).data("target");
      $('html, body').animate({
          scrollTop: $(target).offset().top
        },
        1000,
        $.noop
      );
    });
  }
  componentWillUnmount() {
    $('.smooth-scroll').unbind('click');
  }
  toggleView() {
    this.setState({
      nextView: !this.state.nextView
    });
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
    // Fruits
    "1" : {
        // Fruits avg: 95 cal
        "50" : {
                  details: "A fruit-ish (~50 calories)",
                  examples: "Half of an orange, apple, or banana, or a cup of grapes"
                },
        "100" : {
                  details: "One average fruit (~100 calories)",
                  examples: "A baseball-size orange or apple. Or a 7\" banana"
                },
        "150" : {
                  details: "A healthy portion (~150 calories)",
                  examples: "1 cup of fruit salad, or 1.5 medium-size oranges, apples, or bananas"
                },
        "200" : {
                  details: "A couple fruits (~200 calories)",
                  examples: "2 oranges, 2 apples, or 2 bananas"
                },
        "300" : {
                  details: "Fruit monster! (~300 calories)",
                  examples: "A medium (24oz) fruit smoothie, or 3 medium oranges, apples, or bananas"
                }
    },
    // Vegetables
    "2" : {
      // Veg avg: 122 cal
      "50" :  {
                details: "A small portion (~60 calories)",
                examples: "2 medium carrots, 1 head of lettuce, 1 medium onion, or 4 cups of mixed green salad"
              },
      "100" : {
                details: "An average portion (~120 calories)",
                examples: "1 can of tomato sauce or 1 cup of vegetable stir-fry"
              },
      "150" : {
                details: "A healthy portion (~180 calories)",
                examples: "1 medium potato or 6 medium carrots"
              },
      "200" : {
                details: "A vegetarian's dream! (~240 calories)",
                examples: "80 button mushrooms or 1 small serving of fries"
              }
    },
    // Dairy
    "3" : {
      // Dairy avg: 278 cal
      "50" : {
                details: "A small portion (~140 calories)",
                examples: "1 slice of cheese, 1 cup of yogurt, or 1 cup of milk"
              },
      "100" : {
                details: "An average portion (~280 calories)",
                examples: "2 cups of milk, 1 cup of ice cream, or 2/3 cup of shredded cheese"
              },
      "150" : {
                details: "Several items or more than a cup (~420 calories)",
                examples: "3 cups of milk, 1.5 cups of ice cream, 1 cup of shredded cheese"
              },
      "200" : {
                details: "More than a few items (~560 calories)",
                examples: "1 medium (15-oz) milkshake (e.g. from McDonald's)"
              }
    },
    // Grains
    "4" : {
      // Grains avg: 618 cal
      "50" :  {
                details: "A cup or two (~310 calories)",
                examples: "1.5 cup of rice or pasta noodles, 2 cups of oatmeal, 4 slices of bread"
              },
      "100" : {
                details: "An average amount (~620 calories)",
                examples: "2 cups of breakfast cereal or 3 cups of rice"
              },
      "150" : {
                details: "More than average (~930 calories)",
                examples: "A 7-oz bag of corn chips, 1 baguette, or 4 cups of pasta"
              },
      "200" : {
                details: "Can't get enough carbs (~1240 calories)",
                examples: "Well, 2 cups of rice or pasta = ~400 calories. You do the math!"
              }
    },
    // Fish, poultry, pork
    "5" : {
      // Fish, poultry, pork avg: 238 cal
      "50" : {
                details: "Half portion (~120 calories)",
                examples: "1/2 chicken breast, 1/2 flat can of tuna, or 3 slices of bacon"
              },
      "100" : {
                details: "An average portion (~240 calories)",
                examples: "1 chicken breast, 6 chicken wings, or 1 flat can of tuna"
              },
      "150" : {
                details: "A large portion (~360 calories)",
                examples: "1 fillet of fish or 4 scrambled eggs"
              },
      "200" : {
                details: "An extra-large portion (~480 calories)",
                examples: "An 8-oz pork chop, or half a roasted chicken"
              }
    },
    // Beef, lamb
    "6" : {
      // Beef and lamb avg: 156 cal
      // a 12 oz steak is about 900 calories
      "50" : {
                details: "A few bites (~80 calories)",
                examples: "1 small meatball"
              },
      "100" : {
                details: "A small portion (~160 calories)",
                examples: "2 medium meatballs"
              },
      "150" : {
                details: "An average portion (~230 calories)",
                examples: "A quarter-pound hamburger patty, or a 3-oz lamb chop"
              },
      "200" : {
                details: "A large burger (~310 calories)",
                examples: "A 1/3-pound hamburger patty, or one cup of diced beef / lamb"
              }
    }
  }

};
