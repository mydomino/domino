class CarbonFootprint extends React.Component {
  setCarbonFootprint(cf) {
    this.refs.cfgauge.setValue(cf);
  }
  render() {
    return (
      <div className="mt1 center">
        <CfGauge ref='cfgauge' cf={this.props.cf} method={this.props.method} />
      </div>
    );
  }
}
