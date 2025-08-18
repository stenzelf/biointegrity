// viewer.js

document.getElementById('year-select').addEventListener('change', () => {
  updateContent();
});
document.getElementById('variable-select').addEventListener('change', () => {
  updateContent();
  updateVariableInfo();
});

function updateContent() {
  const variable = document.getElementById('variable-select').value;
  const yearSelect = document.getElementById('year-select');
  const year = yearSelect.value;
  const rasterImage = document.getElementById("raster-image");

  if (variable == "timeline_combined" || variable == "timeline_separate") {
    // Show timeline_X.png and disable year selector
    rasterImage.src = `assets/data/${variable}.png`;
    yearSelect.disabled = true;

      const pngLink = document.getElementById('download-link-png');
      pngLink.href = `assets/data/${variable}.png`;
      pngLink.textContent = `${variable}.png`;

      const singleLink = document.getElementById('download-link');
      singleLink.href = `assets/data/${variable}.csv`;
      singleLink.textContent = `${variable}.csv`;

      const combinedLink = document.getElementById('combined-download-link');
      combinedLink.href = "javascript: void(0)";
      combinedLink.textContent = "";
      
      const zipLink = document.getElementById('zip-download-link');
      zipLink.href = `assets/data/data.zip`;
      zipLink.textContent = `data.zip`;

  } else {
    // Show other var and enable year selector
      yearSelect.disabled = false;

      const pngLink = document.getElementById('download-link-png');
      pngLink.href = `assets/data/${variable}_${year}.png`;
      pngLink.textContent = `${variable}_${year}.png`;

      rasterImage.src = pngLink.href;

      const singleLink = document.getElementById('download-link');
      singleLink.href = `assets/data/${variable}_${year}.tif`;
      singleLink.textContent = `${variable}_${year}.tif`;

      const combinedLink = document.getElementById('combined-download-link');
      combinedLink.href = `assets/data/${variable}.tif`;
      combinedLink.textContent = `${variable}.tif`;
      
      const zipLink = document.getElementById('zip-download-link');
      zipLink.href = `assets/data/data.zip`;
      zipLink.textContent = `data.zip`;
  }
}

function updateVariableInfo() {
  const variable = document.getElementById('variable-select').value;
  const info = variableInfo[variable];
  document.getElementById('description-text').innerHTML = info.description;
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
    description: "HANPP with respect to reference NPP",
    unit: "fraction of preindustrial potential NPP"
  },
  hanpp_harv: {
    description: "HANPP component: harvest (biomass extraction for crops, residues, grassland, timber)",
    unit: "gC/m²/yr"
  },
  ecorisk_total_cv: {
    description: "EcoRisk (average of vs, lc, gi, eb)",
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
  pb_risk_combined: {
    description: "Combined local boundary status (at least one of HANPP<sup>Hol</sup> or EcoRisk)",
    unit: "[0-1]"
  },
  pb_risk_hanpp: {
    description: "Local boundary status based on HANPP<sup>Hol</sup>",
    unit: "[0-1]"
  },
  pb_risk_ecorisk: {
    description: "Local boundary status based on EcoRisk",
    unit: "[0-1]"
  },
  timeline_combined: { 
    description: "Timeline of global area transgressing the combined local boundary status", 
    unit: "%" 
  },
  timeline_separate: { 
    description: "Timeline of global area transgressing the local boundary status for each indicator", 
    unit: "%" 
  }
};

updateContent();
updateVariableInfo();

