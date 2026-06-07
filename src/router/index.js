import { createRouter, createWebHistory } from 'vue-router'
import { supabase } from '../supabase.js'
import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import RegistroAsesorado from '../views/RegistroAsesorado.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/admin/login',
      name: 'login',
      component: Login
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: () => import('../views/Dashboard.vue'),
      meta: { requiresAuth: true } 
    },
    { path: '/registro/:token', 
      name: 'registro', 
      component: RegistroAsesorado }
  ]
})

router.beforeEach(async (to, from, next) => {
  const { data: { session } } = await supabase.auth.getSession()

  if (to.meta.requiresAuth && !session) {
    next('/admin/login')
  } 
  else if (to.path === '/admin/login' && session) {
    next('/dashboard')
  } 
  else {
    next()
  }
})

export default router