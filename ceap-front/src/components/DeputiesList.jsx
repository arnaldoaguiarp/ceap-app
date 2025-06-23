import React from 'react';

// Recebe a lista de deputados e uma função para quando um deputado for selecionado
function DeputiesList({ deputies, onSelectDeputy, isLoading }) {
  if (isLoading) {
    return <p>Carregando deputados...</p>;
  }

  if (deputies.length === 0) {
    return <p>Nenhum dado para exibir. Faça o upload do arquivo para o estado desejado.</p>;
  }

  // Função para formatar o valor como moeda brasileira
  const formatCurrency = (value) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL',
    }).format(value);
  };

  return (
    <div className="deputies-list">
      <h3>Ranking de Gastos</h3>
      <ul>
        {deputies.map((deputy) => (
          <li key={deputy.id} onClick={() => onSelectDeputy(deputy)}>
            <img src={deputy.photo_url} alt={`Foto de ${deputy.name}`} className="deputy-photo" />
            <div className="deputy-info">
              <span className="deputy-name">{deputy.name} ({deputy.party})</span>
              <span className="deputy-expenses">Total Gasto: {formatCurrency(deputy.total_expenses)}</span>
            </div>
            <span className="view-details">Ver Detalhes &rarr;</span>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default DeputiesList;