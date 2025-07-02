import React, { useState, useEffect, useRef } from 'react';
import api from './services/api';
import FileUpload from './components/FileUpload';
import DeputiesList from './components/DeputiesList';
import DeputyDetail from './components/DeputyDetail';
import DeputiesChart from './components/DeputiesChart';
import './App.css';

function App() {
  const [deputies, setDeputies] = useState([]);
  const [selectedDeputyId, setSelectedDeputyId] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isProcessing, setIsProcessing] = useState(false);

  console.log('App renderizado. Número de deputados no estado:', deputies.length);
  
  const [currentState, setCurrentState] = useState(
    localStorage.getItem('lastStateUF') || 'CE'
  );

  // Usamos useRef para guardar a referência do timer do polling
  const pollingTimer = useRef(null);

  const fetchDeputies = async (state) => {
    setIsLoading(true);
    localStorage.setItem('lastStateUF', state);
    try {
      const response = await api.get(`/deputies?state=${state}`);
      // Lógica de parada do polling: se recebermos dados, paramos.
      if (response.data.length > 0) {
        setDeputies(response.data);
        stopPolling(); // Para o timer se encontrou dados
      }
    } catch (error) {
      console.error("Erro ao buscar deputados:", error);
      setDeputies([]);
    } finally {
      setIsLoading(false);
    }
  };

  const stopPolling = () => {
    clearInterval(pollingTimer.current);
    setIsProcessing(false);
  };

  useEffect(() => {
    // Busca inicial de dados ao carregar a página
    fetchDeputies(currentState);
    
    // Cleanup: Timer é limpo se o componente for desmontado
    return () => {
      if (pollingTimer.current) {
        stopPolling();
      }
    };
  }, []);

  const handleUploadSuccess = (uploadedState) => {
    // Limpa a lista atual e mostra uma mensagem de processamento
    setDeputies([]); 
    setIsProcessing(true);
    setCurrentState(uploadedState);

    // Inicia o polling: a cada 3 segundos, chama fetchDeputies
    pollingTimer.current = setInterval(() => {
      fetchDeputies(uploadedState);
    }, 3000);

    // Adiciona um timeout de segurança para parar o polling após 1 minuto
    setTimeout(() => {
      stopPolling();
    }, 60000); 
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
        {isProcessing && <div className="processing-message">Processando dados, por favor aguarde... A lista será atualizada automaticamente.</div>}
        
        {!selectedDeputyId ? (
          <>
            <FileUpload onUploadSuccess={handleUploadSuccess} />
            {deputies.length > 0 && <DeputiesChart deputiesData={deputies} />}
            <DeputiesList deputies={deputies} onSelectDeputy={handleSelectDeputy} isLoading={isLoading} />
          </>
        ) : (
          <DeputyDetail deputyId={selectedDeputyId} onBack={handleBackToList} />
        )}
      </main>
    </div>
  );
}

export default App;