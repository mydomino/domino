class Results extends React.Component {
  render() {
    return (
      <div className="center" style={{backgroundColor: '#36D7B7'}}>
        <div className="h1 gray-80 py4">WEEKLY PROGRESS</div>
        <FatGraph results={this.props.results}/>
        <div className="py4 center" style={{backgroundColor: "#C5EFF7"}}>
          <div className="h1 gray-80">LEARN MORE</div>
        </div>
      </div>
    );
  }
}
