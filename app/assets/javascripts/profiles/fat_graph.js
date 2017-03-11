modulejs.define('fat_graph', function () {
  return function(cf){
    var data = cf;

    // Set margins
    var margin = {top: 20, right: 30, bottom: 30, left: 40},
        width = 960 - margin.left - margin.right,
        height = 200 - margin.top - margin.bottom;

    // Bottom axis scale band
    var x = d3.scaleBand()
      .domain(["M", "Tu", "W", "Th", "F", "Sa", "Su"])
      .rangeRound([0, width]);

    // Bottom axis  
    var xAxis = d3.axisBottom(x).tickSize(0);

    // Labels for top axis
    var x2labels = data.map(function(el){
      if(el.cf == null){
        return "Incomplete";
      }
      if(el.cf == "future") {
        return " ";
      }
      if(el.cf >= 0) {
        return el.cf + " lbs.";
      }
    });

    // Top axis scale band
    var x2 = d3.scaleBand()
              .domain([1,2,3,4,5,6,7])
              .rangeRound([0, width]);

    // Bottom axis
    var x2Axis = d3
      .axisTop(x2)
      .tickSize(0)
      .tickPadding(5);

    var y = d3.scaleLinear()
            .domain([0, 13]) // max y value: 13 kg C02
            .range([height, 0]);

      var chart = d3.select(".chart")
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      var barWidth = width / data.length;

      var bar = chart.selectAll("g")
        .data(data)
        .enter().append("g")
        .attr("transform", function(d, i) {
          return "translate(" + i * barWidth + ",0)"; 
        });

      // Primary bar elements
      bar.append("rect")
        .classed("pointer", "true")
        .classed("null", function(d) {
          if(d.cf == null){
            return true;
          }
          return false;
        })

        //   if(d.cf == "future") {
        //     return "future";
        //   }
        // })
        .attr("y", function(d){
          // var v = (d.cf == null ? 15 : d.cf);
          return y(d.cf);
        })
        .attr("height", function(d){
          //return height-y(d.cf);
          return height-y(d.cf);
        })
        .attr("width", 50)
        .attr("fill", function(d){
          // return "none";
          return "steelblue";
        })
        .on("mouseenter", function(d, i) {
            d3.select("#lbl-x2-" + i)
              .text(function(){
                return (d.cf == null ? "N/A" : d.pts + " pts")
              })
              .attr("x", function(d){
                var textBBox = this.getBBox();
                return textBBox.width/2 - 7;
              });
            d3.select("#aux-" + i)
              .style("opacity", 1);
        })
        .on("mouseout", function(d, i) {
          d3.select("#lbl-x2-" + i)
            .text(function(){
              return (d.cf == null ? "Incomplete" : d.cf + " lbs.");
            })
            .attr("x", function(d){
              var textBBox = this.getBBox();
              return textBBox.width/2 - 7;
            });

            d3.select("#aux-" + i)
              .style("opacity", 0);

            d3.select(this)
              .attr("fill", function(d){
                if(d.cf == null) return "white";
                return "steelblue";
              });
        })
        .on('click', function(d){
          window.location = "food/" + d.path;
        });


        // auxillary bars to show amount below or above avg cf
        
        bar.append("rect")
          .attr("class", "pointer")
          .attr("id", function(d, i){
            return "aux-" + i;
          })
          .attr("y", function(d){
            if(d.cf == null) return null;
            if(d.cf < 6.2) {
              return y(6.2);
            }
            else {
              var diff = y(6.2) - y(d.cf);
              return y(6.2) - diff;
            }
          })
          .attr("height", function(d){
            if(d.cf == null) return null;
            if(d.cf < 6.2) {
              var height = y(d.cf) - y(6.2);
            }
            else {
              var height = y(6.2) - y(d.cf);
            }
            return height;
          })
          .attr("width", barWidth - 15)
          .attr("fill", function(d){
            if(d.cf == null) return "none";
            return (d.cf < 6.2 ? "green" : "red");
          })
          .style("opacity", 0)
          .on("mouseenter", function(d,i){
            d3.select("#lbl-x2-" + i)
              .text(function(){
                return (d.cf == null ? "N/A" : d.pts + " pts")
              })
              .attr("x", function(d){
                var textBBox = this.getBBox();
                return textBBox.width/2 - 7;
              });
            d3.select(this)
              .style("opacity", 1);
            
          })
          .on("mouseout", function(d,i){
            d3.select(this)
              .style("opacity", 0);
           d3.select("#lbl-x2-" + i)
            .text(function(){
              return (d.cf == null ? "Incomplete" : d.cf + " lbs.");
            })
            .attr("x", function(d){
              var textBBox = this.getBBox();
              return textBBox.width/2 - 7;
            });
          });
        

        // incomplete sections
        d3.selectAll(".null")
        .attr("y", y(max))
        .attr("height", height-y(max))
        .attr("fill", "white")
        .style("stroke-dasharray", ("40, 10"))
        .style("stroke", "#4ECDC4")
        .style("stroke-width", 4)


      // top axis
      chart.append("g")
        .attr("class", "x2 axis")
        .attr("transform", "translate(0," + 0 + ")")
        .call(x2Axis)
        .selectAll("text")
        .text(function(d,i){
          return x2labels[i];
        })
        .attr("x", function(d,i){
          var textBBox = this.getBBox();
          return textBBox.width/2 - 7;
        })
        .attr("id", function(d, i){
          return "lbl-x2-" + i;
        });

      chart.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

      chart.append("line")
        .attr("x1",0)
        .attr("y1", y(6.2))
        .attr("x2",width)
        .attr("y2", y(6.2))
        .attr('stroke-width', 4)
        .attr('stroke', "#00ccff")
        .style("opacity", 0.5)
        .style("stroke-dasharray", ("10, 5"));
  };
});