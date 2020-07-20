console.log('starting choreplethmap');

// Need to convert the data to javascript array
console.log('rows', rows)
// rows = rows.replace("\\\n", "\n").replace("\"", "'")
// console.log('JSON rows', JSON.parse(rows))
var repositoryDataArray = rows;
console.log(repositoryDataArray);

var mapData = {};
function loadStatesData() {
  Object.assign(mapData, statesData);

  // console.log(jsonArray);

  console.log(mapData.features);

  mapData.features.forEach((feature) => {
    // Get the state that the feature represents
    var stateName = feature.properties.name;
    var stateRow = repositoryDataArray.filter(x => x.state == stateName)[0];
    console.log(stateName, stateRow);
  }
  );
}

function loadStatesMap() {
  var myMap = L.map('map').setView([37.8, -96], 5);

  L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    attribution: "© <a href='https://www.mapbox.com/about/maps/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a> <strong><a href='https://www.mapbox.com/map-feedback/' target='_blank'>Improve this map</a></strong>",
    tileSize: 512,
    maxZoom: 18,
    zoomOffset: -1,
    id: 'mapbox/streets-v11',
    accessToken: API_KEY
  }).addTo(myMap);

  L.geoJson(mapData).addTo(myMap);
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


        