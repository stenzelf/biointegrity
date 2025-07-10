document.addEventListener('DOMContentLoaded', () => {
  fetch('assets/data/timelines/global_summary.csv')
    .then(res => res.text())
    .then(csv => {
      const rows = csv.trim().split('\n').slice(1);
      const labels = [], values = [];
      for (const row of rows) {
        const [year, value] = row.split(',');
        labels.push(year);
        values.push(+value);
      }
      new Chart(document.getElementById('timelineChart'), {
        type: 'line',
        data: {
          labels,
          datasets: [{
            label: 'Global Summary',
            data: values,
            borderColor: 'blue',
            fill: false
          }]
        }
      });
    });
});
