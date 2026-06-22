<template>
  <div class="login-container">
    <div class="login-box">
      
      <!-- Botón para regresar al Home -->
      <div class="text-left mb-6">
        <router-link to="/" class="inline-flex items-center gap-2 text-[#888888] hover:text-[#D4D4D4] transition-colors text-xs uppercase font-bold tracking-wide">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
          </svg>
          Volver al inicio
        </router-link>
      </div>

     
      
      <h2>ACCESO AL SISTEMA</h2>
      <br>
       <img
        src="/images/logo.png"
        alt="Lionsss Logo"
        class="logo"
      />
      <br>

      <form @submit.prevent="iniciarSesion">
        <div class="input-group">
          <label>Correo Electrónico</label>
          <input
            type="email"
            v-model="email"
            placeholder="lionsss@lionsss.com"
            required
          />
        </div>

        <div class="input-group">
          <label>Contraseña</label>
          <input
            type="password"
            v-model="password"
            placeholder="••••••••"
            required
          />
        </div>

        <!-- Mensaje de Error Dinámico -->
        <div
          v-if="mensajeError"
          :class="esErrorConfirmacion ? 'text-yellow-500' : 'text-red-500'"
          class="text-sm text-center font-semibold mb-4 px-4"
        >
          <span
            v-if="esErrorConfirmacion"
            class="inline-flex items-center text-amber-500"
            title="Advertencia"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="w-5 h-5"
            >
              <path
                fill-rule="evenodd"
                d="M9.401 3.003c1.155-2 4.043-2 5.197 0l7.355 12.748c1.154 2-.29 4.5-2.599 4.5H4.645c-2.309 0-3.752-2.5-2.598-4.5L9.4 3.003ZM12 8.25a.75.75 0 0 1 .75.75v3.75a.75.75 0 0 1-1.5 0V9a.75.75 0 0 1 .75-.75Zm0 8.25a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Z"
                clip-rule="evenodd"
              />
            </svg>
          </span>
          <span
            v-else
            class="inline-flex items-center text-red-500"
            title="Error"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="w-5 h-5"
            >
              <path
                fill-rule="evenodd"
                d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25Zm-1.72 6.97a.75.75 0 1 0-1.06 1.06L10.94 12l-1.72 1.72a.75.75 0 1 0 1.06 1.06L12 13.06l1.72 1.72a.75.75 0 1 0 1.06-1.06L13.06 12l1.72-1.72a.75.75 0 1 0-1.06-1.06L12 10.94l-1.72-1.72Z"
                clip-rule="evenodd"
              />
            </svg>
          </span>
          {{ mensajeError }}
        </div>

        <button type="submit" class="btn-ingresar" :disabled="cargando">
          {{ cargando ? "Verificando..." : "INGRESAR" }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { supabase } from "../supabase.js";

const email = ref("");
const password = ref("");
const mensajeError = ref("");
const esErrorConfirmacion = ref(false);
const cargando = ref(false);
const router = useRouter();

const iniciarSesion = async () => {
  try {
    cargando.value = true;
    mensajeError.value = null;
    esErrorConfirmacion.value = false;

    const { data, error } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    });

    if (error) {
      if (error.message.includes("Email not confirmed")) {
        esErrorConfirmacion.value = true;
        throw new Error(
          "Falta confirmación. Revisa tu correo y haz clic en el enlace para activar tu cuenta.",
        );
      } else {
        throw new Error("Credenciales incorrectas. Intenta de nuevo.");
      }
    }

    router.push("/dashboard");
  } catch (error) {
    mensajeError.value = error.message;
  } finally {
    cargando.value = false;
  }
};
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #171717; /* Ajustado para hacer match perfecto con la paleta de Tailwind del Home */
  color: white;
}

.login-box {
  background-color: #222222;
  padding: 40px;
  border-radius: 12px;
  border-top: 4px solid #D4D4D4; /* Detalle premium acorde a la marca */
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.5);
  width: 100%;
  max-width: 400px;
  text-align: center;
}

h2 {
  margin: 0;
  font-size: 24px;
  letter-spacing: 2px;
}

.subtitle {
  color: #888888;
  margin-bottom: 30px;
  text-transform: uppercase;
  font-size: 12px;
  letter-spacing: 1px;
  font-weight: bold;
}

.input-group {
  margin-bottom: 20px;
  text-align: left;
}

label {
  display: block;
  margin-bottom: 8px;
  font-size: 12px;
  color: #888888;
  text-transform: uppercase;
  font-weight: bold;
  letter-spacing: 1px;
}

input {
  width: 100%;
  padding: 12px;
  background-color: #171717;
  border: 1px solid #3B3B3B;
  border-radius: 6px;
  color: white;
  font-size: 16px;
  transition: all 0.3s ease;
}

input:focus {
  outline: none;
  border-color: #D4D4D4; 
  box-shadow: 0 0 0 1px #D4D4D4;
}

.btn-ingresar {
  width: 100%;
  padding: 14px;
  background-color: #D4D4D4;
  color: #171717;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 800;
  letter-spacing: 1px;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 10px;
}

.btn-ingresar:hover {
  background-color: #FAFAFA;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(212, 212, 212, 0.2);
}

.btn-ingresar:disabled {
  background-color: #3B3B3B;
  color: #888888;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.logo {
  width: 230px; 
  height: auto;
  margin: 0 auto 15px auto; 
  display: block;
  transition: transform 0.3s ease; /* Transición suave en CSS puro */
}

.logo:hover {
  transform: scale(1.05); /* Efecto de crecimiento al pasar el cursor */
}

.error-msg {
  color: #ef4444;
  font-size: 14px;
  margin-bottom: 15px;
}
</style>