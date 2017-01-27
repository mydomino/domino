class Meal extends React.Component {
  // propTypes: {
  //   name: React.PropTypes.string
  // },
  constructor() {
    super();

    this.state = {
      size: 1,
      foods:{}
    };
  }
  setSize(newSize) {
    this.setState({
      size: newSize
    });
  }
  render() {
    return (
      <div>
        <div className={"col col-12" + (this.props.index != 0 ? ' border-top' : '')}>
          <div className='max-width-3'>
            <div className='left'>{this.props.name}</div>
            <div className='right max-width-2'>
              <MealSize setSize={(e)=>this.setSize(e)} mealName={this.props.name}/>
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
