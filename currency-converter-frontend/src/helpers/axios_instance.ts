import axios from 'axios';
import type { 
  AxiosInstance, 
  AxiosResponse, 
  AxiosError, 
  InternalAxiosRequestConfig 
} from 'axios';
import { Cookies, SessionStorage } from 'quasar';

/**
 * Cria uma instância do Axios com configurações padrão
 * @param baseURL - URL base da API
 * @returns Instância configurada do Axios
 */
const createAxiosInstance = (baseURL: string): AxiosInstance => {
  const instance: AxiosInstance = axios.create({
    baseURL,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });

  // Interceptor para adicionar token de autenticação
  instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
    const token = Cookies.get('bearerToken');
    if (token) {
      config.headers.Authorization = `${token}`;
    }
    return config;
  });

  // Interceptor para tratamento de erros
  instance.interceptors.response.use(
    (response: AxiosResponse) => response,
    (error: AxiosError) => {
      if (error.response?.status === 401) {
        // Limpa dados de sessão e redireciona para login
        Cookies.remove('bearerToken');
        SessionStorage.clear();
        window.location.href = '/login';
      }
      
      // Tratamento de erros genéricos
      const errorMessage = (error.response?.data as { message?: string })?.message || 'Erro na requisição';
      return Promise.reject(new Error(errorMessage));
    }
  );

  return instance;
};

export default createAxiosInstance;
