import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/users/:id',
    name: 'Users',
    component: () => import('../views/HomeView.vue'),
    props: true
  },
  {
    path: '/',
    name: 'Login',
    component: () => import('../views/login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/register.vue')
  },
  {
    path:'/personajes/:id',
    name: 'Personajes',
    component: () => import('../views/personajes.vue')
  },
  {
    path:'/market/:id',
    name:'Market',
    component: () => import('../views/market.vue')
  },
  {
    path:'/arsenal/:id',
    name: 'Arsenal',
    component: () => import('../views/arsenal.vue')
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
