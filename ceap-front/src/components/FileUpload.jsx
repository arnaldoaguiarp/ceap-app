import React, { useState } from 'react';
import api from '../services/api';

// Recebe uma função `onUploadSuccess` como propriedade (prop)
// para notificar o componente pai quando o upload for bem-sucedido.
function FileUpload({ onUploadSuccess }) {
  const [file, setFile] = useState(null);
  const [stateUF, setStateUF] = useState('CE');
  const [isLoading, setIsLoading] = useState(false);
  const [message, setMessage] = useState('');

  const handleFileChange = (event) => {
    setFile(event.target.files[0]);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    if (!file) {
      setMessage('Por favor, selecione um arquivo.');
      return;
    }

    setIsLoading(true);
    setMessage('Enviando arquivo... Isso pode levar um momento.');

    // FormData é usado para enviar arquivos via HTTP
    const formData = new FormData();
    formData.append('file', file);
    formData.append('state_uf', stateUF);

    try {
      // A URL aqui é relativa à baseURL que definimos no `api.js`
      const response = await api.post('/uploads', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });

      setMessage(response.data.message);
      // Chama a função do componente pai para atualizar a lista de deputados
      onUploadSuccess(stateUF);
    } catch (error) {
      setMessage('Erro ao enviar o arquivo. Verifique o console.');
      console.error('Upload error:', error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="upload-container">
      <h2>Ranking de Gastos dos Deputados</h2>
      <form onSubmit={handleSubmit}>
        <p>Faça o upload do arquivo <strong>Ano-2024.csv</strong> para analisar os gastos do seu estado.</p>
        <div>
          <label htmlFor="state">Estado:</label>
          <input
            type="text"
            id="state"
            value={stateUF}
            onChange={(e) => setStateUF(e.target.value.toUpperCase())}
            maxLength="2"
            placeholder="Ex: CE"
            required
          />
        </div>
        <div>
          <label htmlFor="file-upload">Arquivo CSV:</label>
          <input type="file" id="file-upload" accept=".csv" onChange={handleFileChange} required />
        </div>
        <button type="submit" disabled={isLoading}>
          {isLoading ? 'Processando...' : 'Enviar e Analisar'}
        </button>
      </form>
      {message && <p className="message">{message}</p>}
    </div>
  );
}

export default FileUpload;