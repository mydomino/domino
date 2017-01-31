class FoodType extends React.Component {
  constructor() {
    super();
    this.state = {
      selected: false
    };
  }
  componentWillMount() {
    selected = false;
    for(var food in this.props.meal.foods){
      console.log(this.props.meal.foods[food]);
      if(this.props.meal.foods[food].food_type_id === this.props.foodType.id){
        selected = true;
        break;
      }
    }
    this.setState({
      selected: selected
    });
  }
  toggleFood(){
    selected = this.state.selected;
    this.setState({
      selected: !selected
    });
    this.props.toggleFood({id: this.props.foodType.id, meal_type_id: this.props.meal.meal_type_id})
  }
  render() {
    return (
      <div className='flex flex-column' >
        <div  onClick={()=>this.toggleFood()} 
              className={(this.state.selected ? 'bg-blue ' : 'bg-white ') + "border border-gray-30 p2 pointer inline-block"} 
              style={{borderRadius: '32px', width: '64px', height: '64px'}}>
          <img src={"/fat_icons/" + this.props.foodType.icon} />
        </div>
        <div className="gray-80">
          {this.props.foodType.name}
        </div>
      </div>
    );
  }
}
