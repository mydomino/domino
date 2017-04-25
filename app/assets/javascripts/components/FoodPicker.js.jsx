class FoodPicker extends React.Component {
  constructor(props){
    super(props);

    this.state ={
      nextView: false,
      didntEat: false
    }
  }
  render() {
    var that = this;
    var foodTypes = this.props.foodTypes.map(function(foodType, index){
                      return <FoodType  index={index}
                                        ref={"foodtype" + (index+1)}
                                        removeFood={(f)=>that.props.removeFood(f)}
                                        addFood={(f)=>that.props.addFood(f)}
                                        sizeInfo={that.props.foodSizeInfo[foodType.id]}
                                        food={that.props.foods[foodType.id]} 
                                        index={index}
                                        key={foodType.name}
                                        foodType={foodType} />
                    });
    return (
      <div id="food-picker" className={((this.state.nextView) ? "display-none fadeOut" : "fadeIn") + " animated"}>
        <div className='col-12 p2'>
          {foodTypes}
        </div>
        <div className="center p2">
         <a onClick={()=>this.didntEat()} >
            <button id="btn-didnt-eat"
              className={(this.state.didntEat ? "border " : null) + " fill-x mt1 btn btn-sm btn-secondary border-gray-2"}
              style={{backgroundColor: (this.state.didntEat ? "#00ccff" : "white"), height:54}} >

              <span className="flex items-center justify-center">
                <img src="/fat_icons/i-empty.png" className="icon-m mr1"/>
                {"I ate none of these"}
              </span>
            </button>
          </a>
        </div>
      </div> 
    );
  }
}
