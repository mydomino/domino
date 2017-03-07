class Results extends React.Component {
  render() {
    return (
      <div className="mt1 center" style={{backgroundColor: '#36D7B7'}}>
        <div className="h1 gray-80 py4">Weekly Progress</div>
        <FatGraph results={this.props.results}/>
      </div>
    );
  }
}
