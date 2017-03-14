class Results extends React.Component {
  updateGraph(d) {
    this.refs.fatgraph.updateGraph(d);
  }
  render() {
    return (
      <div className="center bg-leaf pt3 mt3">
        <div className="h4 caps bold gray-80 mt3 mb2">WEEKLY PROGRESS</div>
        <FatGraph ref="fatgraph" graph_params={this.props.graph_params}/>
        <div className="pt3 pb4 center" style={{backgroundColor: "#C5EFF7"}}>
        <div className="max-width-4 mx-auto">
          <div className="h4 caps bold gray-80 mt3 mb2">LEARN MORE</div>
          <div className="flex flex-auto flex-wrap justify-around">
            <div className="pb4 bg-white">
              <div className="">
              <img src="http://placehold.it/300x50"/>
              </div>
                <h4 className="p1">Appetizers: Your first course</h4>
            </div>
            <div className="pb4 bg-white">
              <div className="bg-white">
              <img src="http://placehold.it/300x50"/>
              </div>
                <h4 className="p1">Appetizers: Your first course</h4>
            </div>
            <div className="pb4 bg-white">
              <div className="bg-white">
              <img src="http://placehold.it/300x50"/>
              </div>
                <h4 className="p1">Appetizers: Your first course</h4>
            </div>
        </div>
        </div>

      </div>
    </div>
    );
  }
}
