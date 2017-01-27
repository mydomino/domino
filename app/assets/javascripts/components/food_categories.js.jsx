class FoodCategories extends React.Component {
  render() {
      return  (
        <div>
          <FoodType name='test' onClick={()=>this.props.onClick()} />
        </div>
      );
  }
}
