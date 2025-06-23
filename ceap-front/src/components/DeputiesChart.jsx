import React from 'react';
import { Bar } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

function DeputiesChart({ deputiesData }) {
  const chartData = {
    // Pega os nomes dos 10 deputados que mais gastaram para o eixo X
    labels: deputiesData.slice(0, 10).map(d => d.name),
    datasets: [
      {
        label: 'Total de Gastos (R$)',
        // Pega os valores dos 10 que mais gastaram
        data: deputiesData.slice(0, 10).map(d => d.total_expenses),
        backgroundColor: 'rgba(75, 192, 192, 0.6)',
        borderColor: 'rgba(75, 192, 192, 1)',
        borderWidth: 1,
      },
    ],
  };

  const options = {
    responsive: true,
    plugins: {
      legend: {
        position: 'top',
      },
      title: {
        display: true,
        text: 'Top 10 Deputados por Gastos',
      },
    },
  };

  return <Bar data={chartData} options={options} />;
}

export default DeputiesChart;