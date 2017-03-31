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

              <span onClick={() => this.toggleView()} style={{top:'-1.4rem'}} id="btn-food-picker" className="flex items-center ml2 mb0 pointer absolute">
                <img src="/fat_icons/i-arrow-left.svg" className="icon-s inline mr1"/>
                <h4 className="medium my0">Back</h4>
              </span>
              <div className="bg-white mx2 my1 py2 rounded center">
                <h3 className="h4 sm-h3 bold mb0 col-8 mx-auto">{ this.getResultTitle() }</h3>
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
      return "Not bad, I guess...";
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
      let val = (100 - avgPercent).toFixed(2);
      str += val + "% below the American average."
    }
    else if(cf >= 7) {
      let val = (avgPercent - 100).toFixed(2);
      str += val + "% above the American average.";
    }
    else {
      str += "the American average";
    }
    str += "<br/>You've earned " + this.state.meal_day.points + " points</p>";

    if(cf > 7) {
      str += `
        <p class='h5 sm-h4 left-align mx-auto mt1'>
          <span class="bold">Did you know?</span><br/>
          Beef and Lamb produces 5x more carbon emission than chicken, so choose your meats wisely.
          Also, up to 40% of food produced is wasted…
        </p>
        <p class='h5 sm-h4 left-align mx-auto mt1'>
          <span class="bold">How you can improve</span><br/>
          Try cutting back on beef or lamb. They produces 5x more carbon emission than chicken.”
        </p>
      `;
    }

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
                  details: "Just a few pieces, around 50 calories",
                  examples: "An orange. 1/2 an apple. 1/2 a banana."
                },
        "100" : {
                  details: "Average, around 100 calories",
                  examples: "Two oranges. An apple. A banana."
                },
        "150" : {
                  details: "A lot, around 150 calories",
                  examples: "2.5 oranges. 1.5 Apples. 1.5 bananas."
                },
        "200" : {
                  details: "Fruit monster, around 200 calories",
                  examples: "4 oranges. 2 apples. 2 bananas."
                }
    },
    // Vegetables
    "2" : {
      // Veg avg: 122 cal
      "50" :  {
                details: "Just a little, around 60 calories",
                examples: "2 carrots. A head of lettuce. An onion"
              },
      "100" : {
                details: "Average, around 120 calories",
                examples: "Ex, qui! Rem voluptates, harum sint ad sapiente debitis."
              }, 
      "150" : {
                details: "A lot, around 180 calories",
                examples: "Quaerat nihil fugit deleniti ipsam nisi."
              }, 
      "200" : {
                details: "A crap load, around 240 calories",
                examples: "In at iure excepturi praesentium tempora rerum?"
              } 
    },
    // Dairy
    "3" : {
      // Dairy avg: 278 cal
      "50" : {
                details: "Only a little, around 140 calories",
                examples: "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
              },
      "100" : {
                details: "Average, around 280 calories",
                examples: "Ex, qui! Rem voluptates, harum sint ad sapiente debitis."
              },
      "150" : {
                details: "A lot, around 420 calories",
                examples: "Quaerat nihil fugit deleniti ipsam nisi."
              },
      "200" : {
                details: "I went nuts, around 560 calories",
                examples: "In at iure excepturi praesentium tempora rerum?"
              }
    },
    // Grains
    "4" : {
      // Grains avg: 618 cal
      "50" :  {
                details: "A little bit, around 310 calories",
                examples: "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
              },
      "100" : {
                details: "Average, around 620 calories",
                examples: "Ex, qui! Rem voluptates, harum sint ad sapiente debitis."
              },
      "150" : {
                details: "More than average, around 930 calories",
                examples: "Quaerat nihil fugit deleniti ipsam nisi."
              },
      "200" : {
                details: "I love my carbs! Around 1240 calories",
                examples: "In at iure excepturi praesentium tempora rerum?"
              }
    },
    // Fish, poultry, pork
    "5" : {
      // Fish, poultry, pork avg: 238 cal
      "50" : {
                details: "Half portion, around 120 calories ",
                examples: "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
              },
      "100" : {
                details: "Average, around 240 calories",
                examples: "Ex, qui! Rem voluptates, harum sint ad sapiente debitis."
              },
      "150" : {
                details: "I had seconds, around 360 calories",
                examples: "Quaerat nihil fugit deleniti ipsam nisi."
              },
      "200" : {
                details: "I pigged out! Around 480 calories",
                examples: "In at iure excepturi praesentium tempora rerum?"
              }
    },
    // Beef, lamb
    "6" : {
      // Beef and lamb avg: 156 cal
      // a 12 oz steak is about 900 calories
      "50" : {
                details: "Only a little bit, around 80 calories.",
                examples: "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
              },
      "100" : {
                details: "Average, around 160 calories",
                examples: "Ex, qui! Rem voluptates, harum sint ad sapiente debitis."
              },
      "150" : {
                details: "A burger, around 230 calories.",
                examples: "Quaerat nihil fugit deleniti ipsam nisi."
              },
      "200" : {
                details: "A big burger, around 310 calories",
                examples: "In at iure excepturi praesentium tempora rerum?"
              }
    }
  }
  
};
