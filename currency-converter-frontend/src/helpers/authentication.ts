import { Cookies, SessionStorage } from "quasar";
import createAxiosInstance from "src/helpers/axios_instance";
import { getActivePinia } from "pinia";
import { notifyErrorMessage } from "src/helpers/notify";
import type { NavigationGuardNext, RouteLocationNormalized } from "vue-router";

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:3000";
const web = createAxiosInstance(API_BASE_URL);

/**
 * Valida o token de autenticação e redireciona conforme necessário
 * @param to - Rota de destino
 * @param from - Rota de origem 
 * @param next - Função de callback para navegação
 * @returns Promise com o resultado da validação
 */
export const validateToken = async (
  to: RouteLocationNormalized,
  from: RouteLocationNormalized,
  next: NavigationGuardNext
): Promise<void> => {
  try {
    const bearerToken = Cookies.get("bearerToken");
    
    if (!bearerToken) {
      SessionStorage.clear();
      return next("/login");
    }

    await web.post("/validate", {}, {
      headers: { Authorization: `${bearerToken}` }
    });
    
    next();
  } catch  {
    notifyErrorMessage("Sessão expirada. Faça login novamente.");
    SessionStorage.clear();
    const pinia = getActivePinia();
    if (pinia) {
      Object.values(pinia.state.value).forEach(state => {
        if (state && state.$reset) state.$reset();
      });
    }
    next("/login");
  }
};

/**
 * Verifica se o usuário está autenticado e redireciona conforme necessário
 * @param to - Rota de destino
 * @param from - Rota de origem
 * @param next - Função de callback para navegação
 * @returns Promise vazia
 */
export const isAuthenticated = async (
  to: RouteLocationNormalized,
  from: RouteLocationNormalized,
  next: NavigationGuardNext
): Promise<void> => {
  const bearerToken = Cookies.get("bearerToken");
  
  if (!bearerToken) {
    return next();
  }

  try {
    await web.post("/validate", {}, {
      headers: { Authorization: `${bearerToken}` }
    });
    next("/");
  } catch {
    next();
  }
};
