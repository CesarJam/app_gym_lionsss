<template>
  <!-- Contenedor principal: Ocupa toda la pantalla, evita scroll innecesario y aplica fondo principal -->
  <div
    class="flex h-screen bg-[#222222] text-[#FAFAFA] overflow-hidden font-montserrat"
  >
    <!-- BARRA SUPERIOR MÓVIL (Solo visible en pantallas pequeñas) -->
    <div
      class="md:hidden fixed top-0 left-0 w-full bg-[#171717] border-b border-[#3B3B3B] z-40 flex justify-between items-center p-4 shadow-md"
    >
      <div class="flex items-center gap-3">
        <img
          src="/images/logo.png"
          class="h-10 w-auto object-contain"
          alt="Logo Lionsss"
        />
        <h2
          class="text-[#D4D4D4] font-black tracking-widest text-lg m-0 uppercase leading-tight"
        >
          Lionsss <br /><span class="text-[#888888] text-xs">Academy</span>
        </h2>
      </div>
      <button @click="toggleMenu" class="text-[#D4D4D4] focus:outline-none">
        <!-- Icono de Hamburguesa SVG -->
        <svg
          v-if="!menuAbierto"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="2"
          stroke="currentColor"
          class="w-8 h-8"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
          />
        </svg>
        <!-- Icono de X (Cerrar) SVG -->
        <svg
          v-else
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="2"
          stroke="currentColor"
          class="w-8 h-8"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M6 18L18 6M6 6l12 12"
          />
        </svg>
      </button>
    </div>

    <!-- OVERLAY OSCURO PARA MÓVILES (Fondo semitransparente cuando el menú está abierto) -->
    <div
      v-if="menuAbierto"
      @click="menuAbierto = false"
      class="fixed inset-0 bg-black/60 z-40 md:hidden transition-opacity"
    ></div>

    <!-- SIDEBAR (Barra Lateral) -->
    <nav
      :class="[
        menuAbierto ? 'translate-x-0' : '-translate-x-full',
        'md:translate-x-0',
      ]"
      class="fixed md:static inset-y-0 left-0 w-64 bg-[#3B3B3B] border-r border-[#3B3B3B] flex flex-col z-50 transition-transform duration-300 ease-in-out shadow-2xl md:shadow-none"
    >
      <!-- Cabecera del Sidebar (Solo visible en escritorio, en móvil está en la barra superior) -->
      <div class="hidden md:block p-6 text-center border-b border-[#3B3B3B]">
        <img
          src="/images/logo.png"
          class="w-20 h-20 mx-auto mb-3 object-contain"
          alt="Logo Lionsss"
        />
        <h2
          class="text-[#D4D4D4] font-black tracking-widest text-xl m-0 uppercase"
        >
          Lionsss
        </h2>
        <h2
          class="text-[#D4D4D4] font-black tracking-widest text-xl m-0 uppercase"
        >
          Academy
        </h2>
        <p
          class="text-xs text-[#888888] mt-2 tracking-widest uppercase font-bold"
        >
          Dashboard
        </p>
      </div>

      <!-- Enlaces de Navegación -->
      <ul class="flex-grow overflow-y-auto p-0 m-0 list-none mt-4 md:mt-0">
        <li>
          <a
            href="#"
            @click.prevent="seleccionarVista('inicio')"
            :class="[
              'block p-4 transition-all duration-300 no-underline font-bold text-sm uppercase tracking-wide',
              vistaActual === 'inicio'
                ? 'bg-[#222222] text-[#FAFAFA] border-l-4 border-[#D4D4D4]'
                : 'text-[#888888] hover:bg-[#222222]/50 hover:text-[#D4D4D4] hover:border-l-4 hover:border-[#555555]',
            ]"
          >
            Panel Principal
          </a>
        </li>

        <li v-if="rolUsuario === 'superadmin'">
          <a
            href="#"
            @click.prevent="seleccionarVista('entrenadores')"
            :class="[
              'block p-4 transition-all duration-300 no-underline font-bold text-sm uppercase tracking-wide',
              vistaActual === 'entrenadores'
                ? 'bg-[#222222] text-[#FAFAFA] border-l-4 border-[#D4D4D4]'
                : 'text-[#888888] hover:bg-[#222222]/50 hover:text-[#D4D4D4] hover:border-l-4 hover:border-[#555555]',
            ]"
          >
            Entrenadores
          </a>
        </li>

        <li v-if="rolUsuario === 'entrenador'">
          <a
            href="#"
            @click.prevent="seleccionarVista('asesorados')"
            :class="[
              'block p-4 transition-all duration-300 no-underline font-bold text-sm uppercase tracking-wide',
              vistaActual === 'asesorados'
                ? 'bg-[#222222] text-[#FAFAFA] border-l-4 border-[#D4D4D4]'
                : 'text-[#888888] hover:bg-[#222222]/50 hover:text-[#D4D4D4] hover:border-l-4 hover:border-[#555555]',
            ]"
          >
            Mis Asesorados
          </a>
        </li>

        <li v-if="rolUsuario === 'asesorado'">
          <a
            href="#"
            @click.prevent="seleccionarVista('mi-perfil')"
            :class="[
              'block p-4 transition-all duration-300 no-underline font-bold text-sm uppercase tracking-wide',
              vistaActual === 'mi-perfil'
                ? 'bg-[#222222] text-[#FAFAFA] border-l-4 border-[#D4D4D4]'
                : 'text-[#888888] hover:bg-[#222222]/50 hover:text-[#D4D4D4] hover:border-l-4 hover:border-[#555555]',
            ]"
          >
            Mi Perfil
          </a>
        </li>
      </ul>

      <!-- Botón de Cerrar Sesión -->
      <div class="p-5 border-t border-[#3B3B3B]">
        <button
          @click="cerrarSesion"
          class="w-full py-3 px-4 bg-transparent border-2 border-red-900/50 text-red-500 font-bold uppercase tracking-wide text-sm rounded-lg transition-all duration-300 hover:bg-red-500 hover:text-white hover:border-red-500"
        >
          Cerrar Sesión
        </button>
      </div>
    </nav>

    <!-- ÁREA PRINCIPAL DE CONTENIDO -->
    <!-- pt-24 asegura que el contenido no quede oculto detrás de la barra superior en móviles -->
    <main class="flex-1 overflow-y-auto p-4 pt-24 md:p-8 md:pt-8 scroll-smooth">
      <div v-if="vistaActual === 'inicio'" class="max-w-5xl mx-auto">
        <header class="mb-8">
          <h1
            class="flex flex-wrap items-center gap-3 text-2xl sm:text-3xl md:text-4xl font-black uppercase tracking-tight mt-0 mb-3 text-[#FAFAFA]"
          >
            <span
              >Bienvenido,
              <span class="text-[#D4D4D4]">{{ nombreUsuario }}</span></span
            >

            <img
              src="/images/brave-svgrepo-com.svg"
              alt="Logo León"
              class="w-10 h-10 sm:w-12 sm:h-12 flex-shrink-0 drop-shadow-md transition-transform hover:scale-150"
            />
          </h1>
          <span
            class="bg-[#D4D4D4] text-[#222222] px-4 py-1.5 rounded-full text-xs font-black uppercase tracking-widest shadow-[0_0_10px_rgba(212,212,212,0.2)]"
          >
            {{ rolUsuario }}
          </span>
        </header>

        <!-- Tarjetas de Estadísticas Responsivas -->
        <section class="grid grid-cols-1 sm:grid-cols-2 gap-4 md:gap-6">
          <div
            v-if="rolUsuario === 'superadmin'"
            class="bg-[#3B3B3B] p-6 md:p-8 rounded-xl text-center shadow-lg border border-[#3B3B3B] transition-transform duration-300 hover:-translate-y-1"
          >
            <h3
              class="text-xs md:text-sm font-bold text-[#888888] uppercase tracking-widest mb-3"
            >
              Entrenadores
            </h3>
            <p
              class="text-5xl md:text-6xl font-black text-[#D4D4D4] m-0 drop-shadow-md"
            >
              {{ totalEntrenadores }}
            </p>
          </div>

          <div
            class="bg-[#3B3B3B] p-6 md:p-8 rounded-xl text-center shadow-lg border border-[#3B3B3B] transition-transform duration-300 hover:-translate-y-1"
          >
            <h3
              class="text-xs md:text-sm font-bold text-[#888888] uppercase tracking-widest mb-3"
            >
              {{
                rolUsuario === "superadmin" ? "Total Atletas" : "Mis Asesorados"
              }}
            </h3>
            <p
              class="text-5xl md:text-6xl font-black text-[#D4D4D4] m-0 drop-shadow-md"
            >
              {{ totalAsesorados }}
            </p>
          </div>
        </section>
      </div>

      <!-- Vistas Condicionales de Componentes -->
      <div
        v-else-if="
          vistaActual === 'entrenadores' && rolUsuario === 'superadmin'
        "
        class="max-w-7xl mx-auto"
      >
        <Entrenadores />
      </div>

      <div
        v-else-if="vistaActual === 'asesorados' && rolUsuario === 'entrenador'"
        class="max-w-7xl mx-auto"
      >
        <MisAsesorados />
      </div>

      <div
        v-else-if="vistaActual === 'mi-perfil' && rolUsuario === 'asesorado'"
        class="max-w-7xl mx-auto"
      >
        <ExpedienteAsesorado
          :idAsesorado="miIdAsesorado"
          @volver="seleccionarVista('inicio')"
        />
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

// Lógica de UI para móvil
const menuAbierto = ref(false);

const toggleMenu = () => {
  menuAbierto.value = !menuAbierto.value;
};

// Función para cambiar la vista y cerrar el menú móvil simultáneamente
const seleccionarVista = (vista) => {
  vistaActual.value = vista;
  menuAbierto.value = false;
};

onMounted(async () => {
  await obtenerPerfil();
});

const obtenerPerfil = async () => {
  try {
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();
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

      if (rolUsuario.value === "asesorado") {
        const { data: asesoradoData } = await supabase
          .from("asesorados")
          .select("id")
          .eq("id_auth", user.id)
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
    if (rolUsuario.value === "superadmin") {
      const { count: countEntrenadores } = await supabase
        .from("perfiles")
        .select("*", { count: "exact", head: true })
        .eq("rol", "entrenador");
      totalEntrenadores.value = countEntrenadores || 0;

      const { count: countAtletas } = await supabase
        .from("asesorados")
        .select("*", { count: "exact", head: true });
      totalAsesorados.value = countAtletas || 0;
    } else if (rolUsuario.value === "entrenador") {
      const { count: countMisAsesorados } = await supabase
        .from("asesorados")
        .select("*", { count: "exact", head: true })
        .eq("id_entrenador", miId);
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

<style scoped>
/* Aseguramos que la tipografía aplique a todo el dashboard[cite: 2] */
@import url("https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700;900&display=swap");

.font-montserrat {
  font-family: "Montserrat", sans-serif;
}
</style>
