<template>
  <div class="font-montserrat">
    <!-- HEADER RESPONSIVO -->
    <header class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
      <h2 class="text-2xl md:text-3xl font-black uppercase text-[#FAFAFA] tracking-tight m-0">
        Gestión de <span class="text-[#D4D4D4]">Entrenadores</span>
      </h2>
      <button 
        class="w-full sm:w-auto px-6 py-3 rounded-full font-extrabold text-sm uppercase tracking-wide transition-all duration-300 shadow-lg"
        :class="mostrarFormulario ? 'border-2 border-[#D4D4D4] text-[#D4D4D4] hover:bg-[#D4D4D4] hover:text-[#222222]' : 'bg-[#D4D4D4] text-[#222222] hover:bg-[#FAFAFA] hover:-translate-y-1 hover:shadow-[0_0_20px_rgba(212,212,212,0.4)]'"
        @click="mostrarFormulario = !mostrarFormulario"
      >
        {{ mostrarFormulario ? 'Cancelar Registro' : '+ Nuevo Entrenador' }}
      </button>
    </header>

    <!-- FORMULARIO -->
    <div v-if="mostrarFormulario" class="bg-[#171717] p-6 rounded-xl mb-8 border border-[#3B3B3B] shadow-2xl transition-all duration-300">
      <h3 class="mt-0 mb-6 text-[#D4D4D4] font-black uppercase tracking-widest text-sm border-b border-[#3B3B3B] pb-3">
        Registrar Nuevo Entrenador
      </h3>
      
      <form @submit.prevent="guardarEntrenador" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5 items-end">
        <div class="flex flex-col">
          <label class="text-xs font-bold text-[#888888] mb-2 uppercase tracking-wide">Nombre Completo</label>
          <input type="text" v-model="nuevo.nombre" placeholder="Ej. Carlos Mendoza" required 
                 class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] placeholder-[#555555] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors" />
        </div>
        <div class="flex flex-col">
          <label class="text-xs font-bold text-[#888888] mb-2 uppercase tracking-wide">Correo Electrónico</label>
          <input type="email" v-model="nuevo.email" placeholder="entrenador@lionsss.com" required 
                 class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] placeholder-[#555555] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors" />
        </div>
        <div class="flex flex-col">
          <label class="text-xs font-bold text-[#888888] mb-2 uppercase tracking-wide">Contraseña</label>
          <input type="password" v-model="nuevo.password" placeholder="••••••••" required 
                 class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] placeholder-[#555555] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors" />
        </div>
        <div>
          <button type="submit" :disabled="cargando" 
                  class="w-full bg-[#D4D4D4] hover:bg-[#FAFAFA] text-[#222222] font-extrabold uppercase tracking-wide py-3 px-4 rounded-lg transition duration-300 disabled:opacity-50 disabled:cursor-not-allowed flex justify-center items-center gap-2">
            <svg v-if="cargando" class="animate-spin h-5 w-5 text-[#222222]" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
            {{ cargando ? 'Guardando...' : 'Guardar' }}
          </button>
        </div>
      </form>
    </div>

    <!-- LISTA (Tarjetas en Móvil, Tabla en Escritorio) -->
    <div class="bg-[#171717] rounded-xl overflow-hidden shadow-xl border border-[#3B3B3B]">
      
      <!-- Vista de Escritorio (Tabla Clásica) -->
      <div class="hidden md:block overflow-x-auto">
        <table class="w-full text-left border-collapse">
          <thead>
            <tr class="bg-[#222222]">
              <th class="text-[#888888] font-bold text-xs uppercase tracking-wider p-4 border-b border-[#3B3B3B]">Nombre</th>
              <th class="text-[#888888] font-bold text-xs uppercase tracking-wider p-4 border-b border-[#3B3B3B]">Correo</th>
              <th class="text-[#888888] font-bold text-xs uppercase tracking-wider p-4 border-b border-[#3B3B3B]">Rol</th>
              <th class="text-[#888888] font-bold text-xs uppercase tracking-wider p-4 border-b border-[#3B3B3B] text-center">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="entrenador in entrenadores" :key="entrenador.id" class="hover:bg-[#222222]/50 transition duration-150 group">
              <td class="p-4 border-b border-[#3B3B3B]">
                <div v-if="editandoId === entrenador.id">
                  <input type="text" v-model="entrenador.nombre_completo" 
                         class="w-full p-2 bg-[#222222] border border-[#D4D4D4] rounded text-[#FAFAFA] text-sm focus:outline-none" />
                </div>
                <div v-else class="font-bold text-[#EEEEEE]">
                  {{ entrenador.nombre_completo }}
                </div>
              </td>
              <td class="p-4 border-b border-[#3B3B3B] text-[#888888] text-sm italic">(Protegido por Supabase)</td>
              <td class="p-4 border-b border-[#3B3B3B]">
                <span class="bg-[#3B3B3B] text-[#D4D4D4] px-3 py-1 rounded-full text-xs uppercase font-bold tracking-wide border border-[#555555]">
                  {{ entrenador.rol }}
                </span>
              </td>
              <td class="p-4 border-b border-[#3B3B3B]">
                <div class="flex justify-center gap-3">
                  <template v-if="editandoId === entrenador.id">
                    <!-- Icono Guardar -->
                    <button title="Guardar Cambios" @click="actualizarEntrenador(entrenador)" class="text-green-500 hover:text-green-400 hover:scale-110 transition transform">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6"><path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12Zm13.36-1.814a.75.75 0 1 0-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 0 0-1.06 1.06l2.25 2.25a.75.75 0 0 0 1.14-.094l3.75-5.25Z" clip-rule="evenodd" /></svg>
                    </button>
                    <!-- Icono Cancelar -->
                    <button title="Cancelar" @click="editandoId = null" class="text-red-500 hover:text-red-400 hover:scale-110 transition transform">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6"><path fill-rule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25Zm-1.72 6.97a.75.75 0 1 0-1.06 1.06L10.94 12l-1.72 1.72a.75.75 0 1 0 1.06 1.06L12 13.06l1.72 1.72a.75.75 0 1 0 1.06-1.06L13.06 12l1.72-1.72a.75.75 0 1 0-1.06-1.06L12 10.94l-1.72-1.72Z" clip-rule="evenodd" /></svg>
                    </button>
                  </template>
                  <template v-else>
                    <!-- Icono Editar -->
                    <button title="Editar" @click="iniciarEdicion(entrenador)" class="text-[#D4D4D4] hover:text-[#FAFAFA] hover:scale-110 transition transform">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5"><path d="M21.731 2.269a2.625 2.625 0 0 0-3.712 0l-1.157 1.157 3.712 3.712 1.157-1.157a2.625 2.625 0 0 0 0-3.712ZM19.513 8.199l-3.712-3.712-8.4 8.4a5.25 5.25 0 0 0-1.32 2.214l-.8 2.685a.75.75 0 0 0 .933.933l2.685-.8a5.25 5.25 0 0 0 2.214-1.32l8.4-8.4Z" /><path d="M5.25 5.25a3 3 0 0 0-3 3v10.5a3 3 0 0 0 3 3h10.5a3 3 0 0 0 3-3V13.5a.75.75 0 0 0-1.5 0v5.25a1.5 1.5 0 0 1-1.5 1.5H5.25a1.5 1.5 0 0 1-1.5-1.5V8.25a1.5 1.5 0 0 1 1.5-1.5h5.25a.75.75 0 0 0 0-1.5H5.25Z" /></svg>
                    </button>
                    <!-- Icono Eliminar -->
                    <button title="Eliminar" @click="eliminarEntrenador(entrenador.id)" class="text-red-900 hover:text-red-500 hover:scale-110 transition transform">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5"><path fill-rule="evenodd" d="M16.5 4.478v.227a48.816 48.816 0 0 1 3.878.512.75.75 0 1 1-.256 1.478l-.209-.035-1.005 13.07a3 3 0 0 1-2.991 2.77H8.084a3 3 0 0 1-2.991-2.77L4.087 6.66l-.209.035a.75.75 0 0 1-.256-1.478A48.567 48.567 0 0 1 7.5 4.705v-.227c0-1.564 1.213-2.9 2.816-2.951a52.662 52.662 0 0 1 3.369 0c1.603.051 2.815 1.387 2.815 2.951Zm-6.136-1.452a51.196 51.196 0 0 1 3.273 0C14.39 3.05 15 3.684 15 4.478v.113a49.488 49.488 0 0 0-6 0v-.113c0-.794.609-1.428 1.364-1.452Zm-.355 5.945a.75.75 0 1 0-1.5.058l.347 9a.75.75 0 1 0 1.499-.058l-.346-9Zm5.48.058a.75.75 0 1 0-1.498-.058l-.347 9a.75.75 0 0 0 1.5.058l.345-9Z" clip-rule="evenodd" /></svg>
                    </button>
                  </template>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Vista Móvil (Tarjetas Apiladas) -->
      <div class="md:hidden flex flex-col divide-y divide-[#3B3B3B]">
        <div v-for="entrenador in entrenadores" :key="'mob-' + entrenador.id" class="p-4 flex flex-col gap-3">
          
          <div class="flex justify-between items-start">
            <div class="w-full">
              <div v-if="editandoId === entrenador.id" class="mb-2">
                <input type="text" v-model="entrenador.nombre_completo" 
                       class="w-full p-2 bg-[#222222] border border-[#D4D4D4] rounded text-[#FAFAFA] text-sm focus:outline-none" />
              </div>
              <h4 v-else class="text-lg font-bold text-[#EEEEEE] m-0">{{ entrenador.nombre_completo }}</h4>
              
              <p class="text-xs text-[#888888] mt-1 italic">Correo protegido por Supabase</p>
            </div>
          </div>

          <div class="flex justify-between items-center mt-2">
            <span class="bg-[#3B3B3B] text-[#D4D4D4] px-3 py-1 rounded-full text-[10px] uppercase font-bold tracking-wide border border-[#555555]">
              {{ entrenador.rol }}
            </span>

            <div class="flex gap-4">
              <template v-if="editandoId === entrenador.id">
                <button @click="actualizarEntrenador(entrenador)" class="text-green-500 p-2 bg-[#222222] rounded-lg border border-[#3B3B3B]">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5"><path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12Zm13.36-1.814a.75.75 0 1 0-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 0 0-1.06 1.06l2.25 2.25a.75.75 0 0 0 1.14-.094l3.75-5.25Z" clip-rule="evenodd" /></svg>
                </button>
                <button @click="editandoId = null" class="text-red-500 p-2 bg-[#222222] rounded-lg border border-[#3B3B3B]">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5"><path fill-rule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25Zm-1.72 6.97a.75.75 0 1 0-1.06 1.06L10.94 12l-1.72 1.72a.75.75 0 1 0 1.06 1.06L12 13.06l1.72 1.72a.75.75 0 1 0 1.06-1.06L13.06 12l1.72-1.72a.75.75 0 1 0-1.06-1.06L12 10.94l-1.72-1.72Z" clip-rule="evenodd" /></svg>
                </button>
              </template>
              <template v-else>
                <button @click="iniciarEdicion(entrenador)" class="text-[#D4D4D4] p-2 bg-[#222222] rounded-lg border border-[#3B3B3B]">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5"><path d="M21.731 2.269a2.625 2.625 0 0 0-3.712 0l-1.157 1.157 3.712 3.712 1.157-1.157a2.625 2.625 0 0 0 0-3.712ZM19.513 8.199l-3.712-3.712-8.4 8.4a5.25 5.25 0 0 0-1.32 2.214l-.8 2.685a.75.75 0 0 0 .933.933l2.685-.8a5.25 5.25 0 0 0 2.214-1.32l8.4-8.4Z" /><path d="M5.25 5.25a3 3 0 0 0-3 3v10.5a3 3 0 0 0 3 3h10.5a3 3 0 0 0 3-3V13.5a.75.75 0 0 0-1.5 0v5.25a1.5 1.5 0 0 1-1.5 1.5H5.25a1.5 1.5 0 0 1-1.5-1.5V8.25a1.5 1.5 0 0 1 1.5-1.5h5.25a.75.75 0 0 0 0-1.5H5.25Z" /></svg>
                </button>
                <button @click="eliminarEntrenador(entrenador.id)" class="text-red-500 p-2 bg-[#222222] rounded-lg border border-[#3B3B3B]">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5"><path fill-rule="evenodd" d="M16.5 4.478v.227a48.816 48.816 0 0 1 3.878.512.75.75 0 1 1-.256 1.478l-.209-.035-1.005 13.07a3 3 0 0 1-2.991 2.77H8.084a3 3 0 0 1-2.991-2.77L4.087 6.66l-.209.035a.75.75 0 0 1-.256-1.478A48.567 48.567 0 0 1 7.5 4.705v-.227c0-1.564 1.213-2.9 2.816-2.951a52.662 52.662 0 0 1 3.369 0c1.603.051 2.815 1.387 2.815 2.951Zm-6.136-1.452a51.196 51.196 0 0 1 3.273 0C14.39 3.05 15 3.684 15 4.478v.113a49.488 49.488 0 0 0-6 0v-.113c0-.794.609-1.428 1.364-1.452Zm-.355 5.945a.75.75 0 1 0-1.5.058l.347 9a.75.75 0 1 0 1.499-.058l-.346-9Zm5.48.058a.75.75 0 1 0-1.498-.058l-.347 9a.75.75 0 0 0 1.5.058l.345-9Z" clip-rule="evenodd" /></svg>
                </button>
              </template>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../supabase.js'
import Swal from 'sweetalert2'

const mostrarFormulario = ref(false)
const cargando = ref(false)
const entrenadores = ref([])
const editandoId = ref(null)

const nuevo = ref({
  nombre: '',
  email: '',
  password: ''
})

onMounted(async () => {
  await cargarEntrenadores()
})

const cargarEntrenadores = async () => {
  try {
    const { data, error } = await supabase
      .from('perfiles')
      .select('*')
      .eq('rol', 'entrenador')

    if (error) throw error
    entrenadores.value = data
  } catch (error) {
    console.error('Error al cargar entrenadores:', error.message)
  }
}

const guardarEntrenador = async () => {
  try {
    cargando.value = true
    
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email: nuevo.value.email,
      password: nuevo.value.password,
    })

    if (authError) throw authError

    const { error: dbError } = await supabase
      .from('perfiles')
      .insert([
        { 
          id: authData.user.id, 
          nombre_completo: nuevo.value.nombre, 
          rol: 'entrenador' 
        }
      ])

    if (dbError) throw dbError

    Swal.fire({
      title: '¡Éxito!',
      text: 'Entrenador registrado correctamente',
      icon: 'success',
      background: '#171717',
      color: '#FAFAFA',
      confirmButtonColor: '#D4D4D4',
      customClass: {
        confirmButton: 'text-[#222222] font-bold px-6 py-2 rounded-full'
      }
    })

    mostrarFormulario.value = false
    nuevo.value = { nombre: '', email: '', password: '' }
    await cargarEntrenadores()

  } catch (error) {
    Swal.fire({
      title: 'Error',
      text: error.message,
      icon: 'error',
      background: '#171717',
      color: '#FAFAFA'
    })
  } finally {
    cargando.value = false
  }
}

const iniciarEdicion = (entrenador) => {
  editandoId.value = entrenador.id
}

const actualizarEntrenador = async (entrenador) => {
  try {
    const { error } = await supabase
      .from('perfiles')
      .update({ nombre_completo: entrenador.nombre_completo })
      .eq('id', entrenador.id)

    if (error) throw error

    Swal.fire({
      title: '¡Actualizado!',
      text: 'Nombre modificado con éxito',
      icon: 'success',
      background: '#171717',
      color: '#FAFAFA',
      confirmButtonColor: '#D4D4D4',
      customClass: {
        confirmButton: 'text-[#222222] font-bold px-6 py-2 rounded-full'
      }
    })

    editandoId.value = null
    await cargarEntrenadores()
  } catch (error) {
    Swal.fire({
      title: 'Error',
      text: error.message,
      icon: 'error',
      background: '#171717',
      color: '#FAFAFA'
    })
  }
}

const eliminarEntrenador = async (id) => {
  Swal.fire({
    title: '¿Estás seguro?',
    text: "Le quitarás el acceso al sistema a este entrenador",
    icon: 'warning',
    showCancelButton: true,
    background: '#171717',
    color: '#FAFAFA',
    confirmButtonColor: '#ef4444', // red-500
    cancelButtonColor: '#3B3B3B',
    confirmButtonText: 'Sí, eliminar',
    cancelButtonText: 'Cancelar'
  }).then(async (result) => {
    if (result.isConfirmed) {
      try {
        const { error } = await supabase
          .from('perfiles')
          .update({ rol: 'suspendido' })
          .eq('id', id)

        if (error) throw error

        Swal.fire({
          title: '¡Eliminado!',
          text: 'El acceso ha sido revocado.',
          icon: 'success',
          background: '#171717',
          color: '#FAFAFA',
          confirmButtonColor: '#D4D4D4',
          customClass: {
            confirmButton: 'text-[#222222] font-bold px-6 py-2 rounded-full'
          }
        })
        
        await cargarEntrenadores()
      } catch (error) {
        Swal.fire({
          title: 'Error',
          text: error.message,
          icon: 'error',
          background: '#171717',
          color: '#FAFAFA'
        })
      }
    }
  })
}
</script>