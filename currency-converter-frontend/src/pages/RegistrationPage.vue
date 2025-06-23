<template>
  <q-layout view="hHh lpR fFf">
    <q-page-container>
      <q-page class="flex flex-center bg-blue-grey-1">
        <q-card class="q-pa-md shadow-2" style="width: 100%; max-width: 500px;">
          <q-card-section>
            <div class="text-h4 text-center text-weight-bold q-mb-md">
              Criar Nova Conta
            </div>
            <q-img 
              src="https://cdn.quasar.dev/img/material.png" 
              spinner-color="primary" 
              style="height: 150px;"
              class="q-mb-md rounded-borders"
            />
          </q-card-section>

          <q-card-section>
            <q-form @submit="handleRegistration" class="q-gutter-md">
              <q-input
                v-model="name"
                label="Nome completo"
                outlined
                color="primary"
                :rules="[val => !!val || 'O nome é obrigatório']"
              />
              
              <q-input
                v-model="email"
                type="email"
                label="Email"
                outlined
                color="primary"
                :rules="[
                  val => !!val || 'O email é obrigatório',
                  val => /.+@.+\..+/.test(val) || 'Email inválido'
                ]"
              />
              
              <q-input
                v-model="password"
                type="password"
                label="Senha"
                outlined
                color="primary"
                :rules="[
                  val => !!val || 'A senha é obrigatória',
                  val => val.length >= 6 || 'A senha deve ter pelo menos 6 caracteres'
                ]"
              />
              
              <q-input
                v-model="confirmPassword"
                type="password"
                label="Confirmar senha"
                outlined
                color="primary"
                :rules="[
                  val => !!val || 'Confirme sua senha',
                  val => val === password || 'As senhas não coincidem'
                ]"
              />
              
              <div class="q-mt-lg">
                <q-btn
                  type="submit"
                  color="primary"
                  label="Criar conta"
                  :loading="loading"
                  class="full-width"
                  size="lg"
                />
              </div>
            </q-form>
          </q-card-section>

          <q-card-section class="text-center q-pt-none">
            <div class="text-caption">
              Já tem uma conta? <router-link to="/login" class="text-primary">Faça login</router-link>
            </div>
          </q-card-section>
        </q-card>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import { useQuasar } from 'quasar';
import { useRouter } from 'vue-router';
import createAxiosInstance from 'src/helpers/axios_instance';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000';
const web = createAxiosInstance(API_BASE_URL);

export default defineComponent({
  name: 'RegistrationPage',
  
  setup() {
    const $q = useQuasar();
    const router = useRouter();
    
    const name = ref('');
    const email = ref('');
    const password = ref('');
    const confirmPassword = ref('');
    const loading = ref(false);

    const handleRegistration = async () => {
      try {
        loading.value = true;
        
        await web.post('/register', {
          name: name.value,
          email: email.value,
          password: password.value
        });
        
        $q.notify({
          type: 'positive',
          message: 'Conta criada com sucesso!'
        });
        
        await router.push('/login');
      } catch {
        $q.notify({
          type: 'negative',
          message: 'Erro ao criar conta. Verifique os dados e tente novamente.'
        });
      } finally {
        loading.value = false;
      }
    };

    return {
      name,
      email,
      password,
      confirmPassword,
      loading,
      handleRegistration
    };
  }
});
</script>

<style scoped>
.q-card {
  border-radius: 8px;
}

.q-img {
  border-radius: 8px;
}

a {
  text-decoration: none;
}
</style>
