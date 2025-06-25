<template>
  <q-layout view="hHh lpR fFf">
    <q-page-container>
    <q-page class="flex flex-center bg-blue-grey-1">
      <q-card class="q-pa-md shadow-2" style="width: 100%; max-width: 400px;">
        <q-card-section>
          <div class="text-h5 text-center text-weight-bold q-mb-md">
            Welcome to Currency Converter
          </div>
          <q-img src="https://cdn.quasar.dev/img/mountains.jpg" spinner-color="primary" style="height: 150px;"
            class="q-mb-md" />
        </q-card-section>

        <q-card-section>
          <q-form @submit.prevent="onSubmit" class="q-gutter-md">
            <q-input v-model="email" label="Email" type="email" outlined
              :rules="[val => !!val || 'Email is required']" />

            <q-input v-model="password" label="Password" type="password" outlined
              :rules="[val => !!val || 'Password is required']" />

            <div class="text-center">
              <q-btn label="Login" type="submit" color="primary" class="full-width" size="lg" />
            </div>
          </q-form>
        </q-card-section>

        <q-card-section class="text-center q-pt-none">
          <div class="text-caption">
            Don't have an account? <router-link to="/register" class="text-primary">Sign up</router-link>
          </div>
        </q-card-section>
      </q-card>
      
    </q-page>
  </q-page-container>
  </q-layout>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { login } from 'src/services/authenticate_service';
import { useQuasar } from 'quasar';
import { useRouter } from 'vue-router';

const $q = useQuasar();
const router = useRouter();

const email = ref('hz6ys@example.com');
const password = ref('password');

const onSubmit = async () => {
  try {
    await login(email.value, password.value);
    $q.notify({
      type: 'positive',
      message: 'Login successful!'
    });
    await router.push('/home');
  } catch (error) {
    $q.notify({
      type: 'negative',
      message: error instanceof Error ? error.message : 'Erro ao realizar login'
    });
  }
};
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
