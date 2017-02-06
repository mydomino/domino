class FoodActionTracker extends React.Component {
  componentWillMount(){
    this.setState({
      date: this.props.fatDay.date,
      method: (this.props.fatDay.meal_day == null) ? 'POST' : 'PATCH',
      meal_day: this.props.fatDay.meal_day,
      foods: this.props.fatDay.foods
    }); 
  }
  
  updateFoodSize(f){
    let food_base = {size: null, food_type_id: null};

    let foods = Object.assign({}, this.state.foods);
    let food = Object.assign(food_base, f);

    if (food.size > 0) {
      foods[food.food_type_id] = food;
    }
    else {
      delete foods[food.food_type_id];
    }

    this.setState({
      foods: foods
    });
  }

  render() {
    var that = this;
    var foodTypes = this.props.fatDay.food_types.map(function(foodType, index){
                      return <FoodType food={that.state.foods[foodType.id]} index={index} key={foodType.name} foodType={foodType} updateFoodSize={(f)=>that.updateFoodSize(f)} />
                    });
    return (
      <div className='remodal-bg'>
        <div className='clearfix p2'>
          <div className='col-12'>
            {foodTypes}
          </div>
        </div>          
        <div className="my2 center">
          <button id='btn-carbon-footprint' className='btn btn-md btn-primary btn-primary--hover'>Find out my carbon footprint</button>
        </div>
      </div>
    );
  }
  componentDidMount() {
    var that=this;
    $('#btn-carbon-footprint').on('click', function(){
      $.post( "/food-action-tracker", { _method: that.state.method, fat_day: that.state }, "json")
        .done(function(data){
          that.setState({
            method: 'PATCH',
            meal_day: data.meal_day,
            foods: data.foods
          });
          that.showCarbonFootprint(); 
        })
        .fail(function(){ console.log('Error!'); });
    });
  }
  showCarbonFootprint(){
    alert('cf');
  }
}
