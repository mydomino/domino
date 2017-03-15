class Results extends React.Component {
  updateGraph(d) {
    this.refs.fatgraph.updateGraph(d);
  }
  render() {
    return (
      <div className="center bg-leaf pt3 mt3">
        <div className="h4 caps bold gray-80 mt3 mb2">WEEKLY PROGRESS
        </div>
        <FatGraph ref="fatgraph" graph_params={this.props.graph_params}/>
        <div className="pt3 pb4 center bg-gray-05">
          <div className="mx-auto">
            <div className="h4 caps bold gray-80 my3">LEARN MORE
            </div>
            <div className="max-width-4 mx-auto">
              <div className="flex flex-column sm-row justify-around">
                <div className="bg-white m2 rounded-bottom">
                  <img src="/fat_icons/appetizers.jpg" className="fill-x rounded-top"/>
                    <h3 className="p1 left-align">Appetizers: Your first course</h3>
                </div>
                <div className="bg-white m2 rounded-bottom">
                  <img src="/fat_icons/cow-tongue.jpg" className="fill-x rounded-top"/>
                    <h3 className="p1 left-align">Are cows the key to saving the planet?</h3>
                </div>
                <div className="bg-white m2 rounded-bottom">
                  <img src="/fat_icons/ugly-apples.jpg" className="fill-x rounded-top"/>
                    <h3 className="p1 left-align">Hidden health. Benefits of ugly produce</h3>
                  </div>
              </div>
              </div>
            </div>
      </div>

      </div>
    );
  }
}
