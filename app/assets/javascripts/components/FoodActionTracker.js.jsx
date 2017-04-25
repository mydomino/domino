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
      didntEat: (fatDay.meal_day.carbon_footprint == 1.06 && Object.keys(fatDay.foods).length == 0) ? true : false,
      results: !mealDayNull,
      nextView: false
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
      <div className='remodal-bg'>
        <div className='max-width-3 mx-auto p1'>
          <CarbonFootprint ref="cf"
            cf={this.state.meal_day.carbon_footprint}
            getCarbonFootprint={()=>this.getCarbonFootprint()}
            method={this.state.method} />

          <div className='bg-gray-1 clearfix rounded-bottom px2 pb2 relative'>

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
            </div> {/* end food-picker */}

            <div id="results-summary" className={(this.state.nextView ? "fadeIn" : "display-none") + " animated"}>

              <div className="bg-white mx2 my1 py2 rounded center">
                <span onClick={() => this.toggleView()} style={{top:'1.5rem'}} id="btn-food-picker" className="flex items-center ml2 mb0 pointer absolute">
                  <img src="/fat_icons/i-arrow-left.svg" className="icon-s inline mr1"/>
                  <h4 className="medium my0">Back</h4>
                </span>
                <h3 className="sm-h2 bold mb0 col-8 mx-auto" dangerouslySetInnerHTML={this.getResultTitle()}></h3>
                <div className="col-10 sm-col-8 mx-auto mb2" dangerouslySetInnerHTML={this.getCfResultString()}>

                </div>
                 <div className="mx-auto center my1">
                  <span data-target="#learn-more" className="line pointer ml1 line-height-1 smooth-scroll">Learn More</span>
                </div>
              </div>
              <div className="mx-auto center my2">
                <button data-target="#weekly-progress" className="btn btn-sm btn-primary btn-primary--hover smooth-scroll">See my progress this week</button>
                <span className="ml1 gray-5">
                  or <a href="/myhome" className="black line ml1 line-height-1">Back to My Home</a>
                </span>
              </div>
            </div> {/* end results-summary */}
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
  getResultTitle() {
    let cf = this.state.meal_day.carbon_footprint;
    result_title = ""
    if(cf <= 7) {
      result_title += "<span class='green'>"
      result_title += ["Well done!", "Hooray!", "Great job!", "Fabulous!"][Math.floor(Math.random() * 4)];
    }
    else if(cf >= 7 && cf < 8 ){
      result_title += "<span class='yellow'>"
      result_title += "It's okay, I guess...";
    }
    else {
      result_title += "<span class='red'>"
      result_title += "Doh!";
    }
    result_title += "</span>"
    return {__html: result_title };
  }
  getCfpPoints() {
    let percentAverageEmission = 1-(this.state.meal_day.carbon_footprint/7);
    let points = 0;

    if(percentAverageEmission >= 0.1 && percentAverageEmission < 1.0){
      points = percentAverageEmission * 100;
    }
    return points.toFixed();
  }
  getCfResultString() {
    let str =  "<p class='h4 sm-h4 mx-auto mt0'>Your Foodprint today is ";
    let cf = this.state.meal_day.carbon_footprint;
    let avgPercent = (cf/7) * 100;
    if(cf < 7) {
      let val = (100 - avgPercent).toFixed(0);
      str += "<span class='green'><span class='h3 bold'>" + val + "%</span> below</span> the American average."
    }
    else if(cf >= 7) {
      let val = (avgPercent - 100).toFixed(0);
      str += "<span class='red'><span class='h3 bold'>" + val + "%</span> above</span> the American average.";
    }
    else {
      str += "the American average";
    }
    str += "<p/>"

    str += "<div class='p1 bg-gray-2 mb2'><h3 class='my0'>You've earned <span class='h3 blue bold'>" + this.state.meal_day.points + " </span> points.</h3>";    
    str += "<ul class='p1 m0 list-style-none h5 gray-6'><li><span class='blue'>+" + this.getCfpPoints() + " points </span> for beating the average American Foodprint </li>";
    str+="<li><span class='blue'>+10 points</span> for logging today</li>";

    if(this.state.foods['3'] === undefined) {
      str+="<li class='my0'><span class='blue'>+5 points</span> for not having dairy </li>";
    }

    if(this.state.foods['6'] === undefined) {
      str+="<li class='my0'><span class='blue'>+10 points</span> for not having beef or lamb </li>";
    }

    str += "</ul></div>"

    if(cf < 7) {
      str += `
        <p class='h5 sm-h4 left-align mx-auto mt1'>
          <span class="bold">Did you know?</span><br/>
          Beef and lamb produce 5x more carbon emissions than chicken, so choose your meats wisely.
          Also, up to 40% of food produced is wasted, but you can help change that.
        </p>
      `;
    } else {
      str += `
        <p class='h5 sm-h4 left-align mx-auto mt1'>
          <span class="bold">How you can improve</span><br/>
          Try cutting back on beef or lamb. They produce 5x more carbon emission than chicken.
        </p>
      `;
    }

    return {__html: str };
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
  didntEat() {
    if(!this.state.didntEat) {
      let foods = Object.assign({}, this.state.foods);

      for (var food in foods) {
        let selector = "foodtype" + food;
        this.refs[selector].removeFood();
        delete foods[food];
      }

      this.setState({
        foods: foods,
        didntEat: true
      }, this.getCarbonFootprint);
    }
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
