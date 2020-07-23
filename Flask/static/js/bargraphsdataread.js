console.log("Beginning BarGraphsDataRead");

//set up svg using margin conventions - we'll need plenty of room on the left for labels
var margin = {
    top: 15,
    right: 60,
    bottom: 60,
    left: 60
};

var width = 960 - margin.left - margin.right,
    height = 700 - margin.top - margin.bottom;

var svg = d3.select("#scatter").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// Append an SVG group
var chartGroup = svg.append("g")
.attr("transform", `translate(${margin.left}, ${margin.top})`);


// function used for updating x-scale var upon click on axis label
function xScale(dailyData, chosenXAxis) {
    // create scales
    var xLinearScale = d3.scaleLinear()
        .domain([d3.min(dailyData, d => d[chosenXAxis]) * 0.8,
        d3.max(dailyData, d => d[chosenXAxis]) * 1.2
        ])
        .range([0, width]);

    return xLinearScale;
}

// function used for updating xAxis var upon click on axis label
function renderAxes(newXScale, xAxis) {
var bottomAxis = d3.axisBottom(newXScale);

xAxis.transition()
    .duration(1000)
    .call(bottomAxis);

return xAxis;
}
var ddata = []

console.log("d3");
d3.csv("static/js/data/Covid19.csv").then(function(dailyData,err) {
        if (err) throw err;
        console.log(dailyData)
        dailyData.forEach(function(data) {
            data.Pos_Tests = +data.Pos_Tests;
            data.Deaths = +data.Deaths;
            data.income = +data.income;
            data.healthcare = +data.healthcare
            });
        ddata = dailyData    
        datelist = ["2020-07-10","2020-07-09"]
        var filteredData =dailyData.filter(days => days.Date === "2020-07-10")
        console.log(filteredData[0])

        filteredData = filteredData.sort(function(a,b){
            return d3.descending(a.Pos_Tests, b.Pos_Tests)
        })
        console.log("organized filtered data")
        console.log(filteredData)

        //function to return unique values of a list
        function uniqueValues(value, index, self){
            return self.indexOf(value) === index
        }
        var sts = filteredData.map(d => d.State.toUpperCase()).filter(uniqueValues).sort();
        console.log(sts)
        //Create State selection
        sts.forEach(function(c) {
            var x = d3.select("#stateSelect");
            x.append("option").text(c).attr("value", c);
        })
        var totalDeaths = filteredData.map(d => d.Deaths)
        var newDeaths = filteredData.map(d => d.NewDeaths)

        // Create group for two x-axis labels
        var xLabelsGroup = chartGroup.append("g")
        .attr("transform", `translate(${width / 2}, ${height})`);

        var casesLabel = xLabelsGroup.append("text")
        .attr("x", 0)
        .attr("y", 20)
        .attr("value", "age") // value to grab for event listener
        .classed("active", true)
        .classed("inactive",false)
        .text("Total Cases");

        var deathsLabel = xLabelsGroup.append("text")
        .attr("x", 0)
        .attr("y", 40)
        .attr("value", "income") // value to grab for event listener
        .classed("inactive", true)
        .classed("active",false)
        .text("Total Deaths");

        var x = d3.scale.linear()
        .range([0, width])
        .domain([0, d3.max(filteredData, function (d) {
            return d.Pos_Tests;
        })]);

        var y = d3.scale.ordinal()
            .rangeRoundBands([height, 0], .1)
            .domain(filteredData.map(function (d) {
                return d.State;
            }));

        var yAxis = d3.axisLeft()
            .scale(y)
            

        chartGroup.append("g")
            .attr("transform", function() {
                return "translate(-60,-10)"
            })
            .call(yAxis);

        console.log(totalDeaths)
        var totbars = svg.selectAll(".totalbar")
            .data(filteredData)
            .enter()
            .append("g")
        var prevbars = svg.selectAll(".prevbar")
        .data(filteredData)
        .enter()
        .append("g")
        

        totbars.append("rect")
            .attr("class","bar")
            .attr("y", function(d){
                return y(d.State)
            })
            .attr("height", y.rangeBand())
            .attr("width",function(d){
                return x(d.Pos_Tests)
            });

        prevbars.append("rect")
        .attr("class","bar")
        .attr("y", function(d){
            return y(d.State)
        })
        .attr("fill","red")
        .attr("height", y.rangeBand())
        .attr("width",function(d){
            return x(d.Pos_Tests-d.NewPosCases)
        });
        totbars.append("text")
            .attr("class", "label")
            .attr("y", y.rangeBand())

            .text(function(d){
                return d.Pos_tests;
            })
    
        
            // bars.append("text")
            // .attr("class", "label")
            // //y position of the label is halfway down the bar
            // .attr("y", function (d) {
            //     return y(d.State) + y.rangeBand() / 2 + 4;
            // })
            // //x position is 3 pixels to the right of the bar
            // .attr("x", function (d) {
            //     return x(d.Pos_Tests) + 3;
            // })
            // .text(function (d) {
            //     return d.Pos_Tests;
            // });
        // })
    })