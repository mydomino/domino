class FoodActionTracker extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      date: null,
      meals: [],
      method: null // PUT or POST
    };
  }
  componentWillMount(){
    this.setState({
      date: this.props.fatDay.date,
      meals: this.props.fatDay.meals,
      method: (this.props.fatDay.meal_day == null) ? 'POST' : 'PATCH'
    }); 
  }
  updateMealSize(n, meal){
    // e.preventDefault()
    let meals = this.state.meals.slice();
    console.log(meal);
    let index = meals.findIndex(x => x.meal_type_id === meal.meal_type_id);
    // alert(index);
    //window.meals = meals;
    // alert(mealIndex);
    // console.log(mealIndex);
    console.log(meals[index]);
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
    var meals = this.state.meals.map(function(meal, index){
                  return  <Meal 
                            key={index} 
                            index={index} 
                            mealSizeMap={that.props.mealSizeMap} 
                            meal={meal} updateMealSize={(n,m)=>that.updateMealSize(n,m)} 
                            foodTypes={that.props.fatDay.food_types} 
                            toggleFood={(food)=>that.toggleFood(food)} />;
                });
    return (
      <div>
        <div className='border rounded'>
          {meals}
        </div>          
        <button id='btn-carbon-footprint' className='btn btn-lg btn-primary btn-primary--hover'>Find out my carbon footprint</button>
      </div>
    );
  }
  componentDidMount() {
    var that=this;
    $('#btn-carbon-footprint').on('click', function(){
      console.log(that.state.method);

      $.post( "/food-action-tracker", { _method: that.state.method, fat_day: that.state, meal_day: that.props.fatDay.meal_day }, "json")
        .done(function(){ 
          that.setState({method: 'PATCH'});
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