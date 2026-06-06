import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'

// 1. Creamos la app y la guardamos en la constante 'app'
const app = createApp(App)

// 2. Le inyectamos el router
app.use(router)

// 3. Encendemos el motor y lo montamos
app.mount('#app')