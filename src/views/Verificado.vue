<template>
  <div class="min-h-screen bg-[#121212] flex items-center justify-center p-4">
    <div class="max-w-md w-full bg-[#1e1e1e] p-8 rounded-xl text-center shadow-[0_4px_20px_rgba(0,0,0,0.5)] border-t-4 border-[#f39c12]">
      <h2 class="text-6xl mb-6">✅</h2>
      <h2 class="text-2xl font-bold mb-4 text-white uppercase tracking-wider">¡Cuenta Verificada!</h2>
      <p class="text-[#ccc] mb-8 text-sm">
        Tu correo electrónico ha sido confirmado exitosamente. Tu expediente está activo y tu perfil está listo para usarse.
      </p>

      <router-link
        to="/admin/login"
        class="inline-block w-full bg-[#f39c12] hover:bg-[#e67e22] text-[#121212] font-bold py-3 px-4 rounded-md transition duration-300 uppercase"
      >
        Ir a Iniciar Sesión
      </router-link>
    </div>
  </div>
</template>

<script setup>
// Al aterrizar en esta vista, Supabase ya procesó el token en segundo plano 
// gracias a que la URL contiene los parámetros de verificación.
</script>