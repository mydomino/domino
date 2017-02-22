class CarbonFootprint extends React.Component {
  setCarbonFootprint(cf) {
    console.log("test: " + cf);
    this.refs.cfgauge.setValue(cf);
  }
  render() {
    return (
      <div className="mt3 center">
        <CfGauge ref='cfgauge' cf={this.props.cf} method={this.props.method} />
      </div>
    );
  }
}
