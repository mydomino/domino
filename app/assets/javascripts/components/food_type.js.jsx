class FoodType extends React.Component {
  componentWillMount() {
    selected = false;
    size = 0;
    this.setState({
      selected: selected,
      size: 0
    });
  }
  updateFoodSize(newSize){
    this.setState({
      size: newSize 
    });
    this.props.updateFoodSize({id: this.props.foodType.id, newSize: newSize});
  }
  toggleFood(){
    selected = this.state.selected;
    this.setState({
      selected: !selected
    });
  }
  render() {
    return (
      <div>
        <div  onClick={()=>this.remodal()} style={{backgroundColor: this.props.foodSizeBGColorMap[this.state.size]}} className="col col-6 sm-col sm-col-4 relative food-type" data-toggle="modal" data-target={"#" + this.props.index + "-modal"} >
          <div className='flex flex-column items-center border border-gray-30 p2 pointer inline-block' >
            <div  onClick={()=>this.toggleFood()} 
                  className="p2 inline-block"
                  style={{width: '64px', height: '64px'}}>
              <img src={"/fat_icons/" + this.props.foodType.icon} />
            </div>
            <div className="gray-80">
              {this.props.foodType.name}
            </div>
          </div>
        </div>
        <div data-remodal-id="modal">
          <button data-remodal-action="close" className="remodal-close"></button>
          <h1>Remodal</h1>
          <br/>
          <button data-remodal-action="cancel" className="remodal-cancel">Cancel</button>
          <button data-remodal-action="confirm" className="remodal-confirm">OK</button>
        </div>
      </div>
    );
  }
  componentDidMount() {
    this.$modal =  $('[data-remodal-id=modal]').remodal();
    $slider = $( "#" + this.props.index + "-slider");

    $slider.slider({
      range: "min",
      animate: "fast",
      min:0,
      max: 3,
      step: 1,
      value: 0,
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
  foodSizeBGColorMap : ["white", "#87D37C", "#00ccff", "#E26A6A"]
};
