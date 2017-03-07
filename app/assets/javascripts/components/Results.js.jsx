class Results extends React.Component {
  updateGraph(d) {
    this.refs.fatgraph.updateGraph(d);
  }
  render() {
    return (
      <div className="center" style={{backgroundColor: '#36D7B7'}}>
        <div className="h1 gray-80 py4">WEEKLY PROGRESS</div>
        <FatGraph ref="fatgraph" graph_params={this.props.graph_params}/>
        <div className="py4 center" style={{backgroundColor: "#C5EFF7"}}>
          <div className="h1 gray-80">LEARN MORE</div>
        </div>
      </div>
    );
  }
}
