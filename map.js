// map.js

const map = L.map('map').setView([0, 0], 2);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
  maxZoom: 10,
}).addTo(map);

let currentOverlay = null;

function showOverlay(variable, year) {
  if (currentOverlay) {
    map.removeLayer(currentOverlay);
  }
  const url = `assets/data/${variable}_${year}.png`;
  const bounds = [[-90, -180], [90, 180]];
  currentOverlay = L.imageOverlay(url, bounds, { opacity: 0.8 });
  currentOverlay.addTo(map);
  map.fitBounds(bounds);
}

function updateMap() {
  const variable = document.getElementById('variable-select').value;
  const year = document.getElementById('year-select').value;
  showOverlay(variable, year);
}

document.getElementById('year-select').addEventListener('change', () => {
  updateMap();
  updateDownloadLink();
});
document.getElementById('variable-select').addEventListener('change', () => {
  updateMap();
  updateDownloadLink();
});

function updateDownloadLink() {
  const variable = document.getElementById('variable-select').value;
  const year = document.getElementById('year-select').value;
  const link = document.getElementById('download-link');
  link.href = `assets/data/${variable}_${year}.tif`;
  link.textContent = `Download: ${variable}_${year}.tif`;
}

updateMap();
updateDownloadLink();
