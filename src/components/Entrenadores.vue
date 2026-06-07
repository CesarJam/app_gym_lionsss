<template>
  <div>
    <header class="flex justify-between items-center mb-6">
      <h2 class="text-2xl font-light m-0">Gestión de Entrenadores</h2>
      <button 
        class="bg-orange-500 hover:bg-orange-600 text-neutral-900 font-bold py-2 px-4 rounded transition duration-300" 
        @click="mostrarFormulario = !mostrarFormulario"
      >
        {{ mostrarFormulario ? 'Cancelar' : '+ Nuevo Entrenador' }}
      </button>
    </header>

    <div v-if="mostrarFormulario" class="bg-neutral-800 p-6 rounded-lg mb-8 border-l-4 border-orange-500 shadow-md">
      <h3 class="mt-0 mb-4 text-orange-500 font-semibold text-lg">Registrar Nuevo Entrenador</h3>
      
      <form @submit.prevent="guardarEntrenador" class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
        <div class="flex flex-col">
          <label class="text-sm text-neutral-400 mb-1">Nombre Completo</label>
          <input type="text" v-model="nuevo.nombre" placeholder="Ej. Carlos Mendoza" required 
                 class="w-full p-2.5 bg-neutral-900 border border-neutral-700 rounded text-white focus:outline-none focus:border-orange-500" />
        </div>
        <div class="flex flex-col">
          <label class="text-sm text-neutral-400 mb-1">Correo Electrónico</label>
          <input type="email" v-model="nuevo.email" placeholder="entrenador@lionsss.com" required 
                 class="w-full p-2.5 bg-neutral-900 border border-neutral-700 rounded text-white focus:outline-none focus:border-orange-500" />
        </div>
        <div class="flex flex-col">
          <label class="text-sm text-neutral-400 mb-1">Contraseña</label>
          <input type="password" v-model="nuevo.password" placeholder="••••••••" required 
                 class="w-full p-2.5 bg-neutral-900 border border-neutral-700 rounded text-white focus:outline-none focus:border-orange-500" />
        </div>
        <div>
          <button type="submit" :disabled="cargando" 
                  class="w-full bg-green-500 hover:bg-green-600 text-neutral-900 font-bold py-2.5 px-4 rounded transition duration-300 disabled:bg-neutral-600 disabled:cursor-not-allowed">
            {{ cargando ? 'Guardando...' : 'Guardar' }}
          </button>
        </div>
      </form>
    </div>

    <div class="bg-neutral-800 rounded-lg overflow-hidden shadow-md">
      <table class="w-full text-left border-collapse">
        <thead>
          <tr>
            <th class="bg-neutral-900 text-neutral-400 font-normal p-4 border-b border-neutral-700">Nombre</th>
            <th class="bg-neutral-900 text-neutral-400 font-normal p-4 border-b border-neutral-700">Correo</th>
            <th class="bg-neutral-900 text-neutral-400 font-normal p-4 border-b border-neutral-700">Rol</th>
            <th class="bg-neutral-900 text-neutral-400 font-normal p-4 border-b border-neutral-700">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="entrenador in entrenadores" :key="entrenador.id" class="hover:bg-neutral-750 transition duration-150">
            <td class="p-4 border-b border-neutral-700">
              <div v-if="editandoId === entrenador.id">
                <input type="text" v-model="entrenador.nombre_completo" 
                       class="w-full p-1.5 bg-neutral-900 border border-orange-500 rounded text-white text-sm focus:outline-none" />
              </div>
              <div v-else>
                {{ entrenador.nombre_completo }}
              </div>
            </td>
            <td class="p-4 border-b border-neutral-700 text-neutral-300">(Protegido)</td>
            <td class="p-4 border-b border-neutral-700">
              <span class="bg-slate-700 text-white px-2 py-1 rounded text-xs uppercase font-bold tracking-wide">
                {{ entrenador.rol }}
              </span>
            </td>
            <td class="p-4 border-b border-neutral-700">
              <div v-if="editandoId === entrenador.id" class="flex gap-2">
                <button title="Guardar Cambios" @click="actualizarEntrenador(entrenador)" class="hover:scale-125 transition transform">💾</button>
                <button title="Cancelar" @click="editandoId = null" class="hover:scale-125 transition transform">❌</button>
              </div>
              <div v-else class="flex gap-2">
                <button title="Editar" @click="iniciarEdicion(entrenador)" class="hover:scale-125 transition transform">✏️</button>
                <button title="Eliminar" @click="eliminarEntrenador(entrenador.id)" class="hover:scale-125 transition transform drop-shadow-[0_0_2px_rgba(255,0,0,0.5)]">🗑️</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
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
      background: '#1e1e1e',
      color: '#fff',
      confirmButtonColor: '#f39c12'
    })

    mostrarFormulario.value = false
    nuevo.value = { nombre: '', email: '', password: '' }
    await cargarEntrenadores()

  } catch (error) {
    Swal.fire({
      title: 'Error',
      text: error.message,
      icon: 'error',
      background: '#1e1e1e',
      color: '#fff'
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
      background: '#1e1e1e',
      color: '#fff',
      confirmButtonColor: '#f39c12'
    })

    editandoId.value = null
    await cargarEntrenadores()
  } catch (error) {
    Swal.fire({
      title: 'Error',
      text: error.message,
      icon: 'error',
      background: '#1e1e1e',
      color: '#fff'
    })
  }
}

const eliminarEntrenador = async (id) => {
  Swal.fire({
    title: '¿Estás seguro?',
    text: "Le quitarás el acceso al sistema a este entrenador",
    icon: 'warning',
    showCancelButton: true,
    background: '#1e1e1e',
    color: '#fff',
    confirmButtonColor: '#d33',
    cancelButtonColor: '#3085d6',
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
          background: '#1e1e1e',
          color: '#fff',
          confirmButtonColor: '#f39c12'
        })
        
        await cargarEntrenadores()
      } catch (error) {
        Swal.fire({
          title: 'Error',
          text: error.message,
          icon: 'error',
          background: '#1e1e1e',
          color: '#fff'
        })
      }
    }
  })
}
</script>