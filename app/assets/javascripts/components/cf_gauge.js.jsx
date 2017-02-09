class CfGauge extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      cf: this.props.cf,
      value: this.getValue(this.props.cf)
    };
  }
  getValue(cf){
    // 6.2kg == 50% gauge, 12.4k == 100% gauge
    return (cf / 12.4) * 100;
  }
  setValue(v){
    let value = this.getValue(v);
    this.setState({
      cf: v,
      value: value
    });
    $('.gauge .gauge-arrow').trigger('updateGauge', value);
  }
  render(){
    return(
      <div className = "cf-gauge" style={{display: (this.props.cf === null ? 'none' : 'block')}} >
        <div className = "gauge gauge gauge-big gauge-blue">
          <div  className = "gauge-arrow" 
                data-percentage = {this.state.value}
                style={{transform: "rotate(0deg)"}}>
          </div>
        </div>
        <div className = "cf-text h1 p1">{this.state.cf} kg CO<sub>2</sub></div>
      </div>
    );
  }
  componentDidMount() {
    $('.gauge .gauge-arrow').cmGauge();
  }
}

