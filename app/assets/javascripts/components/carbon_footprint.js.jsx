class CarbonFootprint extends React.Component {
  setCarbonFootprint(cf) {
    this.refs.cfgauge.setValue(cf);
  }
  render() {
    return (
      <div className="py2 center">
        <CfGauge ref='cfgauge' cf={this.props.cf} />
      </div>
    );
  }
}