import { Cookies } from 'quasar';
import createAxiosInstance from 'src/helpers/axios_instance';
import { useUserStore } from 'src/stores/user-store';

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
    const token = response.headers.authorization;
    
    // Armazena o token e atualiza o user store
    Cookies.set('bearerToken', token, { expires: '1d' });
    const userStore = useUserStore();
    userStore.setUser({
      id: Number(user.id),
      name: user.name,
      email: user.email
    });

    return { user, token };
  } catch {
    throw new Error('Falha no login. Verifique suas credenciais.');
  }
};

export const logout = async (): Promise<void> => {
  try {
    await web.delete('/logout');
  } finally {
    // Limpa o token e o user store
    Cookies.remove('bearerToken');
    const userStore = useUserStore();
    userStore.clearUser();
  }
};

export const getCurrentUser = (): User | null => {
  const userStore = useUserStore();
  const userInfo = userStore.getUserInfo;
  return userInfo.id ? {
    id: String(userInfo.id),
    name: userInfo.name || '',
    email: userInfo.email || ''
  } : null;
};

export const isLoggedIn = (): boolean => {
  return !!Cookies.get('bearerToken');
};
