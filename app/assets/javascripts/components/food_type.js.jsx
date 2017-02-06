class FoodType extends React.Component {
  componentWillMount() {
    let food = Object.assign({food_type_id: this.props.foodType.id}, this.props.food);
    this.setState({
      food: food
    });
  }
  updateFoodSize(newSize){
    let food = Object.assign({}, this.state.food);
    food.size = newSize;

    this.setState({
      food: food 
    });

    this.props.updateFoodSize(this.state.food);
  }
  render() {
    let size = this.state.food ? this.state.food.size : 0;

    return (
      <div>
        <div  onClick={()=>this.remodal()} style={{backgroundColor: this.props.bgColorMap[size]}} className="col col-6 sm-col sm-col-4 relative food-type" >
          <div className='flex flex-column items-center border border-gray-30 p2 pointer inline-block' >
            <div className="p2 inline-block" style={{width: '64px', height: '64px'}}>
              <img src={"/fat_icons/" + this.props.foodType.icon} />
            </div>
            <div className="gray-80">
              {this.props.foodType.name}
            </div>
          </div>
        </div>

        <div data-remodal-id={this.props.index + "-modal"}>
          <button data-remodal-action="close" className="remodal-close"></button>
            <div className="flex items-center justify-center">
              <img src={"/fat_icons/" + this.props.foodType.icon} />
              <div className="h1 ml1">{this.props.foodType.name}</div>
            </div>
          <br/>
          <div className="h2">How much did you eat? </div>
          <div id={this.props.index + "-slider"}></div>
          <div className="m2">
            <button data-remodal-action="cancel" className="remodal-cancel">Cancel</button>
            <button data-remodal-action="confirm" className="remodal-confirm">OK</button>
          </div>
        </div>

      </div>
    );
  }
  componentDidMount() {
    let size = this.state.food ? this.state.food.size : 0;

    this.$modal =  $('[data-remodal-id=' + this.props.index + '-modal]').remodal();
    $slider = $( "#" + this.props.index + "-slider");

    $slider.slider({
      range: "min",
      animate: "fast",
      min:0,
      max: 3,
      step: 1,
      value: size,
      slide: function(event, ui){
        this.updateFoodSize(ui.value);
      }.bind(this)
    });
  }
  remodal(){
    this.$modal.open();
  }
}
FoodType.defaultProps = {
  bgColorMap : ["white", "#87D37C", "#00ccff", "#E26A6A"]
};
