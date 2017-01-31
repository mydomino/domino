class MealSize extends React.Component {
  render() {
    return  (
      <div className="mb2">
        <div className="h3 mb1">{"Meal size: " + this.props.meal.size}</div>
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
