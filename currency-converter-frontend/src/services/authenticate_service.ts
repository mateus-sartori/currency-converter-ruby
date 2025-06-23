import { Cookies, SessionStorage } from 'quasar';
import createAxiosInstance from 'src/helpers/axios_instance';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:3000";
const web = createAxiosInstance(API_BASE_URL);

interface User {
  id: string;
  name: string;
  email: string;
}

interface LoginResponse {
  user: User;
  token: string;
}

export const login = async (email: string, password: string): Promise<LoginResponse> => {
  try {
    const response = await web.post('/login', {
      user: {
        email,
        password
      }
    });

    const { user } = response.data;
    const token = response.headers.authorization
    
    // Armazena o token e informações do usuário
    Cookies.set('bearerToken', token, { expires: '1d' });
    SessionStorage.set('user', user);

    return { user, token };
  } catch {
    throw new Error('Falha no login. Verifique suas credenciais.');
  }
};

export const logout = async (): Promise<void> => {
  try {
    await web.delete('/logout');
  } finally {
    // Limpa os dados de sessão
    Cookies.remove('bearerToken');
    SessionStorage.clear();
  }
};

export const getCurrentUser = (): User | null => {
  return SessionStorage.getItem('user');
};

export const isLoggedIn = (): boolean => {
  return !!Cookies.get('bearerToken');
};
