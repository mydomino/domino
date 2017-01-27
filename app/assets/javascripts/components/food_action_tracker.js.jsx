class FoodActionTracker extends React.Component {
  render() {
      var mealTypes = ['Breakfast', 'Lunch', 'Dinner'];
      var foodTypes = ['Fruits', 'Vegetables'];

      var meals = mealTypes.map(function(name, index){
                    return <Meal key={index} name={name} index={index} foodTypes={foodTypes} />;
                  });

      return (
        <div>
          <div className='border rounded'>
            <div>{meals}</div>
          </div>
          <button id='btn-carbon-footprint' className='btn btn-lg btn-primary btn-primary--hover'>Find out my carbon footprint</button>
        </div>
      );
  }
  componentDidMount() {
    $('#btn-carbon-footprint').on('click', function(){
      // alert('test');
    });
  }
}
