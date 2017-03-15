class Results extends React.Component {
  updateGraph(d) {
    this.refs.fatgraph.updateGraph(d);
  }
  render() {
    return (
      <div className="center bg-leaf pt3 mt3">
        <div className="h4 caps bold gray-80 mt3 mb2">WEEKLY PROGRESS
        </div>
        <FatGraph ref="fatgraph" graph_params={this.props.graph_params}/>
        <div className="pt3 pb4 center bg-gray-05">
          <div className="mx3 sm-mx0">
            <div className="h4 caps bold gray-80 my3">LEARN MORE
            </div>
            <div className="max-width-3 mx-auto">
              <div className="flex flex-column sm-row justify-around">

                <div className="bg-white m2 rounded-bottom">
                <a href="http://actions.mydomino.com/" className="text-decoration-none black">
                  <img src="/fat_icons/appetizers.jpg" className="fill-x rounded-top"/>
                    <h3 className="px1 left-align mb0">Appetizers: Your first course</h3>
                    <p className="h5 left-align gray-80 px1 mt1 mb3 col-10">Expand your gastronomy horizons
                    </p>
                  </a>
                </div>

                <div className="bg-white m2 rounded-bottom">
                  <a href="https://mydomino.com/articles/cows-climate-change" className="text-decoration-none black">
                  <img src="/fat_icons/cow-tongue.jpg" className="fill-x rounded-top"/>
                    <h3 className="px1 left-align mb0">Are cows the key to saving the planet?</h3>
                    <p className="h5 left-align gray-80 px1 mt1 mb3 col-10">They may look sweet and innocent, but don’t let that fool you!
                    </p>
                    </a>
                </div>
                <div className="bg-white m2 rounded-bottom">
                  <a href="https://mydomino.com/articles/hidden-health-benefits-of-ugly-produce/" className="text-decoration-none black">
                  <img src="/fat_icons/ugly-apples.jpg" className="fill-x rounded-top"/>
                    <h3 className="px1 left-align mb0">Hidden health. Benefits of ugly produce</h3>
                    <p className="h5 left-align gray-80 px1 mt1 mb3 col-11">Imperfect produce may be more perfect than you realize
                    </p>
                    </a>
                  </div>

              </div>
              </div>
            </div>
      </div>

      </div>
    );
  }
}
