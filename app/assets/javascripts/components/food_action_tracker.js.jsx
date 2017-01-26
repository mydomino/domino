var FoodActionTracker = React.createClass({
  propTypes: {
    date: React.PropTypes.node
  },

  render: function() {
    return (
      <div>
        <div>Date: {this.props.date}</div>
      </div>
    );
  }
});
