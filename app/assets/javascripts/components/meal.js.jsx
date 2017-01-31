class Meal extends React.Component {
  render() {
    var that = this;
    var foodTypes = this.props.foodTypes.map(function(foodType){
                      return <FoodType key={foodType.name} foodType={foodType} toggleFood={(food)=>that.props.toggleFood(food)} meal={that.props.meal} />
                    });

    return (
      <div className={this.props.index != 0 ? 'border-top' : ''}>

        <div className='p2'>
          <div className='left h3'>{this.props.meal.meal_type.name}</div>
          <div className='right  max-width-2'>
            <MealSize mealSizeMap={this.props.mealSizeMap} updateMealSize={(n, m)=>this.props.updateMealSize(n,m)} meal={this.props.meal} />
          </div>
        </div>

        <div className='clearfix'>
          <div className=' col col-12 mt2 sm-mt0 mb2'>
            <div className='flex justify-around'>
              {foodTypes}
            </div>
          </div>
        </div>

      </div>
    );
  }
}
