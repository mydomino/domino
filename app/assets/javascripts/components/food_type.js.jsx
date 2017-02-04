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
        <div  onClick={()=>this.revealModal()} style={{backgroundColor: this.props.foodSizeBGColorMap[this.state.size]}} className="col col-6 sm-col sm-col-4 relative food-type" data-toggle="modal" data-target={"#" + this.props.index + "-modal"} >
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

        <div className="modal max-width-3 mx-auto fixed top-0 bottom-0 left-0 right-0" id={this.props.index + "-modal"}>
          <div className="modal-dialog">
            <div className="modal-content bg-white">
              <div className="modal-header relative">
                <div className="absolute top-0 right-0 close" data-dismiss="modal">
                  <div onClick={()=>this.hideModal()} className="fa fa-times fa-2x blue pointer">
                  </div>
                </div>
              </div>
              <div className="modal-body">
                <div className="h1">
                  {this.props.foodType.name}
                </div>
                How much did you eat?
                <div className="my2" id={this.props.index + "-slider"}></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
  componentDidMount() {
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
  revealModal(target) {
    $("#" + this.props.index + "-modal").show();
    $('body').append('<div class="modal-bg fixed top-0 bottom-0 left-0 right-0"></div>');
    $('body').addClass('lock-position');
  }
  hideModal() {
    $('.modal-bg').remove();
    $('.modal').hide();
    $('body').removeClass('lock-position');
  }
}
FoodType.defaultProps = {
  foodSizeBGColorMap : ["white", "#87D37C", "#00ccff", "#E26A6A"]
};
