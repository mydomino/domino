class CarbonFootprint extends React.Component {
  setCarbonFootprint(cf) {
    this.refs.cfgauge.setValue(cf);
  }
  render() {
    return (
      <div className="py2 center">
          <button onClick={()=>this.props.getCarbonFootprint()} style={{display: (this.props.cf !== null ? 'none' : 'inline')}} 
                  id='btn-carbon-footprint' 
                  className='btn btn-md btn-primary btn-primary--hover'>
            Find out my carbon footprint
        </button>
        
        <CfGauge ref='cfgauge' cf={this.props.cf} />
      </div>
    );
  }
}