class FatGraph extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      data: this.props.graph_params.values,
      chartContainerHeight: 200,
      chartContainerWidth: null
    };
  }
  render() {
    return (
      <div className="chart-container">
        <svg className="chart"></svg>
      </div>
    );
  }
  updateGraph(d) {
    let data = this.state.data
    data[d.day_index] = d.values[d.day_index];

    this.setState({
      data: data
    }, function(){
      this.drawGraph();
    });
  }
  onBarEnter(d,i) {
    d3.select("#lbl-x2-" + i)
      .text(function() {
        return (d.cf == null ? "N/A" : d.pts + " pts")
      });

    d3.select("#aux-" + i)
      .style("opacity", 1);
  }
  onBarExit(d, i) {
    d3.select("#lbl-x2-" + i)
    .text(function() {
      return (d.cf == null ? "Incomplete" : d.cf + " kg");
    });

    d3.select("#aux-" + i)
      .style("opacity", 0);

    if(!d3.select(this).classed("aux")) {
      d3.select(this)
        .attr("fill", function(d){
          if(d.cf == null) return "white";
          // console.log(d3.select(this).classed("aux"));
          return "steelblue";
        });
    }
  }
  drawGraph(){
    componentCtx = this;
    d3.selectAll("svg.chart > *").remove();

    var data = this.state.data;
    var containerHeight = this.state.chartContainerHeight;
    var winWidth = this.state.chartContainerWidth;

    // Set margins, width, and height
    var margin = {top: 32, right: 16, bottom: 32, left: 16},
        width = winWidth - margin.left - margin.right,
        // width = 960 - margin.left - margin.right,
        height = containerHeight - margin.top - margin.bottom;

    // x axis showing days of week
    var x = d3.scaleBand()
      .domain(["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"])
      .rangeRound([0, width]);

    var xAxis = d3.axisBottom(x)
      .tickSize(0)
      .tickPadding(8);

    var x2labels = data.map(function(el){
      if(el.cf == null){
        return "Incomplete";
      }
      if(el.cf == "future") {
        return " ";
      }
      if(el.cf >= 0) {
        return el.cf + " kg";
      }
    });

    // Top x axis showing c02 footprints and point values
    var x2 = d3.scaleBand()
              .domain([1,2,3,4,5,6,7])
              .rangeRound([0, width]);

    var x2Axis = d3
      .axisTop(x2)
      .tickSize(0)
      .tickPadding(10);

    var max = d3.max(data, function(d) { return +d.cf;} );
    max = (max <= 12 ? 12 : max);

    var y = d3.scaleLinear()
      .domain([0,max])
      .range([height, 0]);

    // Chart bg color
    d3.select(".chart").append("rect")
      .attr("width", "100%")
      .attr("height", "100%")
      .attr("fill", "white");

    // Top axis background
    d3.select(".chart").append("rect")
      .attr("width", "100%")
      .attr("height", "30px")
      .attr("fill", "#66FFDB");

    // Chart container
    var chartContainer = d3.select('.chart-container')
          .style("height", containerHeight + "px");

    // Chart
    var chart = d3.select(".chart")
      .attr("width", "100%")
      .attr("height", "100%")
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var barWidth = 20;
    // var barWidth = 20;
    var barContainerWidth = width/data.length;
    var barOffset = barWidth/barContainerWidth
    var dx = barContainerWidth/4;

    var bar = chart.selectAll("g")
      .data(data)
      .enter().append("g")
      .attr("transform", function(d, i) {
        return "translate(" + (i * barContainerWidth + dx) + ",0)";
      });

    // Primary bar elements
    bar.append("rect")
      .classed("bar", true)
      .attr("id", function(d,i){
        return "rect-" + i;
      })
      .classed("pointer", "true")
      .classed("null", function(d) {
        return (d.cf == null ? true : false);
      })
      .classed("future", function(d) {
          if(d.cf == "future") {
            return true;
          }
          return false;
      })
      .attr("y", function(d){
        var v = (d.cf == "future" ? 15 : d.cf);
        return y(v);
      })
      .attr("height", function(d){
        //return height-y(d.cf);
        var v = (d.cf == "future" ? 15 : d.cf);

        return height-y(v);
      })
      .attr("width", barContainerWidth/2)
      .attr("fill", function(d){
        // return "none";
        return "steelblue";
      })
      .on("mouseenter", componentCtx.onBarEnter)
      .on("mouseout", componentCtx.onBarExit)
      .on('click', function(d){
        window.location = "/food/" + d.path;
      });

 

        // auxillary bars to show amount below or above avg cf
        bar.append("rect")
          .attr("class", "pointer aux")
          .attr("id", function(d, i){
            return "aux-" + i;
          })
          .attr("y", function(d){
            if(d.cf == null || d.cf == "future") return null;
            if(d.cf < 6.2) {
              return y(6.2);
            }
            else {
              var diff = y(6.2) - y(d.cf);
              return y(6.2) - diff;
            }
          })
          .attr("height", function(d){
            if(d.cf == null || d.cf == "future") return null;
            if(d.cf < 6.2) {
              var height = y(d.cf) - y(6.2);
            }
            else {
              var height = y(6.2) - y(d.cf);
            }
            return height;
          })
          .attr("width", barContainerWidth/2)
          .attr("fill", function(d){
            if(d.cf == null) return "none";
            return (d.cf < 6.2 ? "green" : "red");
          })
          .style("opacity", 0)
          .on("mouseenter", componentCtx.onBarEnter)
          .on("mouseout", componentCtx.onBarExit);

        //incomplete sections
        d3.selectAll(".null")
          .attr("y", y(max))
          .attr("height", height-y(max))
          .attr("fill", "white")
          .style("stroke-dasharray", ("30, 15"))
          .style("stroke", "#4ECDC4")
          .style("stroke-width", 4)
          .style("position","relative")
          .style("z-index","3")

        d3.selectAll(".future")
          .attr("height", 0);

      // top axis
      chart.append("g")
        .attr("class", "x2 axis")
        .attr("transform", "translate(0," + -2 + ")")
        .call(x2Axis)
        .selectAll("text")
        .text(function(d,i){
          return x2labels[i];
        })
        .attr("class", "top-axis-label")
        .attr("id", function(d, i){
          return "lbl-x2-" + i;
        });

      // bottom axis
      chart.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

      chart.append("line")
        .attr("x1",0)
        .attr("y1", y(6.2))
        .attr("x2",width)
        .attr("y2", y(6.2))
        .attr('stroke-width', 2)
        .attr('stroke', "#00ccff")
        .style("opacity", 0.5)
        .style("stroke-dasharray", ("20, 5"));

      d3.select(window).on('resize', this.resize.bind(this));

  } // end drawGraph();
  resize(){
    this.setState({
      chartContainerWidth: $(window).width()
    }, function(){
      this.drawGraph();
    });
  }
  componentDidMount() {
    this.setState({
      chartContainerWidth: $(window).width()
    }, function(){
      this.drawGraph();
    });
  } // end componentWillMount()
}
