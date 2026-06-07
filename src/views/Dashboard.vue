<template>
  <div class="flex min-h-screen bg-neutral-900 text-white">
    <nav class="w-64 bg-black border-r border-neutral-800 flex flex-col">
      <div class="p-5 text-center border-b border-neutral-800">
        <h2 class="text-orange-500 font-bold tracking-widest text-xl m-0">Lionsss</h2>
        <p class="text-sm text-neutral-500 mt-1">Dashboard</p>
      </div>
      
      <ul class="flex-grow p-0 m-0 list-none">
        <li>
          <a href="#" @click.prevent="vistaActual = 'inicio'" 
             :class="['block p-4 transition duration-300 no-underline', vistaActual === 'inicio' ? 'bg-neutral-800 text-orange-500 border-l-4 border-orange-500' : 'text-neutral-400 hover:bg-neutral-800 hover:text-orange-500']">
            Panel Principal
          </a>
        </li>

        <li v-if="rolUsuario === 'superadmin'">
          <a href="#" @click.prevent="vistaActual = 'entrenadores'" 
             :class="['block p-4 transition duration-300 no-underline', vistaActual === 'entrenadores' ? 'bg-neutral-800 text-orange-500 border-l-4 border-orange-500' : 'text-neutral-400 hover:bg-neutral-800 hover:text-orange-500']">
            Entrenadores
          </a>
        </li>

        <li v-if="rolUsuario === 'entrenador'">
          <a href="#" @click.prevent="vistaActual = 'asesorados'" 
             :class="['block p-4 transition duration-300 no-underline', vistaActual === 'asesorados' ? 'bg-neutral-800 text-orange-500 border-l-4 border-orange-500' : 'text-neutral-400 hover:bg-neutral-800 hover:text-orange-500']">
            Mis Asesorados
          </a>
        </li>
        <!-- En tu sección de navegación (Dashboard.vue) -->
      <li v-if="rolUsuario === 'asesorado'">
        <a href="#" @click.prevent="vistaActual = 'mi-perfil'" 
          :class="['block p-4 transition duration-300 no-underline', vistaActual === 'mi-perfil' ? 'bg-neutral-800 text-orange-500 border-l-4 border-orange-500' : 'text-neutral-400 hover:bg-neutral-800 hover:text-orange-500']">
          Mi Perfil
        </a>
      </li>
      </ul>
      

      <div class="p-5 border-t border-neutral-800">
        <button @click="cerrarSesion" class="w-full p-2.5 bg-transparent border border-red-500 text-red-500 rounded-md cursor-pointer transition duration-300 hover:bg-red-500 hover:text-white">
          Cerrar Sesión
        </button>
      </div>
    </nav>

    <main class="flex-grow p-8">
      <div v-if="vistaActual === 'inicio'">
        <header class="mb-8">
          <h1 class="text-3xl font-light mt-0 mb-4">Bienvenido, {{ nombreUsuario }} 🦁</h1>
          <span class="bg-orange-500 text-neutral-900 px-2 py-1 rounded text-xs font-bold uppercase tracking-wide">
            {{ rolUsuario }}
          </span>
        </header>
        
        <section class="grid grid-cols-1 md:grid-cols-2 gap-5">
          <div v-if="rolUsuario === 'superadmin'" class="bg-neutral-800 p-5 rounded-lg text-center shadow-md">
            <h3 class="text-sm text-neutral-400 m-0 mb-2.5">Entrenadores en el Sistema</h3>
            <!-- Cambiamos el 2 por la variable reactiva -->
            <p class="text-4xl font-bold text-orange-500 m-0">{{ totalEntrenadores }}</p>
          </div>
          <div class="bg-neutral-800 p-5 rounded-lg text-center shadow-md">
            <h3 class="text-sm text-neutral-400 m-0 mb-2.5">{{ rolUsuario === 'superadmin' ? 'Total Atletas' : 'Mis Asesorados' }}</h3>
            <!-- Cambiamos el 0 por la variable reactiva -->
            <p class="text-4xl font-bold text-orange-500 m-0">{{ totalAsesorados }}</p>
          </div>
        </section>
      </div>

      <div v-else-if="vistaActual === 'entrenadores' && rolUsuario === 'superadmin'">
        <Entrenadores />
      </div>

      <div v-else-if="vistaActual === 'asesorados' && rolUsuario === 'entrenador'">
        <MisAsesorados />
      </div>

      <div v-else-if="vistaActual === 'mi-perfil' && rolUsuario === 'asesorado'">
        <ExpedienteAsesorado :idAsesorado="miIdAsesorado" @volver="vistaActual = 'inicio'" />
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { supabase } from "../supabase.js";
import Entrenadores from "../components/Entrenadores.vue";
import MisAsesorados from "../components/MisAsesorados.vue"; 
import ExpedienteAsesorado from "../components/ExpedienteAsesorado.vue";

const router = useRouter();
const nombreUsuario = ref("Cargando...");
const rolUsuario = ref("");
const vistaActual = ref("inicio");

const totalEntrenadores = ref(0);
const totalAsesorados = ref(0);
const miIdAsesorado = ref(null);

onMounted(async () => {
  await obtenerPerfil();
});

const obtenerPerfil = async () => {
  try {
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError) throw authError;

    if (user) {
      const { data, error } = await supabase
        .from("perfiles")
        .select("nombre_completo, rol")
        .eq("id", user.id)
        .single();

      if (error) throw error;

      nombreUsuario.value = data.nombre_completo;
      rolUsuario.value = data.rol;

      // Lógica nueva: Si es asesorado, buscamos su ID en la tabla asesorados
      if (rolUsuario.value === 'asesorado') {
        const { data: asesoradoData } = await supabase
          .from("asesorados")
          .select("id")
          .eq("id_auth", user.id) // Usamos id_auth que vincula al usuario
          .single();
        
        if (asesoradoData) {
          miIdAsesorado.value = asesoradoData.id;
        }
      }

      await obtenerEstadisticas(user.id);
    }
  } catch (error) {
    console.error("Error al obtener el perfil:", error.message);
    nombreUsuario.value = "Usuario";
  }
};

const obtenerEstadisticas = async (miId) => {
  try {
    if (rolUsuario.value === 'superadmin') {
      // Si es Superadmin, cuenta TODOS los entrenadores
      const { count: countEntrenadores } = await supabase
        .from('perfiles')
        .select('*', { count: 'exact', head: true })
        .eq('rol', 'entrenador');
      totalEntrenadores.value = countEntrenadores || 0;

      // Y cuenta TODOS los asesorados globales
      const { count: countAtletas } = await supabase
        .from('asesorados')
        .select('*', { count: 'exact', head: true });
      totalAsesorados.value = countAtletas || 0;

    } else if (rolUsuario.value === 'entrenador') {
      // Si es Entrenador, cuenta SOLO los asesorados que le pertenecen
      const { count: countMisAsesorados } = await supabase
        .from('asesorados')
        .select('*', { count: 'exact', head: true })
        .eq('id_entrenador', miId);
      totalAsesorados.value = countMisAsesorados || 0;
    }
  } catch (error) {
    console.error("Error al cargar estadísticas:", error.message);
  }
};

const cerrarSesion = async () => {
  try {
    await supabase.auth.signOut();
    router.push("/admin/login");
  } catch (error) {
    console.error("Error al cerrar sesión:", error.message);
  }
};
</script>