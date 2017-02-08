class CfGauge extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      value: this.props.value
    };
  }
  setValue(value){
    this.setState({
      value: value
    });
    $('.gauge .gauge-arrow').trigger('updateGauge', value);
  }
  render(){
    return(
      <div className = "cf-gauge" style={{display: (this.props.value === null ? 'none' : 'block')}} >
        <div className = "gauge gauge gauge-big gauge-blue">
          <div  className = "gauge-arrow" 
                data-percentage = {this.props.value ? this.props.value : "0"}
                style={{transform: "rotate(0deg)"}}>
          </div>
        </div>
        <div className = "cf-text h1 p1">{this.state.value}</div>
      </div>
    );
  }
  componentDidMount() {
    $('.gauge .gauge-arrow').cmGauge();
  }
}
