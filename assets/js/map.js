document.addEventListener('DOMContentLoaded', () => {
  const map = L.map('map').setView([20, 0], 2);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18,
    attribution: '&copy; OpenStreetMap contributors'
  }).addTo(map);

  const yearInput = document.getElementById('year');

  function loadMap(year) {
    fetch(`assets/data/maps/${year}.geojson`)
      .then(res => res.json())
      .then(data => {
        if (window.currentLayer) {
          map.removeLayer(window.currentLayer);
        }
        window.currentLayer = L.geoJSON(data).addTo(map);
      });
  }

  yearInput.addEventListener('change', () => {
    loadMap(yearInput.value);
  });

  loadMap(yearInput.value);
});
