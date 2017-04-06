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
                <h3 className="h4 sm-h3 bold mb0 col-8 mx-auto gray-7">{ this.getResultTitle() }</h3>
                <div className="col-10 sm-col-8 mx-auto" dangerouslySetInnerHTML={this.getCfResultString()}>

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
          <Results ref="results" graph_params={this.props.fatDay.graph_params} />
        </div>
      </div>
    );
  }
  getResultTitle() {
    let cf = this.state.meal_day.carbon_footprint;

    if(cf <= 7) {

      return ["Well done!", "Hooray!", "Great job!", "Fabulous!"][Math.floor(Math.random() * 4)];
    } 
    else if(cf >= 7 && cf < 8 ){
      return "It's okay, I guess...";
    }
    else {
      return "Doh!";
    }
  }
  getCfResultString() {
    let str =  "<p class='h5 sm-h4 left-align mx-auto mt1'>Your Foodprint today is ";
    let cf = this.state.meal_day.carbon_footprint;
    let avgPercent = (cf/7) * 100;
    if(cf < 7) {
      let val = (100 - avgPercent).toFixed(0);
      str += "<span class='h3 blue bold'>" + val + "%</span> below the American average."
    }
    else if(cf >= 7) {
      let val = (avgPercent - 100).toFixed(0);
      str += "<span class='h3 red bold'>" + val + "%</span> above the American average.";
    }
    else {
      str += "the American average";
    }
    str += "<p/><p>You've earned <span class='h3 blue bold'>" + this.state.meal_day.points + " </span> points.</p>";

    if(cf < 7) {
      str += `
        <p class='h5 sm-h4 left-align mx-auto mt1'>
          <span class="bold">Did you know?</span><br/>
          Beef and Lamb produces 5x more carbon emission than chicken, so choose your meats wisely.
          Also, up to 40% of food produced is wasted, but you can help change that.
        </p>
      `;
    } else {
      str += `
        <p class='h5 sm-h4 left-align mx-auto mt1'>
          <span class="bold">How you can improve</span><br/>
          Try cutting back on beef or lamb. They produces 5x more carbon emission than chicken.”
        </p>
      `;
    }

    str += `
      <div className="mx-auto center my1">
        <span className="ml1">
          <span data-target="#learn-more" className="line pointer ml1 line-height-1 smooth-scroll">Learn More</span>
        </span>
      </div>
    `

    // return $(str);
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
                  details: "Just a few pieces (~50 calories)",
                  examples: "Half of an orange, apple, or banana. Or a cup of grapes"
                },
        "100" : {
                  details: "An average amount (~100 calories)",
                  examples: "A baseball size orange or apple. Or a medium (7\") banana"
                },
        "150" : {
                  details: "A healthy amount (~150 calories)",
                  examples: "1 cup of fruit salad, or 1.5 oranges, apples, or bananas (medium sizes)"
                },
        "200" : {
                  details: "A lot (~200 calories)",
                  examples: "2 oranges. 2 apples. 2 bananas"
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
                details: "Some (~60 calories)",
                examples: "2 medium carrots, 1 head of lettuce, 1 medium onion, or 4 cups of mixed green salad"
              },
      "100" : {
                details: "An average amount (~120 calories)",
                examples: "1 ear of medium corn, 1 can of tomato sauce, or 1 cup of vegetable stir-fry"
              }, 
      "150" : {
                details: "A healthy amount (~180 calories)",
                examples: "1 medium potato, a hand full of corn chips, or 6 medium carrots"
              }, 
      "200" : {
                details: "A vegetarian's dream! (~240 calories)",
                examples: "1/3 cup of corn, 80 button mushrooms, or 1 small serving of french fries"
              }
    },
    // Dairy
    "3" : {
      // Dairy avg: 278 cal
      "50" : {
                details: "Only a little (~140 calories)",
                examples: "1 slice of cheese, 1 cup of yogurt, or 1 cup of milk"
              },
      "100" : {
                details: "An average amount (~280 calories)",
                examples: "2 cup of milk, 1 cup of ice cream, or 2/3 cup of shredded cheese"
              },
      "150" : {
                details: "A lot (~420 calories)",
                examples: "3 cups of milk, 1.5 cups of ice cream, 1 cup of shredded cheese"
              },
      "200" : {
                details: "I went a bit nuts (~560 calories)",
                examples: "1 medium (15oz) milkshake (e.g. from In-n-out or McDonalds)"
              }
    },
    // Grains
    "4" : {
      // Grains avg: 618 cal
      "50" :  {
                details: "A little bit (~310 calories)",
                examples: "1.5 cup of rice or pasta noodles, 2 cups of oatmeal, 4 slices of bread"
              },
      "100" : {
                details: "An average amount (~620 calories)",
                examples: "1 cup of pinto beans, 2 cups of breakfast cereal, 3 cups of rice, or 3 doughnuts"
              },
      "150" : {
                details: "More than average (~930 calories)",
                examples: "1 baguette, 7 cupcakes, or 4 cups of pasta"
              },
      "200" : {
                details: "Can't get enough carbs (~1240 calories)",
                examples: "Whoa there... For reference, 2 cups of rice or pasta is around 400 calories. We'll let you do the math"
              }
    },
    // Fish, poultry, pork
    "5" : {
      // Fish, poultry, pork avg: 238 cal
      "50" : {
                details: "Half portion (~120 calories)",
                examples: "1/2 chicken breast, 3 chicken wings, or 3 slices of bacon"
              },
      "100" : {
                details: "An average amount (~240 calories)",
                examples: "1 chiken breast, 6 chicken wings, 1 flat can of tuna or salmon"
              },
      "150" : {
                details: "I had seconds (~360 calories)",
                examples: "1 fillet of fish, 4 scrambled eggs"
              },
      "200" : {
                details: "I pigged out! (~480 calories)",
                examples: "An 8 oz pork chop, half a rosted chicken"
              }
    },
    // Beef, lamb
    "6" : {
      // Beef and lamb avg: 156 cal
      // a 12 oz steak is about 900 calories
      "50" : {
                details: "Only a few bites (~80 calories)",
                examples: "1 oz of cooked beef or lamb"
              },
      "100" : {
                details: "A little bit (~160 calories)",
                examples: "A couple of medium meatballs"
              },
      "150" : {
                details: "A burger (~230 calories)",
                examples: "A quarter pound hamberger patty, or a 3oz lamb chop"
              },
      "200" : {
                details: "A large burger (~310 calories)",
                examples: "A 1/3 pound hamberger patty, or one cup of diced beef / lamb"
              }
    }
  }
  
};
