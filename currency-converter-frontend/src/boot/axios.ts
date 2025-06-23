import { defineBoot } from '#q-app/wrappers';
import { type AxiosInstance } from 'axios';
import createAxiosInstance from 'src/helpers/axios_instance'

declare module 'vue' {
  interface ComponentCustomProperties {
    $web: AxiosInstance;
    $api: AxiosInstance;
  }
}

// Be careful when using SSR for cross-request state pollution
// due to creating a Singleton instance here;
// If any client changes this (global) instance, it might be a
// good idea to move this instance creation inside of the
// "export default () => {}" function below (which runs individually
// for each client)
const api = createAxiosInstance('http://localhost:3000/api/')
const web = createAxiosInstance('http://localhost:3000')

export default defineBoot(({ app }) => {
  // for use inside Vue files (Options API) through this.$axios and this.$api

  app.config.globalProperties.$web = web
  // ^ ^ ^ this will allow you to use this.$axios (for Vue Options API form)
  //       so you won't necessarily have to import axios in each vue file

  app.config.globalProperties.$api = api;
  // ^ ^ ^ this will allow you to use this.$api (for Vue Options API form)
  //       so you can easily perform requests against your app's API
});

export { api };
