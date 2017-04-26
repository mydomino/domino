class ResultsSummary extends React.Component {
  constructor(props){
    super(props);
  }
  getResultTitle() {
    let cf = this.props.carbonFootprint;
    result_title = ""
    if(cf <= 7) {
      result_title += "<span class='green'>"
      result_title += ["Well done!", "Hooray!", "Great job!", "Fabulous!"][Math.floor(Math.random() * 4)];
    }
    else if(cf >= 7 && cf < 8 ){
      result_title += "<span class='yellow'>"
      result_title += "It's okay, I guess...";
    }
    else {
      result_title += "<span class='red'>"
      result_title += "Doh!";
    }
    result_title += "</span>"
    return {__html: result_title };
  }
  getCfResultString() {
    let str =  "<p class='h4 sm-h4 mx-auto mt0'>Your Foodprint today is ";
    let cf = this.props.carbonFootprint;
    let avgPercent = (cf/7) * 100;
    if(cf < 7) {
      let val = (100 - avgPercent).toFixed(0);
      str += "<span class='green'><span class='h3 bold'>" + val + "%</span> below</span> the American average."
    }
    else if(cf >= 7) {
      let val = (avgPercent - 100).toFixed(0);
      str += "<span class='red'><span class='h3 bold'>" + val + "%</span> above</span> the American average.";
    }
    else {
      str += "the American average";
    }
    str += "<p/>"

    str += "<div class='p1 bg-gray-2 mb2'><h3 class='my0'>You've earned <span class='h3 blue bold'>" + this.props.points + " </span> points.</h3>";    
    str += "<ul class='p1 m0 list-style-none h5 gray-6'><li><span class='blue'>+" + this.getCfpPoints() + " points </span> for beating the average American Foodprint </li>";
    str+="<li><span class='blue'>+10 points</span> for logging today</li>";

    if(this.props.foods['3'] === undefined) {
      str+="<li class='my0'><span class='blue'>+5 points</span> for not having dairy </li>";
    }

    if(this.props.foods['6'] === undefined) {
      str+="<li class='my0'><span class='blue'>+10 points</span> for not having beef or lamb </li>";
    }

    str += "</ul></div>"

    if(cf < 7) {
      str += `
        <p class='h5 sm-h4 left-align mx-auto mt1'>
          <span class="bold">Did you know?</span><br/>
          Beef and lamb produce 5x more carbon emissions than chicken, so choose your meats wisely.
          Also, up to 40% of food produced is wasted, but you can help change that.
        </p>
      `;
    } else {
      str += `
        <p class='h5 sm-h4 left-align mx-auto mt1'>
          <span class="bold">How you can improve</span><br/>
          Try cutting back on beef or lamb. They produce 5x more carbon emission than chicken.
        </p>
      `;
    }

    return {__html: str };
  }
  getCfpPoints() {
    let percentAverageEmission = 1-(this.props.carbonFootprint/7);
    let points = 0;

    if(percentAverageEmission >= 0.1 && percentAverageEmission < 1.0){
      points = percentAverageEmission * 100;
    }
    return points.toFixed();
  }
  render(){
    return (
      <div id="results-summary" className={(this.props.nextView ? "fadeIn" : "display-none") + " animated"}>
        <div className="bg-white mx2 my1 py2 rounded center">
          <span onClick={() => this.props.toggleView()} style={{top:'1.5rem'}} id="btn-food-picker" className="flex items-center ml2 mb0 pointer absolute">
            <img src="/fat_icons/i-arrow-left.svg" className="icon-s inline mr1"/>
            <h4 className="medium my0">Back</h4>
          </span>
          <h3 className="sm-h2 bold mb0 col-8 mx-auto" dangerouslySetInnerHTML={this.getResultTitle()}></h3>
          <div className="col-10 sm-col-8 mx-auto mb2" dangerouslySetInnerHTML={this.getCfResultString()}>

          </div>
           <div className="mx-auto center my1">
            <span data-target="#learn-more" className="line pointer ml1 line-height-1 smooth-scroll">Learn More</span>
          </div>
        </div>
        <div className="mx-auto center my2">
          <button data-target="#weekly-progress" className="btn btn-sm btn-primary btn-primary--hover smooth-scroll">See my progress this week</button>
          <span className="ml1 gray-5">
            or <a href="/myhome" className="black line ml1 line-height-1">Back to My Home</a>
          </span>
        </div>
      </div>
    );
  }
}