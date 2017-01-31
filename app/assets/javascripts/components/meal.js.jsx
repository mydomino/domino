class Meal extends React.Component {
  render() {
    var that = this;
    var foodTypes = this.props.foodTypes.map(function(foodType, index){
                      return <FoodType index={index} key={foodType.name} foodType={foodType} toggleFood={(food)=>that.props.toggleFood(food)} meal={that.props.meal} />
                    });

    return (
      <div className={this.props.index != 0 ? 'border-top' : ''}>

        <div>
          <div className='col col-12 sm-col sm-col-6 p2'>
            <div className='center sm-left'>
              <div className='h3 ml0 sm-ml2'>{this.props.meal.meal_type.name}</div>
            </div>
          </div>
          <div className='col col-12 sm-col sm-col-6 p2'>
            <div className='center sm-right mx-auto max-width-1'>
              <MealSize mealSizeMap={this.props.mealSizeMap} updateMealSize={(n, m)=>this.props.updateMealSize(n,m)} meal={this.props.meal} />
            </div>
          </div>
        </div>

        <div className='clearfix'>
          <div className=' col col-12 mt2 sm-mt0 mb2'>
            <div className='flex justify-around flex-wrap'>
              {foodTypes}
            </div>
          </div>
        </div>
      </div>
    );
  }
}
