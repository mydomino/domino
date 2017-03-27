class CfGauge extends React.Component {
  constructor(props){
    super(props);
    let value = this.props.cf > 12.4 ? 12.4 : this.props.cf

    this.state = {
      cf: this.props.cf || 0,
      value: this.getValue(value)
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
    }, function(){
      this.gauge.set(this.state.cf > 12.4 ? 12.4 : this.state.cf);
    });
  }
  render(){
    return(
      <div>
        <canvas id="gauge"
          style={{ opacity: (this.props.cf == null) ? 0.4 : 1 }}></canvas>

        <div className="bg-gray-1 rounded-top h2 medium white pt2 line-height-3 black">{ (this.props.method == "POST") ? "-" : this.state.cf } kg <div className="h4 mt0">Carbon Emissions</div>
        </div>
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
        strokeWidth: 0.1, // The thickness
        color: '#00CCA0' // Fill color
      },
      limitMax: false,     // If false, the max value of the gauge will be updated if value surpass max
      limitMin: false,     // If true, the min value of the gauge will be fixed unless you set it manually
      colorStart: '#A6FFD6',   // Colors
      colorStop: '#FF7A7A',    // just experiment with them
      strokeColor: '#E0E0E0',  // to see which ones work best for you
      generateGradient: true,
      highDpiSupport: true,    // High resolution support
      // percentColors: [[0.0, "#a9d70b" ], [0.50, "#f9c802"], [1.0, "#ff0000"]],
      // staticLabels: {
      //   font: "16px sans-serif",  // Specifies font
      //   labels: [0, 6.2, 12.4],  // Print labels at these values
      //   color: "#fff",  // Optional: Label text color
      //   fractionDigits: 1  // Optional: Numerical precision. 0=round off.
      // },
      staticZones: [
         {strokeStyle: "#00FFC4", min: 0, max:8.2},
         {strokeStyle: "#FF7A7A", min: 8.2, max: 12.4}
      ]
    };
    var target = document.getElementById('gauge'); // your canvas element
    this.gauge = new Gauge(target).setOptions(opts); // create sexy gauge!
    this.gauge.maxValue = 12.4; // set max gauge value
    this.gauge.setMinValue(0);  // Prefer setter over gauge.minValue = 0
    this.gauge.animationSpeed = 15; // set animation speed (32 is default value)
    let value = this.state.cf > 12.4 ? 12.4 : this.state.cf
    this.gauge.set(value); // set actual value
  };
}
