import React, { useState } from 'react';
import api from './services/api';
import FileUpload from './components/FileUpload';
import DeputiesList from './components/DeputiesList';
import DeputyDetail from './components/DeputyDetail';
import DeputiesChart from './components/DeputiesChart'; // Importando o gráfico
import './App.css'; // Vamos criar um CSS básico

function App() {
  const [deputies, setDeputies] = useState([]);
  const [selectedDeputyId, setSelectedDeputyId] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  console.log('App renderizado. Número de deputados no estado:', deputies.length);

  // Função que busca os deputados na API
  const fetchDeputies = async (state) => {
    setIsLoading(true);
    try {
      // A chamada será para `http://localhost:3000/api/v1/deputies?state=CE` (ou o estado escolhido)
      const response = await api.get(`/deputies?state=${state}`);
      console.log('Dados recebidos da API:', response.data);
      setDeputies(response.data);
    } catch (error) {
      console.error("Erro ao buscar deputados:", error);
      setDeputies([]); // Limpa a lista em caso de erro
    } finally {
      setIsLoading(false);
    }
  };

  // Função de callback para ser chamada após o sucesso do upload
  const handleUploadSuccess = (state) => {
    fetchDeputies(state);
  };

  const handleSelectDeputy = (deputy) => {
    setSelectedDeputyId(deputy.id);
  };

  const handleBackToList = () => {
    setSelectedDeputyId(null);
  };

  return (
    <div className="app-container">
      <header>
        <h1>CEAP - Cota Parlamentar</h1>
      </header>
      <main>
        {!selectedDeputyId ? (
          // Se nenhum deputado estiver selecionado, mostra a tela principal
          <>
            <FileUpload onUploadSuccess={handleUploadSuccess} />
            {deputies.length > 0 && <DeputiesChart deputiesData={deputies} />}
            <DeputiesList deputies={deputies} onSelectDeputy={handleSelectDeputy} isLoading={isLoading} />
          </>
        ) : (
          // Se um deputado for selecionado, mostra apenas os detalhes
          <DeputyDetail deputyId={selectedDeputyId} onBack={handleBackToList} />
        )}
      </main>
    </div>
  );
}

export default App;