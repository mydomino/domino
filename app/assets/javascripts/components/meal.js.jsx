class Meal extends React.Component {
  // propTypes: {
  //   name: React.PropTypes.string
  // },
  // constructor(props) {
  //   super(props);
  //   this.state = {
  //     size: 1,
  //     foods:{}
  //   };
  // }
  // // setSize(newSize) {
  // //   this.setState({
  // //     size: newSize
  // //   });
  // // }
  // componentWillMount(){
  //   this.setState({
  //     size: this.props.meal.size
  //   });
  // }
  render() {
    return (
      <div>
        <div className={"col col-12" + (this.props.index != 0 ? ' border-top' : '')}>
          <div className='max-width-3'>
            <div className='left'>{this.props.meal.name}</div>
            <div className='right max-width-2'>
              <MealSize mealIndex={this.props.mealIndex} updateMealSize={(n,i)=>this.props.updateMealSize(n,i)} meal={this.props.meal} />
            </div>
          </div>
        </div>
        <FoodCategories onClick={() => this.handleClick()} />
      </div>
    );
  }

  handleClick(){
    alert('testing');
  }
}
