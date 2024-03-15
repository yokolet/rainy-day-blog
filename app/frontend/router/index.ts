import { createRouter, createWebHistory, NavigationGuardNext, RouteLocationNormalized } from 'vue-router';
import NotFound from '../views/NotFound.vue';
import PostsList from '../views/PostsList.vue';

const routes = [
  {
    path: '/',
    redirect: '/posts',
  },
  {
    path: '/posts',
    name: 'posts',
    component: PostsList,
  },
  {
    path: '/:catchAll(.*)',
    name: 'not-found',
    component: NotFound
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
