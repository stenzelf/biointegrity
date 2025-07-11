// map.js

const map = L.map('map').setView([0, 0], 2);

//L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//  maxZoom: 10,
//}).addTo(map);

let currentOverlay = null;

function showOverlay(variable, year) {
  if (currentOverlay) {
    map.removeLayer(currentOverlay);
  }
  const url = `assets/data/${variable}_${year}.png`;
  const bounds = [[-40, -250], [90, 250]];
  currentOverlay = L.imageOverlay(url, bounds, { opacity: 1 });
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
  updateVariableInfo();
});

function updateDownloadLink() {
  const variable = document.getElementById('variable-select').value;
  const year = document.getElementById('year-select').value;

  const singleLink = document.getElementById('download-link');
  singleLink.href = `assets/data/${variable}_${year}.tif`;
  singleLink.textContent = `Download: ${variable}_${year}.tif`;

  const combinedLink = document.getElementById('combined-download-link');
  combinedLink.href = `assets/data/${variable}.tif`;
  combinedLink.textContent = `Download all years: ${variable}.tif`;
  
  const zipLink = document.getElementById('zip-download-link');
  zipLink.href = `assets/data/data.zip`;
  zipLink.textContent = `Download all data: data.zip`;
}

function updateVariableInfo() {
  const variable = document.getElementById('variable-select').value;
  const info = variableInfo[variable];
  document.getElementById('description-text').textContent = info.description;
  document.getElementById('unit-text').textContent = `Unit: ${info.unit}`;
}

const variableInfo = {
  hanpp_total: {
    description: "Human appropriation of net primary production (HANPP)",
    unit: "gC/m²/yr"
  },
  hanpp_npp_pot: {
    description: "Potential net primary productivity",
    unit: "gC/m²/yr"
  },
  hanpp_npp_act: {
    description: "Actual net primary productivity",
    unit: "gC/m²/yr"
  },
  hanpp_luc: {
    description: "HANPP component: land use change",
    unit: "gC/m²/yr"
  },
  hanpp_hol_cv: {
    description: "HANPP_hol",
    unit: "fraction of preindustrial potential NPP"
  },
  hanpp_harv: {
    description: "HANPP component: harvest",
    unit: "gC/m²/yr"
  },
  ecorisk_total_cv: {
    description: "EcoRisk average",
    unit: "[0-1]"
  },
  ecorisk_vs: {
    description: "EcoRisk: vegetation structure change",
    unit: "[0-1]"
  },
  ecorisk_lc: {
    description: "EcoRisk: local change",
    unit: "[0-1]"
  },
  ecorisk_gi: {
    description: "EcoRisk: global importance",
    unit: "[0-1]"
  },
  ecorisk_eb: {
    description: "EcoRisk: ecosystem balance",
    unit: "[0-1]"
  },
  pb_risk: {
    description: "Combined local boundary status",
    unit: "[0-1]"
  }
};

updateMap();
updateDownloadLink();
updateVariableInfo();

