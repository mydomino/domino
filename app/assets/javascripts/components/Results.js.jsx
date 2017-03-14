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
        <div className="pt3 pb4 center" style={{backgroundColor: "#C5EFF7"}}>
          <div className="mx-auto">
            <div className="h4 caps bold gray-80 my3">LEARN MORE
            </div>
            <div className="max-width-4 mx-auto">
              <div className="flex flex-column sm-row justify-around">
                <div className="bg-white m1">
                  <img src="http://placehold.it/200x150"/>
                    <h4 className="p1">Appetizers: Your first course</h4>
                </div>
                <div className="bg-white m1">
                  <img src="http://placehold.it/200x150"/>
                    <h4 className="p1">Appetizers: Your first course</h4>
                </div>
                <div className="bg-white m1">
                  <img src="http://placehold.it/200x150"/>
                    <h4 className="p1">Appetizers: Your first course</h4>
                  </div>
              </div>
              </div>
            </div>
      </div>

      </div>
    );
  }
}
