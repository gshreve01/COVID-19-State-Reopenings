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
function newGroup(groupid){
    var chartGroup = svg.append("g")
                        // .attr("transform", `translate(${margin.left}, ${margin.top})`)
                        .attr("id",groupid)
    return chartGroup
}
var chartGroup = svg.append("g")
.attr("transform", `translate(${margin.left}, ${margin.top})`);

//Initial Params
var chosenXAxis = "Pos_Tests"

// function used for updating x-scale var upon click on axis label
function xScale(dailyData, chosenXAxis) {
    // create scales
    console.log(dailyData[0][chosenXAxis])
    var xLinearScale = d3.scaleLinear()
        .range([0, width])
        .domain([0,
        d3.max(dailyData, d => d[chosenXAxis]) 
        ])
        // .domain([0, d3.max(dailyData, function (d) {
        //     return d[chosenXAxis];
        // })]);
        // console.log("xlinear")
        // console.log(xLinearScale())
    return xLinearScale;
}

//function used for updating y-scale
function yScale(fdata){
    var yordscale = d3.scale.ordinal()
    .rangeRoundBands([height, 0], .1)
    .domain(fdata.map(function (d) {
        return d.State;
    }));

    return yordscale
}
// function used for updating xAxis var upon click on axis label
function renderAxes(newXScale, xAxis) {
    var bottomAxis = d3.axisBottom(newXScale);

    xAxis.transition()
        .duration(1000)
        .call(bottomAxis);

    return xAxis;
    }
// function to make a bars of graph

function createbar(first,sourcedata, cclass, chosenXAxis,color){


    if(chosenXAxis ==="Pos_Tests"){
        var diff = "NewPosCases"
    }
    else{
        var diff = "NewDeaths"
    }
    var xLinearScale = xScale(sourcedata, chosenXAxis);

    var yOrdinalScale =yScale(sourcedata)
    if(first === "N")
    {   
        console.log("erase")
        d3.selectAll("svg > *").remove();

        addscat = document.getElementById("appendscatter")
        addscat.append("div")
                .attr("id","scatter")
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
        // var el = document.getElementById(cclass);
        // while (el.firstChild) {
        //     console.log("remove")
        //     el.removeChild(el.firstChild);
        // }
        obj = newGroup(cclass).selectAll("."+ cclass)
            .remove()
            .data(sourcedata)
            .enter()
            .append("g")
            .append("rect")
            .attr("class","bar")
            .attr("y", function(d){
                return yOrdinalScale(d.State)
            })
            .attr("fill",color)
            .attr("height", yOrdinalScale.rangeBand())
            .attr("width",function(d){
                if(cclass == "prevbars"){
                    return xLinearScale(d[chosenXAxis]-d[diff])
                }
                else{
                    return xLinearScale(d[chosenXAxis])
                }
                
            });
        
        }
    else {console.log("don't erase")
    var obj = newGroup(cclass).selectAll("."+ cclass)
            .remove()
            .data(sourcedata)
            .enter()
            .append("g")
            .append("rect")
            .attr("class","bar")
            .attr("y", function(d){
                return yOrdinalScale(d.State)
            })
            .attr("fill",color)
            .attr("height", yOrdinalScale.rangeBand())
            .attr("width",function(d){
                if(cclass == "prevbars"){
                    return xLinearScale(d[chosenXAxis]-d[diff])
                }
                else{
                    return xLinearScale(d[chosenXAxis])
                }
                
            });
		}	
	return obj
}


// function used for updating bar graphs group with a transition to
// new bar
function rendertotbars(totbars, newXScale, chosenXAxis) {

    totbars.transition()
    .duration(1000)
    .attr("width", function(d) {
        console.log(d[chosenXAxis])
        console.log(newXScale(d[chosenXAxis]))
        return newXScale(d[chosenXAxis])
    })
    
    // d => newXScale(d[chosenXAxis]));

    return totbars;
}
function renderprevbars(prevbars, newXScale, chosenXAxis) {
    if(chosenXAxis ==="Pos_Tests"){
        var diff = "NewPosCases"
    }
    else{
        var diff = "NewDeaths"
    }
    prevbars.transition()
    .duration(1000)
    // .data(newdata)
    .attr("width",d => newXScale(d[chosenXAxis]-d[diff]));

    return prevbars;
}


console.log("d3");
d3.csv("static/js/data/Covid19.csv").then(function(dailyData,err) {
        if (err) throw err;
        console.log(dailyData)
        //Convert necessary string fields to integers
        dailyData.forEach(function(data) {
            data.Pos_Tests = +data.Pos_Tests;
            data.Deaths = +data.Deaths;
            data.income = +data.income;
            data.healthcare = +data.healthcare
            });

        
        var filteredData =dailyData.filter(days => days.Date === "2020-07-10")
        console.log(filteredData[0])
        
        function sortdata(data,param){
            data = data.sort(function(a,b){
                return d3.ascending(a[param], b[param])
        })
        }
        //sort initial data
        sortdata(filteredData,"Pos_Tests")

        console.log("organized filtered data")
        console.log(filteredData)

        //function to return unique values of a list
        function uniqueValues(value, index, self){
            return self.indexOf(value) === index
        }
        var sts = filteredData.map(d => d.State.toUpperCase()).filter(uniqueValues).sort();
        console.log(sts)
        //Create State selection drop down options
        sts.forEach(function(c) {
            var x = d3.select("#stateSelect");
            x.append("option").text(c).attr("value", c);
        })
        var totalDeaths = filteredData.map(d => d.Deaths)
        var newDeaths = filteredData.map(d => d.NewDeaths)

        

        // xLinearScale function above csv import
        var xLinearScale = xScale(filteredData, chosenXAxis);

        var yOrdinalScale =yScale(filteredData)
        
        
        
        
            
        // Create initial axis functions
        var bottomAxis = d3.axisBottom(xLinearScale);
        var yAxis = d3.axisLeft()
            .scale(yOrdinalScale)
        
        var xaxisheight = height -27
        // append x axis
        var xAxis = chartGroup.append("g")
            .classed("x-axis", true)
            .attr("transform", `translate(-60, ${xaxisheight})`)
            .call(bottomAxis);    

        chartGroup.append("g")
            .attr("transform", function() {
                return "translate(-60,-10)"
            })
            .call(yAxis);

        console.log(totalDeaths)
        // var totbars = svg.selectAll(".totalbar")
        //     .data(filteredData)
        //     .enter()
        //     .append("g")
        //     .append("rect")
        //     .attr("class","bar")
        //     .attr("y", function(d){
        //         return yOrdinalScale(d.State)
        //     })
        //     .attr("height", yOrdinalScale.rangeBand())
        //     .attr("width",function(d){
        //         return xLinearScale(d.Pos_Tests)
        //     });
        createbar("Y",filteredData,"totalbar",chosenXAxis,"green")
        createbar("Y",filteredData,"prevbars",chosenXAxis,"red")
        // var prevbars = svg.selectAll('.'+hey )
        //     .data(filteredData)
        //     .enter()
        //     .append("g")
        //     .append("rect")
        //     .attr("class","bar")
        //     .attr("y", function(d){
        //         return yOrdinalScale(d.State)
        //     })
        //     .attr("fill","red")
        //     .attr("height", yOrdinalScale.rangeBand())
        //     .attr("width",function(d){
        //         return xLinearScale(d.Pos_Tests-d.NewPosCases)
        //     });
        
        //Append initial total bars
        // totbars
        // //Append intial prior day total bars
        // prevbars
        // totbars.append("text")
        //     .attr("class", "label")
        //     .attr("y", yOrdinalScale.rangeBand())

        //     .text(function(d){
        //         return d.Pos_tests;
        //     })
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


        // Create group for two x-axis labels
        var xLabelsGroup = chartGroup.append("g")
        .attr("transform", `translate(${width / 2}, ${height})`);

        var casesLabel = xLabelsGroup.append("text")
        .attr("x", 0)
        .attr("y", 20)
        .attr("value", "Pos_Tests") // value to grab for event listener
        .classed("active", true)
        .classed("inactive",false)
        .text("Total Cases");

        var deathsLabel = xLabelsGroup.append("text")
        .attr("x", 0)
        .attr("y", 40)
        .attr("value", "Deaths") // value to grab for event listener
        .classed("inactive", true)
        .classed("active",false)
        .text("Total Deaths");
        
        // x axis labels event listener
        xLabelsGroup.selectAll("text")
        .on("click", function() {
            // get value of selection
            var value = d3.select(this).attr("value");
            if (value !== chosenXAxis) {

            // replaces chosenXAxis with value
            chosenXAxis = value;

            console.log(chosenXAxis)

            // functions here found above csv import
            // updates x scale for new data
            xLinearScale = xScale(dailyData, chosenXAxis);

            // updates x axis with transition
            xAxis = renderAxes(xLinearScale, xAxis);
                // console.log(totbars)
                // console.log(xLinearScale)
                // console.log(chosenXAxis)
            // updates circles with new x values
            // totbars = rendertotbars(totbars, xLinearScale, chosenXAxis);
            createbar("N",filteredData,"totalbar",chosenXAxis,"blue")
            // prevbars = renderprevbars(prevbars, xLinearScale, chosenXAxis);
            createbar("N",filteredData,"prevbars",chosenXAxis,"red")  
            // updates tooltips with new info
            // totbars = updateToolTip(chosenXAxis,totbars);

            // changes classes to change bold text
            if (chosenXAxis === "Pos_Tests") {
                console.log("cases Bold")
                casesLabel
                .classed("active", true)
                .classed("inactive", false);
                deathsLabel
                .classed("active", false)
                .classed("inactive", true);
            }
            else {
                console.log("deaths bold")
                casesLabel
                .classed("active", false)
                .classed("inactive", true);
                deathsLabel
                .classed("active", true)
                .classed("inactive", false);
                }
            }
        });
        var stateselect = d3.select("#filter-btn")
        stateselect.on("click", limitstates)
        
        function limitstates(){
            var statessel = document.getElementById("stateSelect")
            console.log(statessel[1])
            chosensts = []
            for(i = 0; i<statessel.length;i++){
                currentoption = statessel[i]
                console.log(currentoption)
                if(currentoption.selected == true){
                    console.log(currentoption.value)
                    chosensts.push(currentoption.value)
                }
            }
            console.log(chosensts)

            console.log(chosensts)
            filteredData = filteredData.filter(data => {
                return chosensts.includes(data.State)
            })
            console.log(statefilter)
            
        }
            
    })