class MealSize extends React.Component {
  render() {
      return  (
        <div>
          <div><h3>Meal size:</h3></div>
          <div className={"slider "+ this.props.meal.name}></div>
        </div>
      );
  }

  componentDidMount(){
    // that = this;
    // console.log(that.props.meal.name);
    // console.log(that.props.mealIndex);
    window.$slider = $( ".slider." + this.props.meal.name);

    window.$slider.slider({
      range: "min",
      animate: "fast",
      min:0,
      max: 2,
      step: 1,
      value: this.props.meal.size,
      // create: function(){
      //   // console.log('urr');
      //   console.log(this.props.mealIndex);
      //   console.log(window.$slider.data('index', 'test'));
      // }.bind(this),
      slide: function(event, ui){
        this.props.updateMealSize(ui.value, this.props.mealIndex);
      }.bind(this)
    }).bind(this);
  }
}
