class Results extends React.Component {
  updateGraph(d) {
    this.refs.fatgraph.updateGraph(d);
  }
  render() {
    return (
      <div>
        <div id="weekly-progress" className="center bg-leaf py4">
          <div className="h2 bold gray-7 pb4">Progress This Week</div>
          <FatGraph ref="fatgraph" graph_params={this.props.graph_params}/>
        </div>

        <div id="learn-more" className="pt3 pb4 center bg-gray-1">
          <div className="mx3 sm-mx0">
            <div className="h1 bold gray-7 my3">Learn More</div>
              <div className="max-width-3 mx-auto">
                <div className="flex flex-column flex-wrap sm-row justify-around">
                <div className="flex self-stretch sm-col-4">
                  <div className="bg-white m2 rounded-bottom">
                    <a href="http://actions.mydomino.com/guides/smart-food" className="text-decoration-none black">
                      <img src="/fat_icons/appetizers.jpg" className="fill-x rounded-top"/>
                      <h3 className="px1 left-align mb0">Appetizers: Your food intro guide</h3>
                      <p className="h5 left-align gray-5 px1 mt1 mb3 col-10">Expand your gastronomy horizons.
                      </p>
                    </a>
                  </div>
                </div>
                  <div className="flex self-stretch sm-col-4">
                  <div className="bg-white m2 rounded-bottom">
                    <a href="/articles/cows-climate-change" className="text-decoration-none black">
                      <img src="/fat_icons/cow-tongue.jpg" className="fill-x rounded-top"/>
                      <h3 className="px1 left-align mb0">Are cows the key to saving the planet?</h3>
                      <p className="h5 left-align gray-5 px1 mt1 mb3 col-10">They may look sweet and innocent, but don’t let that fool you!
                      </p>
                    </a>
                  </div>
                </div>

                  <div className="flex self-stretch sm-col-4">
                  <div className="bg-white m2 rounded-bottom">
                    <a href="/articles/hidden-health-benefits-of-ugly-produce" className="text-decoration-none black">
                      <img src="/fat_icons/ugly-apples.jpg" className="fill-x rounded-top"/>
                      <h3 className="px1 left-align mb0">Hidden health benefits of ugly produce</h3>
                      <p className="h5 left-align gray-5 px1 mt1 mb3 col-11">Imperfect produce may be more perfect than you realize.
                      </p>
                    </a>
                  </div>
                </div>
                <div className="flex self-stretch sm-col-4">
                  <div className="bg-white m2 rounded-bottom">
                    <a href="/articles/10-tips-to-reduce-food-waste/" className="text-decoration-none black">
                      <img src="https://wp.mydomino.com/wp-content/uploads/2016/03/bigstock-Diverse-People-Luncheon-Outdoo-96111797-690x460.jpg" className="fill-x rounded-top"/>
                      <h3 className="px1 left-align mb0">10 Tips to Reduce Food Waste</h3>
                      <p className="h5 left-align gray-5 px1 mt1 mb3 col-11">These tricks will help you reduce your environmental impact and save money!
                      </p>
                    </a>
                  </div>
                </div>
                <div className="flex self-stretch sm-col-4">
                  <div className="bg-white m2 rounded-bottom">
                    <a href="/articles/6-tips-eating-healthy-budget" className="text-decoration-none black">
                      <img src="https://wp.mydomino.com/wp-content/uploads/2017/03/bigstock-148170143-690x460.jpg" className="fill-x rounded-top"/>
                      <h3 className="px1 left-align mb0">6 Tips for Eating Healthy and Sustainably on a Budget</h3>
                      <p className="h5 left-align gray-5 px1 mt1 mb3 col-11">It's easier than you may think.
                      </p>
                    </a>
                  </div>
                </div>
                <div className="flex self-stretch sm-col-4">
                  <div className="bg-white m2 rounded-bottom">
                    <a href="/articles/flexitarian-the-latest-thing" className="text-decoration-none black">
                      <img src="https://wp.mydomino.com/wp-content/uploads/2017/03/bigstock-Organic-Food-Including-Vegetab-115393862-690x460.jpg" className="fill-x rounded-top"/>
                      <h3 className="px1 left-align mb0">Why Being a Flexitarian Is the Latest Food Trend</h3>
                      <p className="h5 left-align gray-5 px1 mt1 mb3 col-11">Go beyond Meatless Mondays with a more flexible way of eating!
                      </p>
                    </a>
                  </div>
                </div>

                </div> {/* END flex flex-column*/}
              </div> {/* END max-width-3*/}
            </div> {/* END LEARN MORE */}
          </div>
        </div>
    );
  }
}
