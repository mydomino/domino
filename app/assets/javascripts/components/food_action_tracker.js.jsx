class FoodActionTracker extends React.Component {
  componentWillMount(){
    this.setState({
      date: this.props.fatDay.date,
      method: (this.props.fatDay.meal_day == null) ? 'POST' : 'PATCH',
      meal_day: this.props.fatDay.meal_day,
      foods: this.props.fatDay.foods
    }); 
  }
  
  updateFoodSize(food){
    let foods = this.state.foods;

    if (food.newSize > 0) {
      foods[food.id] = food.newSize;
    }
    else {
      delete foods[food.id]
    }

    this.setState({
        foods: foods
    });
  }

  render() {
    var that = this;
    var foodTypes = this.props.fatDay.food_types.map(function(foodType, index){
                      return <FoodType index={index} key={foodType.name} foodType={foodType} updateFoodSize={(f)=>that.updateFoodSize(f)} />
                    });
    return (
      <div className='remodal-bg'>
        <div className='border border-gray-30 rounded clearfix p2'>
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
      $.post( "/food-action-tracker", { _method: that.state.method, fat_day: that.state, meal_day: that.state.meal_day }, "json")
        .done(function(data){
          that.setState({
            method: 'PATCH',
            meal_day: data.meal_day
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
