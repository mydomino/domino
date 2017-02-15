class FoodType extends React.Component {
  constructor(props){
    super(props);

    let active = this.props.food != null ? true : false;
    let food = Object.assign({food_type_id: this.props.foodType.id, size: 100}, this.props.food);

    this.state = {
      food: food,
      active: active
    };
  }
  updateSizeLabel(value){
    let food = Object.assign({}, this.state.food);
    food.size = value;
    this.setState({
      food: food
    });
  }
  removeFood(){
    let food = Object.assign({}, this.state.food);
    this.props.removeFood(food);

    //reset slider value
    this.$slider.slider("value",100);
    //reset size
    food.size = 100;

    this.setState({
      food: food,
      active: false
    });
  }
  addFood(size){
    let food = Object.assign({}, this.state.food);
    food.size = size;
    this.setState({
      food: food,
      active: true
    });
    this.props.addFood(this.state.food);
  }
  render() {
    return (
      <div>
        <div onClick={(e)=>this.remodal(e)} className="col col-6 sm-col-4 food-type relative" >
          <a id="cancel-food-type" className={"absolute top-0 right-0 p2 pointer " + (this.state.active ? "inline" : "hidden")}>
            <img src={"/fat_icons/i-close.svg"} className="icon-s"/>
          </a>
          <div style={{ borderColor: (this.state.active) ? this.props.bgColorMap[this.state.food.size] : '#eaeaea',
                        backgroundColor: (this.state.active) ? this.props.bgColorMap[this.state.food.size] : '#fff' }}
                className={'flex flex-column items-center border border-gray-10 p2 pointer inline-block ' + this.props.borderRadiusClasses[this.props.index]} >

            <div className="p2 inline-block">
              <img src={"/fat_icons/" + this.props.foodType.icon} />
            </div>
            <h5 className="sm-h4 my0">
              {this.props.foodType.name}
            </h5>
          </div>
        </div>

        <div data-remodal-id={this.props.index + "-modal"} className="rounded">
            <a data-remodal-action="close" className="absolute top-0 right-0 p2 pointer">
              <img src={"/fat_icons/i-close.svg"} className= "icon-m"/>
            </a>
            <div className="flex items-center justify-center">
              <img src={"/fat_icons/" + this.props.foodType.icon} />
              <div className="h1 ml1">{this.props.foodType.name}</div>
            </div>
            <br/>
            <div className="h2">How much did you eat? </div>
            <div className="clearfix p2">
              <div className="col col-12 sm-col sm-col-3">
                <div className="flex flex-column items-center justify-center">
                  <div className="meal-size-label mb1 h3">
                    {this.state.food.size}
                  </div>
                  <div id={this.props.index + "-slider"}></div>
                </div>
              </div>
              <div className="size-information col col-12 sm-col sm-col-8 left-align">
                {this.props.sizeInfo[this.state.food.size]}
              </div>
            </div>
            <div className="m2 clearfix">
              <button data-remodal-action="confirm" className="btn btn-md btn-primary">OK</button>
            </div>
          </div>
      </div>
    );
  }
  componentDidMount() {
    let that = this;
    let size = this.state.food.size;
    let modalSelector = "[data-remodal-id=" + this.props.index + "-modal]";
    let $modal = $(modalSelector);

    this.$modal =  $modal.remodal();

    let sliderSelector = "#" + this.props.index + "-slider";

    that.$slider = $(sliderSelector).slider({
      orientation: "vertical",
      range: "min",
      animate: "fast",
      min:50,
      max: 200,
      step: 50,
      value: size,
      slide: function(event, ui){
        this.updateSizeLabel(ui.value);
      }.bind(this)
    });
    $(document).on('confirmation', modalSelector, function (e) {
      console.log(modalSelector);
      that.addFood(that.$slider.slider("value"));
    });
  }
  remodal(e){
    if( $(e.target).parents()[0].id === "cancel-food-type" )
      this.removeFood();
    else
      this.$modal.open();
  }
  componentWillUnmount(){
    $(document).unbind('confirmation');
  }
}
FoodType.defaultProps = {
  bgColorMap : {
    "0" : "white",
    "50" : "#87D37C",
    "100" : "#00ccff",
    "150" : "#F1A9A0",
    "200" : "#E26A6A"
  },

  borderRadiusClasses : [
    'rounded-top-left',
    'rounded-top-right sm-not-rounded',
    'sm-rounded-top-right not-rounded',
    'not-rounded sm-rounded-bottom-left',
    'rounded-bottom-left sm-not-rounded',
    'rounded-bottom-right'
  ]
};
