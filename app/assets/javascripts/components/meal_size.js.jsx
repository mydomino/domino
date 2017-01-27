class MealSize extends React.Component {
  // constructor(){
  //   super();
  //   this.state 
  // }
  // setSize(){
  //   alert(test);
  // }

  render() {
      return  (
        <div>
          <div><h3>Meal size:</h3></div>
          <div className={"slider "+ this.props.mealName}></div>
        </div>
      );
  }

  componentDidMount(){
    var that = this;
    $( ".slider." + that.props.mealName).slider({
      range: "min",
      animate: "fast",
      min:0,
      max: 2,
      step: 1,
      value: 1,
      slide: function(event, ui){
        that.props.setSize(ui.value);
      }
    });
  }
  
}
