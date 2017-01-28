class FoodActionTracker extends React.Component {
  constructor(){
    super();
    this.state = {
      meals: []
    };
  }
  componentWillMount(){
    this.setState({
      meals: this.props.fatDay.meals
    }); 
  }
  updateMealSize(newSize, mealIndex){
    // e.preventDefault()
    const meals = this.state.meals.slice();
    //window.meals = meals;
    // alert(mealIndex);
    console.log(mealIndex);
    meals[mealIndex].size = newSize;
    this.setState({
      meals: meals
    });
  }
  render() {
      // var mealTypes = ['Breakfast', 'Lunch', 'Dinner'];
      // var foodTypes = ['Fruits', 'Vegetables'];
      // // var fatDay = this.props.fatDay;
      // console.log(this.state.meals);
        // <FoodCategories onClick={() => this.handleClick()} />
      
      
      // var meals = <Meal key={1} index={1} meal={this.state.meals[0]} updateMealSize={()=>this.updateMealSize()} />;
      var that = this
      var meals = this.state.meals.map(function(meal, index){
                    return <Meal key={index} mealIndex={index} meal={meal} updateMealSize={(n,i)=>that.updateMealSize(n,i)} />;
                  });
      return (
        <div>
          <div className='border rounded'>
            <div>{meals}</div>
          </div>
          <button id='btn-carbon-footprint' className='btn btn-lg btn-primary btn-primary--hover'>Find out my carbon footprint</button>
        </div>
      );
  }
  componentDidMount() {
    $('#btn-carbon-footprint').on('click', function(){
    
    });
  }
}
