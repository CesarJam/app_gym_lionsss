<template>
  <div
    class="min-h-screen bg-neutral-900 text-white flex justify-center py-10 px-4"
  >
    <div v-if="cargandoInicial" class="text-center mt-20">
      <h2 class="text-2xl text-orange-500 animate-pulse">
        Cargando tu expediente... 🦁
      </h2>
    </div>

    <div
      v-else-if="mensajeError"
      class="max-w-md w-full bg-neutral-800 p-8 rounded-lg text-center shadow-lg h-fit border-t-4 border-red-500"
    >
      <h2 class="text-2xl font-bold mb-4">Enlace no válido</h2>
      <p class="text-neutral-400">{{ mensajeError }}</p>
    </div>

    <!-- Pantalla de Éxito con Credenciales -->
    <div
      v-else-if="registroCompletado"
      class="max-w-md w-full bg-neutral-800 p-8 rounded-lg text-center shadow-lg h-fit border-t-4 border-green-500"
    >
      <h2 class="text-4xl mb-4">🏆</h2>
      <h2 class="text-2xl font-bold mb-2">¡Expediente Completado!</h2>
      <p class="text-neutral-400 mb-6">
        Tus datos han sido enviados a tu entrenador. Tu cuenta en Lionsss
        Academy ha sido creada automáticamente.
      </p>

      <div
        class="bg-neutral-900 p-4 rounded border border-neutral-700 text-left mb-6"
      >
        <p class="text-sm text-neutral-500 mb-1">Tu usuario (Correo):</p>
        <p class="font-bold text-orange-400 mb-3">{{ form.correo }}</p>

        <p class="text-sm text-neutral-500 mb-1">Tu contraseña temporal:</p>
        <p class="font-bold text-orange-400 text-lg tracking-wider">
          {{ passwordGenerada }}
        </p>
      </div>

      <p class="text-xs text-neutral-500 mb-6">
        Guarda esta información. Podrás cambiar tu contraseña una vez que
        inicies sesión.
      </p>

      <router-link
        to="/admin/login"
        class="inline-block w-full bg-orange-500 hover:bg-orange-600 text-neutral-900 font-bold py-3 px-4 rounded transition duration-300"
      >
        Ir al Panel de Inicio de Sesión
      </router-link>
    </div>

    <div
      v-else
      class="max-w-3xl w-full bg-neutral-800 p-6 md:p-10 rounded-lg shadow-xl border-t-4 border-orange-500"
    >
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-orange-500 tracking-widest mb-2">
          Lionsss Academy
        </h1>
        <p class="text-neutral-400">Expediente de Asesorado</p>
      </div>

      <form @submit.prevent="guardarDatos">
        <h3
          class="text-xl border-b border-neutral-700 pb-2 mb-4 text-orange-400"
        >
          1. Datos Básicos
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-8">
          <div class="flex flex-col md:col-span-2">
            <label class="text-sm text-neutral-400 mb-1">Foto de Perfil</label>
            <input
              type="file"
              @change="handleFileUpload"
              accept="image/*"
              class="input-lionsss"
            />
            <p class="text-xs text-neutral-500 mt-1">
              Sube una foto clara de frente.
            </p>
          </div>
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1">Nombre Completo</label>
            <input
              type="text"
              v-model="form.nombre_completo"
              required
              class="input-lionsss"
            />
          </div>
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Correo Electrónico</label
            >
            <input
              type="email"
              v-model="form.correo"
              pattern="[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}"
              title="Debe ser un correo válido, ej: nombre@dominio.com"
              required
              class="input-lionsss"
            />
          </div>
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Fecha de Nacimiento</label
            >
            <input
              type="date"
              v-model="form.fecha_nacimiento"
              required
              class="input-lionsss"
            />
          </div>
          <div class="flex gap-4">
            <div class="flex gap-4">
              <div class="flex flex-col w-1/2">
                <!-- step="0.1" permite decimales. min y max evitan locuras como 1000 kg -->
                <label class="text-sm text-neutral-400 mb-1"
                  >Peso Actual (kg)</label
                >
                <input
                  type="number"
                  v-model="form.peso_actual"
                  step="0.1"
                  min="30"
                  max="250"
                  placeholder="Ej. 75.5"
                  required
                  class="input-lionsss"
                />
              </div>
              <div class="flex flex-col w-1/2">
                <label class="text-sm text-neutral-400 mb-1"
                  >Estatura (m)</label
                >
                <input
                  type="number"
                  v-model="form.estatura"
                  step="0.01"
                  min="1.00"
                  max="2.50"
                  placeholder="Ej. 1.75"
                  required
                  class="input-lionsss"
                />
              </div>
            </div>
          </div>

          <div class="flex flex-col md:col-span-2">
            <label class="text-sm text-neutral-400 mb-1">Sexo</label>
            <select v-model="form.sexo" required class="input-lionsss">
              <option value="" disabled>Selecciona una opción</option>
              <option value="Hombre">Hombre</option>
              <option value="Mujer">Mujer</option>
              <option value="Prefiero no decir">Prefiero no decir</option>
            </select>
          </div>
        </div>

        <h3
          class="text-xl border-b border-neutral-700 pb-2 mb-4 text-orange-400"
        >
          2. Historial Médico y Físico
        </h3>
        <div class="grid grid-cols-1 gap-5 mb-8">
          <div
            v-if="form.sexo === 'Mujer'"
            class="grid grid-cols-1 md:grid-cols-2 gap-5 p-5 bg-neutral-900 border border-neutral-700 rounded-lg mb-2"
          >
            <h4
              class="md:col-span-2 text-orange-400 font-semibold mb-1 border-b border-neutral-700 pb-1"
            >
              Salud Femenina (Ciclo Menstrual)
            </h4>

            <div class="flex flex-col">
              <label class="text-sm text-neutral-400 mb-1"
                >¿Eres regular o irregular?</label
              >
              <select
                v-model="form.regularidad_menstrual"
                required
                class="input-lionsss"
              >
                <option value="" disabled>Selecciona una opción</option>
                <option value="Regular">Regular</option>
                <option value="Irregular">Irregular</option>
              </select>
            </div>
            <div class="flex flex-col">
              <label class="text-sm text-neutral-400 mb-1"
                >Fecha de tu próximo periodo (Aprox)</label
              >
              <input
                type="date"
                v-model="form.fecha_proximo_periodo"
                class="input-lionsss"
              />
            </div>
            <div class="flex flex-col md:col-span-2">
              <label class="text-sm text-neutral-400 mb-1"
                >Información adicional de tu periodo</label
              >
              <textarea
                v-model="form.info_periodo"
                placeholder="Ej. Síntomas fuertes, amenorrea, uso de anticonceptivos, etc."
                rows="2"
                class="input-lionsss"
              ></textarea>
            </div>
          </div>

          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Cirugías recientes</label
            >
            <textarea
              v-model="form.cirugias_recientes"
              placeholder="Si no tienes, escribe 'Ninguna'"
              rows="2"
              class="input-lionsss"
            ></textarea>
          </div>
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Enfermedades crónicas</label
            >
            <textarea
              v-model="form.enfermedades_cronicas"
              placeholder="Ej. Hipertensión, asma, diabetes, etc."
              rows="2"
              class="input-lionsss"
            ></textarea>
          </div>
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Limitaciones físicas (lumbalgias, hernias, prótesis,
              fracturas)</label
            >
            <textarea
              v-model="form.limitaciones_fisicas"
              placeholder="Detalla si tienes alguna lesión o dolor frecuente"
              rows="2"
              class="input-lionsss"
            ></textarea>
          </div>
        </div>

        <h3
          class="text-xl border-b border-neutral-700 pb-2 mb-4 text-orange-400"
        >
          3. Entrenamiento y Estilo de Vida
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-8">
          <div class="flex flex-col md:col-span-2">
            <label class="text-sm text-neutral-400 mb-1"
              >Objetivo Principal</label
            >
            <select v-model="form.objetivo" required class="input-lionsss">
              <option value="" disabled>Selecciona una opción</option>
              <option value="Perder grasa">Perder grasa</option>
              <option value="Ganar masa muscular">Ganar masa muscular</option>
              <option value="Recomposición corporal">
                Recomposición corporal
              </option>
              <option value="Mejorar salud / Mantenimiento">
                Mejorar salud / Mantenimiento
              </option>
            </select>
          </div>
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Días a entrenar por semana (Seguros)</label
            >
            <input
              type="number"
              min="1"
              max="7"
              v-model="form.dias_entrenar"
              placeholder="Ej. 4"
              required
              class="input-lionsss"
            />
          </div>
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Tiempo disponible por día</label
            >
            <select v-model="form.tiempo_diario" required class="input-lionsss">
              <option value="" disabled>Selecciona tu disponibilidad</option>
              <option value="30 a 45 minutos">30 a 45 minutos</option>
              <option value="45 a 60 minutos">45 a 60 minutos</option>
              <option value="1 a 1:30 horas">
                1 a 1:30 horas (Recomendado)
              </option>
              <option value="1:30 a 2 horas">1:30 a 2 horas</option>
              <option value="Más de 2 horas">Más de 2 horas</option>
            </select>
          </div>
          <div class="flex flex-col md:col-span-2">
            <label class="text-sm text-neutral-400 mb-1"
              >Experiencia entrenando (¿Última vez y cuánto tiempo?)</label
            >
            <textarea
              v-model="form.experiencia_gimnasio"
              rows="2"
              class="input-lionsss"
            ></textarea>
          </div>
          <div class="flex flex-col md:col-span-2">
            <label class="text-sm text-neutral-400 mb-1"
              >Nivel de actividad laboral diaria</label
            >
            <select
              v-model="form.actividad_laboral"
              required
              class="input-lionsss"
            >
              <option value="" disabled>Selecciona una opción</option>
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
          </div>
        </div>

        <h3
          class="text-xl border-b border-neutral-700 pb-2 mb-4 text-orange-400"
        >
          4. Nutrición
        </h3>
        <div class="grid grid-cols-1 gap-5 mb-8">
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Número de comidas que puedes realizar al día</label
            >
            <input
              type="number"
              min="1"
              max="8"
              v-model="form.comidas_diarias"
              required
              class="input-lionsss"
            />
          </div>
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Preferencias: Comidas/alimentos que más te gusten</label
            >
            <textarea
              v-model="form.preferencias_alimentos"
              rows="2"
              class="input-lionsss"
            ></textarea>
          </div>
          <div class="flex flex-col">
            <label class="text-sm text-neutral-400 mb-1"
              >Alimentos que NO puedes o NO deseas consumir (Alergias)</label
            >
            <textarea
              v-model="form.alimentos_restringidos"
              rows="2"
              class="input-lionsss"
            ></textarea>
          </div>
        </div>

        <button
          type="submit"
          :disabled="guardando"
          class="w-full bg-orange-500 hover:bg-orange-600 text-neutral-900 font-bold py-4 px-4 rounded text-lg transition duration-300 disabled:bg-neutral-600"
        >
          {{ guardando ? "Enviando Datos..." : "Guardar y Enviar Expediente" }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import { useRoute } from "vue-router";
import { supabase } from "../supabase.js";
import Swal from "sweetalert2";

const route = useRoute();
const cargandoInicial = ref(true);
const guardando = ref(false);
const mensajeError = ref(null);
const registroCompletado = ref(false);
const tokenActual = ref(null);
const passwordGenerada = ref("");

const fotoFile = ref(null)

const handleFileUpload = (event) => {
  fotoFile.value = event.target.files[0]
}

const subirFoto = async (asesoradoId) => {
  if (!fotoFile.value) return null
  
  const fileExt = fotoFile.value.name.split('.').pop()
  const fileName = `${asesoradoId}-${Math.random()}.${fileExt}`
  
  const { error } = await supabase.storage
    .from('fotos-asesorados')
    .upload(fileName, fotoFile.value)
    
  if (error) throw error
  
  const { data } = supabase.storage.from('fotos-asesorados').getPublicUrl(fileName)
  return data.publicUrl
}

// Objeto para atrapar las respuestas actualizado con los nuevos campos
const form = ref({
  nombre_completo: "",
  correo: "",
  fecha_nacimiento: "",
  peso_actual: "",
  estatura: "",
  sexo: "",
  regularidad_menstrual: "",
  fecha_proximo_periodo: "",
  info_periodo: "",
  cirugias_recientes: "",
  enfermedades_cronicas: "",
  limitaciones_fisicas: "",
  objetivo: "",
  dias_entrenar: "",
  tiempo_diario: "",
  experiencia_gimnasio: "",
  actividad_laboral: "",
  comidas_diarias: "",
  preferencias_alimentos: "",
  alimentos_restringidos: "",
});

// Este "watch" limpia los campos femeninos si cambia de opinión y selecciona "Hombre"
watch(
  () => form.value.sexo,
  (nuevoSexo) => {
    if (nuevoSexo !== "Mujer") {
      form.value.regularidad_menstrual = "";
      form.value.fecha_proximo_periodo = null;
      form.value.info_periodo = "";
    }
  },
);

onMounted(async () => {
  tokenActual.value = route.params.token;
  await verificarToken();
});

const verificarToken = async () => {
  if (!tokenActual.value) {
    mensajeError.value = "No se detectó ningún código de registro.";
    cargandoInicial.value = false;
    return;
  }

  try {
    const { data, error } = await supabase
      .from("asesorados")
      .select("*")
      .eq("token_registro", tokenActual.value)
      .single();

    if (error || !data) throw new Error("El enlace es inválido o no existe.");

    if (data.estado_registro === "completado") {
      registroCompletado.value = true;
    } else {
      form.value.nombre_completo = data.nombre_completo;
    }
  } catch (error) {
    mensajeError.value = error.message;
  } finally {
    cargandoInicial.value = false;
  }
};

const guardarDatos = async () => {
  try {
    guardando.value = true
    
    // 1. PRIMERO: Subimos la foto (si existe) y obtenemos la URL
    let urlFoto = null
    if (fotoFile.value) {
      urlFoto = await subirFoto(tokenActual.value)
    }

    // 2. Generamos contraseña
    const numAleatorio = Math.floor(1000 + Math.random() * 9000);
    const passwordTemp = `Lionsss-${numAleatorio}!`;

    // 3. Auth
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email: form.value.correo,
      password: passwordTemp,
    });
    if (authError) throw authError;

    // 4. Perfil
    const { error: perfilError } = await supabase.from('perfiles').insert([
      { id: authData.user.id, nombre_completo: form.value.nombre_completo, rol: 'asesorado' }
    ]);
    if (perfilError) throw perfilError;

    // 5. Actualizamos expediente con la urlFoto obtenida
    const datosActualizados = {
      ...form.value,
      url_foto: urlFoto, // <--- Aquí guardamos la URL en la base de datos
      id_auth: authData.user.id,
      estado_registro: 'completado'
    }

    const { error: updateError } = await supabase
      .from('asesorados')
      .update(datosActualizados)
      .eq('token_registro', tokenActual.value)

    if (updateError) throw updateError

    passwordGenerada.value = passwordTemp;
    registroCompletado.value = true;

  } catch (error) {
    Swal.fire('Error', 'Hubo un problema: ' + error.message, 'error')
  } finally {
    guardando.value = false
  }
}
</script>

<style scoped>
.input-lionsss {
  width: 100%;
  padding: 0.625rem;
  background-color: #171717;
  border: 1px solid #404040;
  border-radius: 0.375rem;
  color: white;
  transition: all 0.3s;
}
.input-lionsss:focus {
  outline: none;
  border-color: #f39c12;
}
</style>
