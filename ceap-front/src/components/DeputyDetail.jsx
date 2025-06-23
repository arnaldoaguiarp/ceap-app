import React, { useState, useEffect } from 'react';
import api from '../services/api';

// Recebe o ID do deputado selecionado e uma função para voltar à lista
function DeputyDetail({ deputyId, onBack }) {
  const [details, setDetails] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  // O hook `useEffect` é executado quando o componente é montado
  // ou quando uma de suas dependências (neste caso, `deputyId`) muda.
  useEffect(() => {
    if (deputyId) {
      setIsLoading(true);
      // Busca os detalhes do deputado específico na API
      api.get(`/deputies/${deputyId}`)
        .then(response => {
          setDetails(response.data);
        })
        .catch(error => {
          console.error("Failed to fetch deputy details:", error);
        })
        .finally(() => {
          setIsLoading(false);
        });
    }
  }, [deputyId]); // Array de dependências

  if (isLoading) return <p>Carregando detalhes...</p>;
  if (!details) return null;

  const formatCurrency = (value) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value);
  const formatDate = (dateString) => new Date(dateString).toLocaleDateString('pt-BR');

  return (
    <div className="deputy-detail">
      <button onClick={onBack} className="back-button">&larr; Voltar para a lista</button>
      <div className="detail-header">
        <img src={details.deputy.photo_url} alt={details.deputy.name} className="detail-photo" />
        <div>
          <h2>{details.deputy.name}</h2>
          <p>Partido: {details.deputy.party}-{details.deputy.state}</p>
          <p>Total de Despesas: <strong>{formatCurrency(details.total_expenses)}</strong></p>
        </div>
      </div>

      <h4>Despesas Detalhadas</h4>
      <ul className="expenses-list">
        {details.expenses.map(expense => (
          <li key={expense.id}>
            <span>{formatDate(expense.issue_date)}</span>
            <span>{expense.supplier}</span>
            <strong>{formatCurrency(expense.net_value)}</strong>
            <a href={expense.document_url} target="_blank" rel="noopener noreferrer">Ver Nota</a>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default DeputyDetail;