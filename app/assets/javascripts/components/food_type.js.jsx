var FoodType = React.createClass({
  propTypes: {
    name: React.PropTypes.string
  },

  render: function() {
    return (
      <div onClick={() => this.props.onClick()}>{this.props.name}</div>
    );
  }
});
