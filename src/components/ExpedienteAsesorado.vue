<template>
  <div v-if="cargando" class="text-center py-10">
    <p class="text-orange-500 animate-pulse text-xl">Cargando expediente...</p>
  </div>

  <div v-else-if="asesorado">
    <header
      class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 border-b border-neutral-800 pb-4 gap-4"
    >
      <div>
        <h2 class="text-2xl font-light m-0 text-white flex items-center gap-3">
          <button
            @click="$emit('volver')"
            class="text-neutral-400 hover:text-orange-500 transition px-2 py-1 bg-neutral-800 rounded"
          >
            ← Volver
          </button>
          Expediente:
          <span class="font-bold text-orange-500">{{
            asesorado.nombre_completo
          }}</span>
        </h2>
      </div>
      <div class="flex gap-3">
        <button
          @click="editando = !editando"
          :class="
            editando ? 'bg-neutral-600 text-white' : 'bg-orange-500 text-black'
          "
          class="px-4 py-2 rounded font-bold transition"
        >
          {{ editando ? "Cancelar Edición" : "Editar Expediente" }}
        </button>
        <button
          v-if="editando"
          @click="guardarCambios"
          class="px-4 py-2 bg-green-600 rounded text-white font-bold hover:bg-green-700 transition shadow-[0_0_10px_rgba(22,163,74,0.4)]"
        >
          Guardar Cambios
        </button>
      </div>
    </header>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div
        class="bg-neutral-800 p-6 rounded-lg shadow-md border-t-4 border-orange-500 lg:col-span-2"
      >
        <h3
          class="text-orange-400 font-semibold flex items-center gap-2 mb-4 border-b border-neutral-700 pb-2"
        >
          <svg
            class="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
            ></path>
          </svg>
          Datos Personales
        </h3>
        <div
          class="flex flex-col md:flex-row gap-6 items-center md:items-start"
        >
          <div class="flex flex-col items-center gap-2">
            <img
              :src="
                asesorado.url_foto ? asesorado.url_foto : '/images/logo.png'
              "
              class="w-24 h-24 md:w-32 md:h-32 rounded-lg border-2 border-orange-500 object-cover shadow-xl"
              alt="Foto de perfil"
            />
            <div v-if="editando" class="w-full">
              <label class="text-xs text-neutral-400">Cambiar Foto:</label>
              <input
                type="file"
                @change="handleFileUpload"
                accept="image/*"
                class="w-full text-xs bg-neutral-700 p-1 rounded"
              />
            </div>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 w-full text-sm">
            <div class="flex flex-col">
              <label class="text-neutral-400 text-xs mb-1"
                >Nombre Completo</label
              >
              <input
                v-if="editando"
                v-model="asesorado.nombre_completo"
                type="text"
                class="bg-neutral-700 p-2 rounded border border-neutral-600 focus:border-orange-500 outline-none w-full"
              />
              <span v-else class="font-bold text-base">{{
                asesorado.nombre_completo
              }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-neutral-400 text-xs mb-1"
                >Correo Electrónico (Solo Lectura)</label
              >
              <span class="font-bold text-base">{{ asesorado.correo }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-neutral-400 text-xs mb-1"
                >Fecha de Nacimiento</label
              >
              <input
                v-if="editando"
                v-model="asesorado.fecha_nacimiento"
                type="date"
                class="bg-neutral-700 p-2 rounded border border-neutral-600 focus:border-orange-500 outline-none w-full"
              />
              <span v-else class="font-bold text-base">{{
                asesorado.fecha_nacimiento
              }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-neutral-400 text-xs mb-1">Sexo</label>
              <select
                v-if="editando"
                v-model="asesorado.sexo"
                class="bg-neutral-700 p-2 rounded border border-neutral-600 focus:border-orange-500 outline-none w-full"
              >
                <option value="Hombre">Hombre</option>
                <option value="Mujer">Mujer</option>
                <option value="Prefiero no decir">Prefiero no decir</option>
              </select>
              <span v-else class="font-bold text-base">{{
                asesorado.sexo
              }}</span>
            </div>
            <div class="flex flex-col">
              <label class="text-neutral-400 text-xs mb-1"
                >Peso Actual (kg)</label
              >
              <input
                v-if="editando"
                v-model="asesorado.peso_actual"
                type="number"
                step="0.1"
                class="bg-neutral-700 p-2 rounded border border-neutral-600 focus:border-orange-500 outline-none w-full"
              />
              <span v-else class="font-bold text-base"
                >{{ asesorado.peso_actual }} kg</span
              >
            </div>
            <div class="flex flex-col">
              <label class="text-neutral-400 text-xs mb-1">Estatura (m)</label>
              <input
                v-if="editando"
                v-model="asesorado.estatura"
                type="number"
                step="0.01"
                class="bg-neutral-700 p-2 rounded border border-neutral-600 focus:border-orange-500 outline-none w-full"
              />
              <span v-else class="font-bold text-base"
                >{{ asesorado.estatura }} m</span
              >
            </div>
          </div>
        </div>
      </div>

      <div
        v-if="asesorado.sexo === 'Mujer'"
        class="bg-neutral-800 p-6 rounded-lg shadow-md border-t-4 border-pink-500"
      >
        <h3
          class="text-pink-400 font-semibold flex items-center gap-2 mb-4 border-b border-neutral-700 pb-2"
        >
          <svg
            class="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
            ></path>
          </svg>
          Salud Femenina
        </h3>
        <div class="space-y-4 text-sm">
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1">Ciclo Menstrual</label>
            <select
              v-if="editando"
              v-model="asesorado.regularidad_menstrual"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            >
              <option value="Regular">Regular</option>
              <option value="Irregular">Irregular</option>
            </select>
            <span v-else class="font-bold text-base">{{
              asesorado.regularidad_menstrual || "No especificado"
            }}</span>
          </div>
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Próximo Periodo (Aprox)</label
            >
            <input
              v-if="editando"
              v-model="asesorado.fecha_proximo_periodo"
              type="date"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            />
            <span v-else class="font-bold text-base">{{
              asesorado.fecha_proximo_periodo || "No especificada"
            }}</span>
          </div>
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Información Adicional</label
            >
            <textarea
              v-if="editando"
              v-model="asesorado.info_periodo"
              rows="2"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            ></textarea>
            <span v-else class="font-bold text-base">{{
              asesorado.info_periodo || "Ninguna"
            }}</span>
          </div>
        </div>
      </div>

      <div
        class="bg-neutral-800 p-6 rounded-lg shadow-md border-t-4 border-red-500"
        :class="{ 'lg:col-span-2': asesorado.sexo !== 'Mujer' }"
      >
        <h3
          class="text-red-400 font-semibold flex items-center gap-2 mb-4 border-b border-neutral-700 pb-2"
        >
          <svg
            class="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
            ></path>
          </svg>
          Historial Médico
        </h3>
        <div class="space-y-4 text-sm">
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Cirugías Recientes</label
            >
            <textarea
              v-if="editando"
              v-model="asesorado.cirugias_recientes"
              rows="2"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            ></textarea>
            <span v-else class="font-bold text-base">{{
              asesorado.cirugias_recientes || "Ninguna"
            }}</span>
          </div>
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Enfermedades Crónicas</label
            >
            <textarea
              v-if="editando"
              v-model="asesorado.enfermedades_cronicas"
              rows="2"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            ></textarea>
            <span v-else class="font-bold text-base">{{
              asesorado.enfermedades_cronicas || "Ninguna"
            }}</span>
          </div>
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Limitaciones Físicas</label
            >
            <textarea
              v-if="editando"
              v-model="asesorado.limitaciones_fisicas"
              rows="2"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            ></textarea>
            <span v-else class="font-bold text-base">{{
              asesorado.limitaciones_fisicas || "Ninguna"
            }}</span>
          </div>
        </div>
      </div>

      <div
        class="bg-neutral-800 p-6 rounded-lg shadow-md border-t-4 border-blue-500"
      >
        <h3
          class="text-blue-400 font-semibold flex items-center gap-2 mb-4 border-b border-neutral-700 pb-2"
        >
          <svg
            class="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M13 10V3L4 14h7v7l9-11h-7z"
            ></path>
          </svg>
          Perfil Deportivo
        </h3>
        <div class="space-y-4 text-sm">
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Objetivo Principal</label
            >
            <select
              v-if="editando"
              v-model="asesorado.objetivo"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            >
              <option value="Perder grasa">Perder grasa</option>
              <option value="Ganar masa muscular">Ganar masa muscular</option>
              <option value="Recomposición corporal">
                Recomposición corporal
              </option>
              <option value="Mejorar salud / Mantenimiento">
                Mejorar salud / Mantenimiento
              </option>
            </select>
            <span
              v-else
              class="bg-blue-900 text-blue-300 px-2 py-1 rounded font-bold uppercase text-xs w-fit"
              >{{ asesorado.objetivo }}</span
            >
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="flex flex-col">
              <label class="text-neutral-400 text-xs mb-1"
                >Días a entrenar</label
              >
              <input
                v-if="editando"
                v-model="asesorado.dias_entrenar"
                type="number"
                min="1"
                max="7"
                class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
              />
              <span v-else class="font-bold text-base"
                >{{ asesorado.dias_entrenar }} días/semana</span
              >
            </div>
            <div class="flex flex-col">
              <label class="text-neutral-400 text-xs mb-1">Tiempo diario</label>
              <select
                v-if="editando"
                v-model="asesorado.tiempo_diario"
                class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
              >
                <option value="30 a 45 minutos">30 a 45 minutos</option>
                <option value="45 a 60 minutos">45 a 60 minutos</option>
                <option value="1 a 1:30 horas">1 a 1:30 horas</option>
                <option value="1:30 a 2 horas">1:30 a 2 horas</option>
                <option value="Más de 2 horas">Más de 2 horas</option>
              </select>
              <span v-else class="font-bold text-base">{{
                asesorado.tiempo_diario
              }}</span>
            </div>
          </div>
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Experiencia en Gimnasio</label
            >
            <textarea
              v-if="editando"
              v-model="asesorado.experiencia_gimnasio"
              rows="2"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            ></textarea>
            <span v-else class="font-bold text-base">{{
              asesorado.experiencia_gimnasio || "No especificada"
            }}</span>
          </div>
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Actividad Laboral</label
            >
            <select
              v-if="editando"
              v-model="asesorado.actividad_laboral"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full text-xs"
            >
              <option
                value="Ligera (Oficina, sentado la mayor parte del tiempo)"
              >
                Ligera (Oficina, sentado)
              </option>
              <option value="Normal (De pie por ratos, caminar un poco)">
                Normal (De pie, caminatas)
              </option>
              <option value="Pesada (Trabajo físico constante)">
                Pesada (Trabajo físico constante)
              </option>
              <option value="Muy pesada (Carga de cosas, construcción, etc.)">
                Muy pesada (Construcción, carga)
              </option>
            </select>
            <span v-else class="font-bold text-base">{{
              asesorado.actividad_laboral
            }}</span>
          </div>
        </div>
      </div>

      <div
        class="bg-neutral-800 p-6 rounded-lg shadow-md border-t-4 border-green-500"
      >
        <h3
          class="text-green-400 font-semibold flex items-center gap-2 mb-4 border-b border-neutral-700 pb-2"
        >
          <svg
            class="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"
            ></path>
          </svg>
          Perfil Nutricional
        </h3>
        <div class="space-y-4 text-sm">
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1">Comidas al día</label>
            <input
              v-if="editando"
              v-model="asesorado.comidas_diarias"
              type="number"
              min="1"
              max="8"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            />
            <span v-else class="text-2xl font-bold">{{
              asesorado.comidas_diarias
            }}</span>
          </div>
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Preferencias alimenticias</label
            >
            <textarea
              v-if="editando"
              v-model="asesorado.preferencias_alimentos"
              rows="2"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            ></textarea>
            <span v-else class="font-bold text-base">{{
              asesorado.preferencias_alimentos || "Ninguna"
            }}</span>
          </div>
          <div class="flex flex-col">
            <label class="text-neutral-400 text-xs mb-1"
              >Restricciones / Alergias</label
            >
            <textarea
              v-if="editando"
              v-model="asesorado.alimentos_restringidos"
              rows="2"
              class="bg-neutral-700 p-2 rounded border border-neutral-600 w-full"
            ></textarea>
            <span v-else class="font-bold text-red-400 text-base">{{
              asesorado.alimentos_restringidos || "Ninguna"
            }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
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

// Función para cargar los datos
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
    // 1. Si hay una nueva foto, súbela y obtén la nueva URL
    if (fotoFile.value) {
      asesorado.value.url_foto = await subirFoto();
    }

    // 2. Guardar el resto de los cambios
    const { error } = await supabase
      .from("asesorados")
      .update(asesorado.value)
      .eq("id", props.idAsesorado);

    if (error) throw error;

    Swal.fire({
      title: "¡Expediente actualizado!",
      icon: "success",
      background: "#1e1e1e",
      color: "#fff",
    });
    editando.value = false;
    fotoFile.value = null; // Limpiamos la referencia
  } catch (error) {
    Swal.fire("Error", error.message, "error");
  }
};

onMounted(cargarExpediente);
</script>
