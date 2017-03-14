class Results extends React.Component {
  updateGraph(d) {
    this.refs.fatgraph.updateGraph(d);
  }
  render() {
    return (
      <div className="center bg-aqua">
        <div className="h4 caps bold gray-80 mt3 mb2">WEEKLY PROGRESS</div>
        <FatGraph ref="fatgraph" graph_params={this.props.graph_params}/>
        <div className="py4 center" style={{backgroundColor: "#C5EFF7"}}>
          <div className="h4 caps bold gray-80">LEARN MORE</div>
        </div>
      </div>
    );
  }
}
