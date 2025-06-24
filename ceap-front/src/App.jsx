import React, { useState, useEffect } from 'react';
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

  console.log('App renderizado. Número de deputados no estado:', deputies.length);
  
  // O `currentState` é a "fonte da verdade".
  const [currentState, setCurrentState] = useState(
    localStorage.getItem('lastStateUF') || 'CE'
  );

  // O useEffect observa a variável `currentState`.
  // Será executado na primeira vez que o componente montar e
  // quando o `currentState` for alterado via `setCurrentState`.
  useEffect(() => {
    const fetchDeputies = async () => {
      // Não buscar se o estado for nulo/vazio.
      if (!currentState) return; 

      setIsLoading(true);
      localStorage.setItem('lastStateUF', currentState); 
      try {
        const response = await api.get(`/deputies?state=${currentState}`);
        setDeputies(response.data);
      } catch (error) {
        console.error("Erro ao buscar deputados:", error);
        setDeputies([]);
      } finally {
        setIsLoading(false);
      }
    };

    fetchDeputies();
  }, [currentState]); // `currentState` agora é uma dependência do efeito!

  const handleUploadSuccess = (uploadedState) => {
    setCurrentState(uploadedState);
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