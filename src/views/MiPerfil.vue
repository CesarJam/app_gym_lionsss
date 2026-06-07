<template>
  <div class="p-6">
    <h1 class="text-3xl font-bold text-white mb-6">Mi Perfil</h1>
    
    <ExpedienteAsesorado 
      v-if="asesoradoId" 
      :idAsesorado="asesoradoId" 
      @volver="irAlDashboard"
    />
    
    <div v-else class="text-center text-neutral-400">
      Cargando información de tu perfil...
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../supabase.js'
import { useRouter } from 'vue-router'
import ExpedienteAsesorado from '../components/ExpedienteAsesorado.vue'

const router = useRouter()
const asesoradoId = ref(null)

onMounted(async () => {
  // Obtenemos el usuario autenticado
  const { data: { user } } = await supabase.auth.getUser()
  
  // Buscamos el ID en la tabla de asesorados que coincida con el id_auth del usuario
  const { data } = await supabase
    .from('asesorados')
    .select('id')
    .eq('id_auth', user.id)
    .single()
    
  if (data) {
    asesoradoId.value = data.id
  }
})

const irAlDashboard = () => router.push('/dashboard')
</script>