<template>
  <div class="login-container">
    <div class="login-box">
      <img
        src="/images/logo.png"
        alt="Lionsss Logo"
        class="logo"
        v-if="false"
      />
      <h2>ACCESO AL SISTEMA</h2>
      <p class="subtitle">Lionsss Academy</p>

      <form @submit.prevent="iniciarSesion">
        <div class="input-group">
          <label>Correo Electrónico</label>
          <input
            type="email"
            v-model="email"
            placeholder="admin@lionsss.com"
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
          <span v-if="esErrorConfirmacion">⚠️ </span>
          <span v-else>❌ </span>
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
  background-color: #121212; /* Fondo oscuro */
  color: white;
}

.login-box {
  background-color: #1e1e1e;
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
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
  color: #888;
  margin-bottom: 30px;
}

.input-group {
  margin-bottom: 20px;
  text-align: left;
}

label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #ccc;
}

input {
  width: 100%;
  padding: 12px;
  background-color: #2a2a2a;
  border: 1px solid #333;
  border-radius: 6px;
  color: white;
  font-size: 16px;
}

input:focus {
  outline: none;
  border-color: #f39c12; /* Color dorado/naranja del gym */
}

.btn-ingresar {
  width: 100%;
  padding: 12px;
  background-color: #f39c12;
  color: #121212;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: 0.3s;
  margin-top: 10px;
}

.btn-ingresar:hover {
  background-color: #e67e22;
}

.btn-ingresar:disabled {
  background-color: #555;
  cursor: not-allowed;
}

.error-msg {
  color: #e74c3c;
  font-size: 14px;
  margin-bottom: 15px;
}
</style>
