class MealSize extends React.Component {
  render() {
    return  (
      <div>
        <div><h3>Meal size:</h3></div>
        <div className={"slider "+ this.props.meal.meal_type.name}></div>
      </div>
    );
  }

  componentDidMount(){
   $slider = $( ".slider." + this.props.meal.meal_type.name);
    meal = this.props.meal;
    console.log(meal.size);
    $slider.slider({
      range: "min",
      animate: "fast",
      min:0,
      max: 2,
      step: 1,
      value: this.props.mealSizeMap.indexOf(meal.size),
      slide: function(event, ui){
        this.props.updateMealSize(this.props.mealSizeMap[ui.value], this.props.meal);
      }.bind(this)
    }).bind(this);
  }
}
