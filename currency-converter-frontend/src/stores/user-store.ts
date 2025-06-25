import { defineStore } from 'pinia';
import type { DefineStoreOptions } from 'pinia';
import { reactive, computed } from 'vue';

type CustomStoreOptions = DefineStoreOptions<string, any, any, any> & {
  persist?: boolean;
};

interface UserState {
  id: number | null;
  name: string | null;
  email: string | null;
}

export const useUserStore = defineStore('user', () => {
  const state = reactive<UserState>({
    id: null,
    name: null,
    email: null,
  });

  const isAuthenticated = computed(() => state.id !== null);
  const getUserInfo = computed(() => ({
    id: state.id,
    name: state.name,
    email: state.email,
  }));

  function setUser(user: UserState) {
    state.id = user.id;
    state.name = user.name;
    state.email = user.email;
  }

  function clearUser() {
    state.id = null;
    state.name = null;
    state.email = null;
  }

  return {
    state,
    
    isAuthenticated,
    getUserInfo,
    
    setUser,
    clearUser
  };
}, {
  persist: true,
} as CustomStoreOptions);
