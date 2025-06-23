import axios from 'axios';

const api = axios.create({
  // Como estamos usando Docker Compose, podemos usar o nome do serviço 'backend'
  // Se não estiver usando Docker para rodar, use 'http://localhost:3000'
  baseURL: 'backend',
  headers: {
    'Content-Type': 'application/json',
  },
});

export default api;