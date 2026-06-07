<template>
  <div>
    <div v-if="!asesoradoSeleccionadoId">
      <header class="flex justify-between items-center mb-6">
        <div>
          <h2 class="text-2xl font-light m-0 text-white">Mis Asesorados</h2>
          <p class="text-neutral-400 text-sm mt-1">Genera enlaces y administra los expedientes de tus clientes</p>
        </div>
        <button 
          class="bg-orange-500 hover:bg-orange-600 text-neutral-900 font-bold py-2 px-4 rounded transition duration-300" 
          @click="mostrarFormulario = !mostrarFormulario"
        >
          {{ mostrarFormulario ? 'Cancelar' : '+ Nuevo Asesorado' }}
        </button>
      </header>

      <div v-if="mostrarFormulario" class="bg-neutral-800 p-6 rounded-lg mb-8 border-l-4 border-orange-500 shadow-md">
        <h3 class="mt-0 mb-4 text-orange-500 font-semibold text-lg">Alta Rápida</h3>
        <p class="text-sm text-neutral-400 mb-4">Solo necesitas su nombre. El sistema generará un enlace para que el cliente llene el resto de su información.</p>
        
        <form @submit.prevent="guardarAsesorado" class="flex gap-4 items-end">
          <div class="flex flex-col flex-grow">
            <label class="text-sm text-neutral-400 mb-1">Nombre Completo del Cliente</label>
            <input type="text" v-model="nuevoNombre" placeholder="Ej. María Sánchez" required 
                   class="w-full p-2.5 bg-neutral-900 border border-neutral-700 rounded text-white focus:outline-none focus:border-orange-500" />
          </div>
          <div>
            <button type="submit" :disabled="cargando" 
                    class="bg-green-500 hover:bg-green-600 text-neutral-900 font-bold py-2.5 px-6 rounded transition duration-300 disabled:bg-neutral-600 disabled:cursor-not-allowed">
              {{ cargando ? 'Generando...' : 'Generar Enlace' }}
            </button>
          </div>
        </form>
      </div>
<div class="bg-neutral-800 rounded-lg shadow-md">
        <table class="w-full text-left border-collapse">
          <thead>
            <tr>
              <th class="bg-neutral-900 text-neutral-400 font-normal p-4 border-b border-neutral-700 first:rounded-tl-lg">Nombre</th>
              <th class="bg-neutral-900 text-neutral-400 font-normal p-4 border-b border-neutral-700">Estado</th>
              <th class="bg-neutral-900 text-neutral-400 font-normal p-4 border-b border-neutral-700">Enlace de Registro</th>
              <th class="bg-neutral-900 text-neutral-400 font-normal p-4 border-b border-neutral-700 text-center last:rounded-tr-lg">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="asesorados.length === 0">
              <td colspan="4" class="p-8 text-center text-neutral-500">No tienes asesorados registrados aún.</td>
            </tr>
            <tr v-for="cliente in asesorados" :key="cliente.id" class="hover:bg-neutral-750 transition duration-150">
              <td class="p-4 border-b border-neutral-700 text-white font-medium">
                {{ cliente.nombre_completo }}
              </td>
              <td class="p-4 border-b border-neutral-700">
                <span :class="[
                  'px-2 py-1 rounded text-xs uppercase font-bold tracking-wide',
                  cliente.estado_registro === 'completado' ? 'bg-green-900 text-green-300' : 'bg-yellow-900 text-yellow-300'
                ]">
                  {{ cliente.estado_registro }}
                </span>
              </td>
              <td class="p-4 border-b border-neutral-700">
                <button 
                  v-if="cliente.estado_registro === 'pendiente'"
                  @click="copiarEnlace(cliente.token_registro)"
                  class="flex items-center gap-2 text-sm bg-neutral-900 hover:bg-neutral-700 text-orange-400 border border-neutral-600 py-1.5 px-3 rounded transition"
                >
                <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.666 3.888A2.25 2.25 0 0013.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 01-.75.75H9a.75.75 0 01-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 01-2.25 2.25H6.75A2.25 2.25 0 014.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 011.927-.184" />
                  </svg>
                  <span>Copiar Enlace</span>
                </button>
                <span v-else class="text-sm text-neutral-500 italic flex items-center gap-2">
                  <!-- Icono Heroicons: Check Circle (Opcional, para cuando ya lo llenó) -->
                  <svg class="w-4 h-4 text-green-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  Formulario llenado
                </span>
              </td>
              
              <td class="p-4 border-b border-neutral-700 text-center relative">
                
                <div v-if="menuAbierto === cliente.id" @click="cerrarMenu" class="fixed inset-0 z-10 cursor-default"></div>

                <button 
                  @click="toggleMenu(cliente.id)" 
                  class="text-neutral-400 hover:text-white transition px-2 py-1 relative z-20 rounded hover:bg-neutral-700"
                >
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"></path>
                  </svg>
                </button>

                <div 
                  v-if="menuAbierto === cliente.id" 
                  class="absolute right-10 top-10 w-48 bg-neutral-800 border border-neutral-700 rounded-md shadow-xl z-30 py-2 text-left overflow-hidden"
                >
                  <button 
                    v-if="cliente.estado_registro === 'completado'"
                    @click="abrirExpediente(cliente.id)"
                    class="w-full text-left px-4 py-2 text-sm text-neutral-300 hover:bg-neutral-700 hover:text-white transition flex items-center gap-3"
                  >
                    <svg class="w-5 h-5 text-neutral-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z" />
                    </svg> Ver Expediente
                  </button>
                  
                  <hr v-if="cliente.estado_registro === 'completado'" class="border-neutral-700 my-1">
                  
                  <button 
                    @click="eliminarAsesorado(cliente.id)"
                    class="w-full text-left px-4 py-2 text-sm text-red-400 hover:bg-neutral-700 hover:text-red-300 transition flex items-center gap-3"
                  >
                    <svg class="w-5 h-5 text-red-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
                    </svg> Eliminar Asesorado
                  </button>
                </div>

              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div v-else>
      <ExpedienteAsesorado 
        :idAsesorado="asesoradoSeleccionadoId" 
        @volver="asesoradoSeleccionadoId = null" 
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../supabase.js'
import Swal from 'sweetalert2'
import ExpedienteAsesorado from './ExpedienteAsesorado.vue'

const mostrarFormulario = ref(false)
const cargando = ref(false)
const asesorados = ref([])
const nuevoNombre = ref('')
const miEntrenadorId = ref(null)

const asesoradoSeleccionadoId = ref(null) 

// 👈 Nueva variable para controlar qué menú está abierto
const menuAbierto = ref(null)

onMounted(async () => {
  await obtenerMiId()
  await cargarAsesorados()
})

const obtenerMiId = async () => {
  const { data: { user } } = await supabase.auth.getUser()
  if (user) {
    miEntrenadorId.value = user.id
  }
}

const cargarAsesorados = async () => {
  if (!miEntrenadorId.value) return
  try {
    const { data, error } = await supabase
      .from('asesorados')
      .select('*')
      .eq('id_entrenador', miEntrenadorId.value)
      .order('fecha_creacion', { ascending: false })

    if (error) throw error
    asesorados.value = data
  } catch (error) {
    console.error('Error al cargar:', error.message)
  }
}

const guardarAsesorado = async () => {
  if (!nuevoNombre.value.trim()) return
  try {
    cargando.value = true
    const { error } = await supabase
      .from('asesorados')
      .insert([{ nombre_completo: nuevoNombre.value, id_entrenador: miEntrenadorId.value }])

    if (error) throw error

    Swal.fire({
      title: '¡Generado!', text: 'El registro se creó con éxito. Ya puedes copiar su enlace.', icon: 'success', background: '#1e1e1e', color: '#fff', confirmButtonColor: '#f39c12', timer: 2000, showConfirmButton: false
    })

    nuevoNombre.value = ''
    mostrarFormulario.value = false
    await cargarAsesorados()
  } catch (error) {
    Swal.fire('Error', error.message, 'error')
  } finally {
    cargando.value = false
  }
}

const copiarEnlace = (token) => {
  const urlBase = window.location.origin
  const enlaceMagico = `${urlBase}/registro/${token}`

  navigator.clipboard.writeText(enlaceMagico).then(() => {
    Swal.fire({ toast: true, position: 'top-end', icon: 'success', title: '¡Enlace copiado!', showConfirmButton: false, timer: 2500, background: '#1e1e1e', color: '#fff' })
  })
}

// 👈 Funciones para controlar el menú de los 3 puntos
const toggleMenu = (id) => {
  if (menuAbierto.value === id) {
    menuAbierto.value = null // Si ya estaba abierto, lo cierra
  } else {
    menuAbierto.value = id // Abre el del cliente seleccionado
  }
}

const cerrarMenu = () => {
  menuAbierto.value = null
}

const abrirExpediente = (id) => {
  cerrarMenu() // Cerramos el menú antes de cambiar de pantalla
  asesoradoSeleccionadoId.value = id
}

const eliminarAsesorado = async (id) => {
  cerrarMenu() // Cerramos el menú antes de abrir la alerta
  const result = await Swal.fire({
    title: '¿Estás seguro?', text: "Se borrará este registro por completo.", icon: 'warning', showCancelButton: true, background: '#1e1e1e', color: '#fff', confirmButtonColor: '#d33', cancelButtonColor: '#3085d6', confirmButtonText: 'Sí, borrar', cancelButtonText: 'Cancelar'
  })

  if (result.isConfirmed) {
    const { error } = await supabase.from('asesorados').delete().eq('id', id)
    if (!error) await cargarAsesorados()
  }
}
</script>