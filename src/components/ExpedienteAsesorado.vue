<template>
  <div class="font-montserrat">
    <!-- PANTALLA DE CARGA -->
    <div v-if="cargando" class="flex flex-col items-center justify-center py-20 gap-4">
      <svg class="animate-spin h-10 w-10 text-[#D4D4D4]" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
      <p class="text-[#888888] font-bold uppercase tracking-widest animate-pulse text-sm">Cargando expediente...</p>
    </div>

    <!-- CONTENIDO DEL EXPEDIENTE -->
    <div v-else-if="asesorado" class="pb-10">
      
      <!-- HEADER RESPONSIVO -->
      <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 border-b border-[#3B3B3B] pb-6 gap-6">
        <div class="w-full md:w-auto">
          <button @click="$emit('volver')" class="text-[#888888] hover:text-[#D4D4D4] transition-colors flex items-center gap-2 text-xs uppercase font-bold tracking-wide mb-4">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            Volver a la lista
          </button>
          <h2 class="text-2xl md:text-3xl font-black m-0 text-[#FAFAFA] uppercase tracking-tight flex flex-wrap items-center gap-2">
            <span class="text-[#555555]">Expediente:</span> 
            <span class="text-[#D4D4D4]">{{ asesorado.nombre_completo }}</span>
          </h2>
        </div>
        
        <div class="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
          <button @click="editando = !editando" 
            :class="editando ? 'bg-[#3B3B3B] text-[#FAFAFA] border-transparent' : 'border-2 border-[#D4D4D4] text-[#D4D4D4] hover:bg-[#D4D4D4] hover:text-[#222222]'"
            class="w-full sm:w-auto px-6 py-3 rounded-full font-extrabold text-xs uppercase tracking-wide transition-all duration-300 shadow-lg text-center">
            {{ editando ? "Cancelar Edición" : "Editar Expediente" }}
          </button>
          
          <button v-if="editando" @click="guardarCambios" 
            class="w-full sm:w-auto px-6 py-3 rounded-full font-extrabold text-xs uppercase tracking-wide transition-all duration-300 shadow-[0_0_15px_rgba(212,212,212,0.2)] bg-[#D4D4D4] text-[#171717] hover:bg-[#FAFAFA] hover:-translate-y-1 hover:shadow-[0_0_20px_rgba(212,212,212,0.4)] flex justify-center items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
            Guardar Cambios
          </button>
        </div>
      </header>

      <!-- GRID DE TARJETAS -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        <!-- 1. DATOS PERSONALES -->
        <div class="bg-[#171717] p-6 rounded-xl shadow-xl border border-[#3B3B3B] border-t-4 border-t-[#D4D4D4] lg:col-span-2 transition-all duration-300 hover:border-[#555555]">
          <h3 class="text-[#D4D4D4] font-black uppercase tracking-widest text-sm flex items-center gap-2 mb-6 border-b border-[#3B3B3B] pb-3">
            <svg class="w-5 h-5 text-[#888888]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
            Datos Personales
          </h3>
          
          <div class="flex flex-col md:flex-row gap-8 items-center md:items-start">
            <!-- Avatar -->
            <div class="flex flex-col items-center gap-4 w-full md:w-auto">
              <img :src="imagenPerfil" class="w-32 h-32 md:w-40 md:h-40 rounded-2xl border-4 border-[#3B3B3B] object-cover shadow-2xl bg-[#222222]" alt="Foto de perfil" />
              <div v-if="editando" class="w-full max-w-[200px]">
                <label class="block text-center text-xs font-bold text-[#888888] uppercase tracking-wide mb-2 cursor-pointer bg-[#222222] border border-[#555555] hover:bg-[#3B3B3B] text-[#D4D4D4] py-2 px-4 rounded-lg transition">
                  Cambiar Foto
                  <input type="file" @change="handleFileUpload" accept="image/*" class="hidden" />
                </label>
                <p v-if="fotoFile" class="text-[10px] text-[#D4D4D4] text-center truncate mt-1">Archivo listo para subir</p>
              </div>
            </div>
            
            <!-- Campos Personales -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 w-full">
              <div class="flex flex-col">
                <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Nombre Completo</label>
                <input v-if="editando" v-model="asesorado.nombre_completo" type="text" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm" />
                <span v-else class="font-bold text-base text-[#EEEEEE]">{{ asesorado.nombre_completo }}</span>
              </div>
              <div class="flex flex-col">
                <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Correo Electrónico <span class="text-[#555555] lowercase normal-case italic">(Solo lectura)</span></label>
                <span class="font-bold text-base text-[#EEEEEE]">{{ asesorado.correo }}</span>
              </div>
              <div class="flex flex-col">
                <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Fecha de Nacimiento</label>
                <input v-if="editando" v-model="asesorado.fecha_nacimiento" type="date" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm" />
                <span v-else class="font-bold text-base text-[#EEEEEE]">{{ asesorado.fecha_nacimiento }}</span>
              </div>
              <div class="flex flex-col">
                <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Sexo</label>
                <select v-if="editando" v-model="asesorado.sexo" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm">
                  <option value="Hombre">Hombre</option>
                  <option value="Mujer">Mujer</option>
                  <option value="Prefiero no decir">Prefiero no decir</option>
                </select>
                <span v-else class="font-bold text-base text-[#EEEEEE]">{{ asesorado.sexo }}</span>
              </div>
              <div class="flex flex-col">
                <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Peso Actual (kg)</label>
                <input v-if="editando" v-model="asesorado.peso_actual" type="number" step="0.1" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm" />
                <span v-else class="font-bold text-base text-[#EEEEEE]">{{ asesorado.peso_actual }} kg</span>
              </div>
              <div class="flex flex-col">
                <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Estatura (m)</label>
                <input v-if="editando" v-model="asesorado.estatura" type="number" step="0.01" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm" />
                <span v-else class="font-bold text-base text-[#EEEEEE]">{{ asesorado.estatura }} m</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 2. SALUD FEMENINA (Condicional) -->
        <div v-if="asesorado.sexo === 'Mujer'" class="bg-[#171717] p-6 rounded-xl shadow-xl border border-[#3B3B3B] border-t-4 border-t-[#D4D4D4] transition-all duration-300 hover:border-[#555555]">
          <h3 class="text-[#D4D4D4] font-black uppercase tracking-widest text-sm flex items-center gap-2 mb-6 border-b border-[#3B3B3B] pb-3">
            <svg class="w-5 h-5 text-[#888888]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
            Salud Femenina
          </h3>
          <div class="space-y-5">
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Ciclo Menstrual</label>
              <select v-if="editando" v-model="asesorado.regularidad_menstrual" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm">
                <option value="Regular">Regular</option>
                <option value="Irregular">Irregular</option>
              </select>
              <span v-else class="font-bold text-sm text-[#EEEEEE]">{{ asesorado.regularidad_menstrual || "No especificado" }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Próximo Periodo (Aprox)</label>
              <input v-if="editando" v-model="asesorado.fecha_proximo_periodo" type="date" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm" />
              <span v-else class="font-bold text-sm text-[#EEEEEE]">{{ asesorado.fecha_proximo_periodo || "No especificada" }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Información Adicional</label>
              <textarea v-if="editando" v-model="asesorado.info_periodo" rows="2" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm"></textarea>
              <span v-else class="font-bold text-sm text-[#EEEEEE]">{{ asesorado.info_periodo || "Ninguna" }}</span>
            </div>
          </div>
        </div>

        <!-- 3. HISTORIAL MÉDICO -->
        <div class="bg-[#171717] p-6 rounded-xl shadow-xl border border-[#3B3B3B] border-t-4 border-t-[#D4D4D4] transition-all duration-300 hover:border-[#555555]" :class="{ 'lg:col-span-2': asesorado.sexo !== 'Mujer' }">
          <h3 class="text-[#D4D4D4] font-black uppercase tracking-widest text-sm flex items-center gap-2 mb-6 border-b border-[#3B3B3B] pb-3">
            <svg class="w-5 h-5 text-[#888888]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
            Historial Médico
          </h3>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Cirugías Recientes</label>
              <textarea v-if="editando" v-model="asesorado.cirugias_recientes" rows="3" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm"></textarea>
              <span v-else class="font-bold text-sm text-[#EEEEEE] bg-[#222222] p-3 rounded-lg border border-[#3B3B3B] min-h-[80px]">{{ asesorado.cirugias_recientes || "Ninguna" }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Enfermedades Crónicas</label>
              <textarea v-if="editando" v-model="asesorado.enfermedades_cronicas" rows="3" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm"></textarea>
              <span v-else class="font-bold text-sm text-[#EEEEEE] bg-[#222222] p-3 rounded-lg border border-[#3B3B3B] min-h-[80px]">{{ asesorado.enfermedades_cronicas || "Ninguna" }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Limitaciones Físicas</label>
              <textarea v-if="editando" v-model="asesorado.limitaciones_fisicas" rows="3" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm"></textarea>
              <span v-else class="font-bold text-sm text-[#EEEEEE] bg-[#222222] p-3 rounded-lg border border-[#3B3B3B] min-h-[80px]">{{ asesorado.limitaciones_fisicas || "Ninguna" }}</span>
            </div>
          </div>
        </div>

        <!-- 4. PERFIL DEPORTIVO -->
        <div class="bg-[#171717] p-6 rounded-xl shadow-xl border border-[#3B3B3B] border-t-4 border-t-[#D4D4D4] transition-all duration-300 hover:border-[#555555]">
          <h3 class="text-[#D4D4D4] font-black uppercase tracking-widest text-sm flex items-center gap-2 mb-6 border-b border-[#3B3B3B] pb-3">
            <svg class="w-5 h-5 text-[#888888]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
            Perfil Deportivo
          </h3>
          <div class="space-y-5">
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Objetivo Principal</label>
              <select v-if="editando" v-model="asesorado.objetivo" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm">
                <option value="Perder grasa">Perder grasa</option>
                <option value="Ganar masa muscular">Ganar masa muscular</option>
                <option value="Recomposición corporal">Recomposición corporal</option>
                <option value="Mejorar salud / Mantenimiento">Mejorar salud / Mantenimiento</option>
              </select>
              <span v-else class="bg-[#222222] text-[#D4D4D4] border border-[#555555] px-3 py-1.5 rounded-lg font-bold uppercase text-[10px] tracking-widest w-fit">{{ asesorado.objetivo }}</span>
            </div>
            
            <div class="grid grid-cols-2 gap-4">
              <div class="flex flex-col">
                <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Días a entrenar</label>
                <input v-if="editando" v-model="asesorado.dias_entrenar" type="number" min="1" max="7" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm" />
                <span v-else class="font-bold text-sm text-[#EEEEEE]">{{ asesorado.dias_entrenar }} días/semana</span>
              </div>
              <div class="flex flex-col">
                <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Tiempo diario</label>
                <select v-if="editando" v-model="asesorado.tiempo_diario" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm">
                  <option value="30 a 45 minutos">30 a 45 minutos</option>
                  <option value="45 a 60 minutos">45 a 60 minutos</option>
                  <option value="1 a 1:30 horas">1 a 1:30 horas</option>
                  <option value="1:30 a 2 horas">1:30 a 2 horas</option>
                  <option value="Más de 2 horas">Más de 2 horas</option>
                </select>
                <span v-else class="font-bold text-sm text-[#EEEEEE]">{{ asesorado.tiempo_diario }}</span>
              </div>
            </div>

            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Experiencia en Gimnasio</label>
              <textarea v-if="editando" v-model="asesorado.experiencia_gimnasio" rows="2" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm"></textarea>
              <span v-else class="font-bold text-sm text-[#EEEEEE]">{{ asesorado.experiencia_gimnasio || "No especificada" }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Actividad Laboral</label>
              <select v-if="editando" v-model="asesorado.actividad_laboral" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm">
                <option value="Ligera (Oficina, sentado la mayor parte del tiempo)">Ligera (Oficina, sentado)</option>
                <option value="Normal (De pie por ratos, caminar un poco)">Normal (De pie, caminatas)</option>
                <option value="Pesada (Trabajo físico constante)">Pesada (Trabajo físico constante)</option>
                <option value="Muy pesada (Carga de cosas, construcción, etc.)">Muy pesada (Construcción, carga)</option>
              </select>
              <span v-else class="font-bold text-sm text-[#EEEEEE]">{{ asesorado.actividad_laboral }}</span>
            </div>
          </div>
        </div>

        <!-- 5. PERFIL NUTRICIONAL -->
        <div class="bg-[#171717] p-6 rounded-xl shadow-xl border border-[#3B3B3B] border-t-4 border-t-[#D4D4D4] transition-all duration-300 hover:border-[#555555]">
          <h3 class="text-[#D4D4D4] font-black uppercase tracking-widest text-sm flex items-center gap-2 mb-6 border-b border-[#3B3B3B] pb-3">
            <svg class="w-5 h-5 text-[#888888]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
            Perfil Nutricional
          </h3>
          <div class="space-y-5">
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Comidas al día</label>
              <input v-if="editando" v-model="asesorado.comidas_diarias" type="number" min="1" max="8" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm" />
              <span v-else class="text-2xl font-black text-[#FAFAFA]">{{ asesorado.comidas_diarias }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Preferencias alimenticias</label>
              <textarea v-if="editando" v-model="asesorado.preferencias_alimentos" rows="3" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm"></textarea>
              <span v-else class="font-bold text-sm text-[#EEEEEE] bg-[#222222] p-3 rounded-lg border border-[#3B3B3B] min-h-[80px]">{{ asesorado.preferencias_alimentos || "Ninguna" }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-xs font-bold text-[#888888] mb-1.5 uppercase tracking-wide">Restricciones / Alergias</label>
              <textarea v-if="editando" v-model="asesorado.alimentos_restringidos" rows="3" class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors text-sm"></textarea>
              <span v-else class="font-bold text-sm text-[#EEEEEE] bg-[#222222] p-3 rounded-lg border border-[#3B3B3B] min-h-[80px]">{{ asesorado.alimentos_restringidos || "Ninguna" }}</span>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { supabase } from "../supabase.js";
import Swal from "sweetalert2";

const props = defineProps(["idAsesorado"]);
defineEmits(["volver"]);

const asesorado = ref(null);
const editando = ref(false);
const cargando = ref(true);

const fotoFile = ref(null);

const handleFileUpload = (event) => {
  fotoFile.value = event.target.files[0];
};

const subirFoto = async () => {
  if (!fotoFile.value) return asesorado.value.url_foto;

  const fileExt = fotoFile.value.name.split(".").pop();
  const fileName = `fotos/${props.idAsesorado}-${Math.random()}.${fileExt}`;

  const { error } = await supabase.storage
    .from("fotos-asesorados")
    .upload(fileName, fotoFile.value, { upsert: true });

  if (error) throw error;

  const { data } = supabase.storage
    .from("fotos-asesorados")
    .getPublicUrl(fileName);
  return data.publicUrl;
};

const cargarExpediente = async () => {
  const { data } = await supabase
    .from("asesorados")
    .select("*")
    .eq("id", props.idAsesorado)
    .single();
  asesorado.value = data;
  cargando.value = false;
};

const guardarCambios = async () => {
  try {
    if (fotoFile.value) {
      asesorado.value.url_foto = await subirFoto();
    }

    const { error } = await supabase
      .from("asesorados")
      .update(asesorado.value)
      .eq("id", props.idAsesorado);

    if (error) throw error;

    Swal.fire({
      title: "¡Expediente actualizado!",
      icon: "success",
      background: "#171717",
      color: "#FAFAFA",
      confirmButtonColor: "#D4D4D4",
      customClass: { confirmButton: 'text-[#222222] font-bold px-6 py-2 rounded-full' }
    });
    
    editando.value = false;
    fotoFile.value = null; 
  } catch (error) {
    Swal.fire({
      title: "Error",
      text: error.message,
      icon: "error",
      background: "#171717",
      color: "#FAFAFA"
    });
  }
};

onMounted(cargarExpediente);

const imagenPerfil = computed(() => {
  const url = asesorado.value?.url_foto;
  if (!url || typeof url !== 'string' || url.trim() === '') {
    return '/images/logo.png';
  }
  return url;
});
</script>