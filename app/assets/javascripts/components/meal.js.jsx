var Meal = React.createClass({
  propTypes: {
    name: React.PropTypes.string
  },

  render: function() {
    return (
      <div>
        <div>{this.props.name}</div>
        <FoodType name="fruits" />
      </div>
    );
  }
});
