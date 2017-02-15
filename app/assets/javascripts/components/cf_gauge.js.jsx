class CfGauge extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      cf: this.props.cf || 0,
      value: this.getValue(this.props.cf)
    };
  }
  getValue(cf){
    // 6.2kg == 50% gauge, 12.4k == 100% gauge
    return ((cf / 12.4) * 100).toFixed(2);
  }
  setValue(v){
    let value = this.getValue(v);
    this.setState({
      cf: v,
      value: value
    });
    this.gauge.set(this.state.cf); // set actual value
  }
  render(){
    return(
      <div>
        <div className="h1 white">{this.state.cf} kg CO<sub>2</sub></div>
        <canvas id="foo"></canvas>
      </div>
    );
  }
  componentDidMount() {
    var opts = {
      angle: 0.0, // The span of the gauge arc
      lineWidth: 0.44, // The line thickness
      radiusScale: 1, // Relative radius
      pointer: {
        length: 0.6, // // Relative to gauge radius
        strokeWidth: 0.035, // The thickness
        color: '#000000' // Fill color
      },
      limitMax: false,     // If false, the max value of the gauge will be updated if value surpass max
      limitMin: false,     // If true, the min value of the gauge will be fixed unless you set it manually
      colorStart: '#6FADCF',   // Colors
      colorStop: '#8FC0DA',    // just experiment with them
      strokeColor: '#E0E0E0',  // to see which ones work best for you
      generateGradient: true,
      highDpiSupport: true     // High resolution support
    };
    var target = document.getElementById('foo'); // your canvas element
    this.gauge = new Gauge(target).setOptions(opts); // create sexy gauge!
    this.gauge.maxValue = 12.4; // set max gauge value
    this.gauge.setMinValue(0);  // Prefer setter over gauge.minValue = 0
    this.gauge.animationSpeed = 32; // set animation speed (32 is default value)
    this.gauge.set(this.state.cf); // set actual value
  };
}
