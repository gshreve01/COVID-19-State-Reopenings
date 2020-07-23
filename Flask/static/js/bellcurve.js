var svgWidth = 900;
var svgHeight = 500;

var margin = {
    top: 20,
    right: 40,
    bottom: 80,
    left: 100
};

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

// Create an SVG wrapper, append an SVG group that will hold our chart,
// and shift the latter by left and top margins.
var svg = d3
    .select("#gradechart")
    .append("svg")
    .attr("width", svgWidth)
    .attr("height", svgHeight);

var chartGroup = svg.append("g")
    .attr("transform", `translate(${margin.left}, ${margin.top})`);

    // Initial Params
var chosenXAxis = "age";
var chosenYAxis = "poverty";

// function used for updating x-scale var upon click on axis label
function xScale(censusData, chosenXAxis) {
  // create scales
    var xLinearScale = d3.scaleLinear()
    .domain([d3.min(censusData, d => d[chosenXAxis]),
    d3.max(censusData, d => d[chosenXAxis])
    ])
    .range([0, width]);
	
    return xLinearScale;

}
// function used for updating y-scale var upon click on axis label
function yScale(censusData, chosenYAxis) {
        // create scales
        var yLinearScale = d3.scaleLinear()
        .domain([0, d3.max(censusData, d => d[chosenYAxis])])
        .range([height, 0]);
    
        return yLinearScale;    
}
