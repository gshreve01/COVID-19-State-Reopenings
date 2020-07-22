console.log('starting choreplethmap');

// Need to convert the data to javascript array
console.log('rows', rows)
// rows = rows.replace("\\\n", "\n").replace("\"", "'")
// console.log('JSON rows', JSON.parse(rows))
var repositoryDataArray = rows;
console.log(repositoryDataArray);

// sort the quantile values in descending order
quantiles = quantiles.sort((a,b) => b-a);
console.log("quantiles", quantiles);
console.log("datapointmap", dataPointMap);

var mapData = {};
function loadStatesData() {
  Object.assign(mapData, statesData);

  // console.log(jsonArray);

  console.log(mapData.features);

  mapData.features.forEach((feature) => {
    // Get the state that the feature represents
    var stateName = feature.properties.name;
    var stateRow = repositoryDataArray.filter(x => x.state == stateName)[0];
    feature.properties["density"] = stateRow["density"];
    feature.properties["positiveincrease"] = stateRow["positiveincrease"];
    console.log("feature.properties", feature.properties);
    // console.log(stateName, stateRow);
  }
  );
}

function getColor(d) {
  return d > quantiles[0] ? '#800026' :
         d > quantiles[1]  ? '#BD0026' :
         d > quantiles[2]  ? '#E31A1C' :
         d > quantiles[3]  ? '#FC4E2A' :
         d > quantiles[4]   ? '#FD8D3C' :
         d > quantiles[5]   ? '#FEB24C' :
        //  d > quantiles[6]   ? '#FED976' :
                    '#FFEDA0';
}

// mode function taken from https://stackoverflow.com/questions/52898456/simplest-way-of-finding-mode-in-javascript
var mode = a => {
  a.sort((x, y) => x - y);

  var bestStreak = 1;
  var bestElem = a[0];
  var currentStreak = 1;
  var currentElem = a[0];

  for (let i = 1; i < a.length; i++) {
    if (a[i-1] !== a[i]) {
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
        bestElem = currentElem;
      }

      currentStreak = 0;
      currentElem = a[i];
    }

    currentStreak++;
  }

  return currentStreak > bestStreak ? currentElem : bestElem;
};

function loadStatesMap() {
  var myMap = L.map('map').setView([37.8, -96], 4);

  L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    attribution: "© <a href='https://www.mapbox.com/about/maps/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a> <strong><a href='https://www.mapbox.com/map-feedback/' target='_blank'>Improve this map</a></strong>",
    tileSize: 512,
    zoomOffset: -1,
    id: 'mapbox/streets-v11',
    accessToken: API_KEY
  }).addTo(myMap);

  L.geoJson(mapData).addTo(myMap);

  function style(feature) {
    console.log("Setting style");
    return {
        fillColor: getColor(feature.properties["positiveincrease"]),
        weight: 2,
        opacity: 1,
        color: 'white',
        dashArray: '3',
        fillOpacity: 0.7
    };
  }
  
  L.geoJson(mapData, {style: style}).addTo(myMap);
}



// L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
//   attribution: '© <a href='https://www.mapbox.com/about/maps/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a> <strong><a href='https://www.mapbox.com/map-feedback/' target='_blank'>Improve this map</a></strong>',
//   tileSize: 512,
//   maxZoom: 18,
//   zoomOffset: -1,
//   id: 'mapbox/streets-v11',
//   accessToken: API_KEY
// }).addTo(myMap);

loadStatesData();
loadStatesMap();

console.log('finished choreplethmap');

// L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
//     id: 'mapbox/light-v9',
//     attribution: '© <a href='https://www.mapbox.com/about/maps/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a> <strong><a href='https://www.mapbox.com/map-feedback/' target='_blank'>Improve this map</a></strong>',
//     tileSize: 512,
//     zoomOffset: -1,
//     accessToken: API_KEY
// }).addTo(myMap);

// Replace out density with latest density as well as
// the rest of the data


        