import { createRouter, createWebHistory, NavigationGuardNext, RouteLocationNormalized } from 'vue-router';
import NotFound from '../views/NotFound.vue';
import PostsList from '../views/PostsList.vue';
import PostDetails from '../views/PostDetails.vue';

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
    path: '/post/:id',
    name: 'post',
    component: PostDetails,
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
