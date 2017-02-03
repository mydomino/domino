class FoodActionTracker extends React.Component {
  componentWillMount(){
    this.setState({
      date: this.props.fatDay.date,
      method: (this.props.fatDay.meal_day == null) ? 'POST' : 'PATCH',
      meal_day: this.props.fatDay.meal_day
    }); 
  }

  updateMealSize(n, meal){
    let meals = this.state.meals.slice();
    let index = meals.findIndex(x => x.meal_type_id === meal.meal_type_id);
    meals[index].size = n;
    this.setState({
      meals: meals
    });
  }
  
  toggleFood(food){
    let meals = this.state.meals.slice();
    let index = meals.findIndex(x => x.meal_type_id === food.meal_type_id);
    let food_index = meals[index].foods.findIndex(x => x.food_type_id === food.id);

    if(food_index !== -1){
      meals[index].foods.splice(food_index, 1);
    }
    else {
      meals[index].foods.push({food_type_id: food.id });
    }

    this.setState({
      meals: meals
    });
  }
  render() {
    var that = this;
    var foodTypes = this.props.foodTypes.map(function(foodType, index){
                      return <FoodType index={index} key={foodType.name} foodType={foodType} toggleFood={(food)=>that.props.toggleFood(food)} />
                    });
    return (
      <div>
        <div className='border rounded clearfix'>
          {meals}
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
            meals: data.meals,
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
FoodActionTracker.defaultProps = {
  mealSizeMap : ["small", "medium", "large"]
};