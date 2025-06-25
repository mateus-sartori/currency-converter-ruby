import type { RouteRecordRaw } from 'vue-router';
import { validateToken, isAuthenticated } from '../helpers/authentication';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    beforeEnter: validateToken,
    children: [
      // {
      //   path: 'dashboard',
      //   component: () => import('pages/DashboardPage.vue')
      // },
      {
        path: 'home',
        component: () => import('pages/HomePage.vue')
      },
    ]
  },
  {
    path: '/login',
    component: () => import('pages/LoginPage.vue'),
    beforeEnter: isAuthenticated,
    meta: { requiresAuth: false }
  },
  {
    path: '/register',
    component: () => import('pages/RegistrationPage.vue')
  },
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
];

export default routes;
