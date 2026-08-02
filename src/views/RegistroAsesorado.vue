<template>
  <div
    class="min-h-screen bg-neutral-900 text-white flex justify-center py-10 px-4"
  >
    <div v-if="cargandoInicial" class="text-center mt-20">
      <h2 class="text-2xl text-[#D4D4D4] animate-pulse">
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

    <div
      v-else-if="registroCompletado"
      class="max-w-md w-full bg-neutral-800 p-8 rounded-lg text-center shadow-lg h-fit border-t-4 border-green-500 relative overflow-hidden"
    >
      <div
        class="absolute top-0 left-0 w-full h-1 bg-green-500 animate-pulse"
      ></div>
      <h2 class="text-5xl mb-4">📩</h2>
      <h2 class="text-2xl font-bold mb-2 text-white">¡Expediente enviado!</h2>
      <p class="text-[#D4D4D4] font-semibold mb-6">
        Pero espera, falta un paso muy importante.
      </p>

      <div
        class="bg-neutral-900 p-5 rounded-lg border border-neutral-700 text-left mb-6 relative"
      >
        <p class="text-sm text-neutral-400 mb-3">
          <span
            class="bg-[#202A78] text-white font-bold rounded-full w-5 h-5 inline-flex items-center justify-center mr-2 text-xs"
            >1</span
          >
          Ve a tu bandeja de entrada: <br />
          <strong class="text-white ml-8 block mt-1">{{ form.correo }}</strong>
        </p>

        <p class="text-sm text-neutral-400 mb-3">
          <span
            class="bg-[#202A78] text-white font-bold rounded-full w-5 h-5 inline-flex items-center justify-center mr-2 text-xs"
            >2</span
          >
          Haz clic en el <strong>enlace de verificación</strong> que te acabamos
          de enviar (revisa el Spam por si acaso).
        </p>

        <p class="text-sm text-neutral-400">
          <span
            class="bg-[#202A78] text-white font-bold rounded-full w-5 h-5 inline-flex items-center justify-center mr-2 text-xs"
            >3</span
          >
          <strong>Tu contraseña temporal</strong> ha sido incluida en ese mismo
          correo por seguridad.
        </p>
      </div>

      <router-link
        to="/admin/login"
        class="inline-block w-full bg-[#202A78] hover:bg-[#1c256b] text-white font-bold py-3 px-4 rounded transition duration-300"
      >
        Ya confirmé mi correo, ir al Login
      </router-link>
    </div>

    <div
      v-else
      class="max-w-3xl w-full bg-neutral-800 p-6 md:p-10 rounded-lg shadow-xl border-t-4 border-[#202A78]"
    >
      <div class="text-center mb-8">
        <img
          src="/images/logos/logoLionssgrey.png"
          class="w-60 mx-auto mb-3 object-contain"
          alt="Logo Lionsss"
        />

        <p class="text-neutral-400">Expediente de Asesorado</p>
      </div>

      <form @submit.prevent="guardarDatos">
        <h3
          class="text-xl border-b border-neutral-700 pb-2 mb-4 text-[#D4D4D4]"
        >
          1. Datos Básicos
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-8">
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
          class="text-xl border-b border-neutral-700 pb-2 mb-4 text-[#D4D4D4]"
        >
          2. Historial Médico y Físico
        </h3>
        <div class="grid grid-cols-1 gap-5 mb-8">
          <div
            v-if="form.sexo === 'Mujer'"
            class="grid grid-cols-1 md:grid-cols-2 gap-5 p-5 bg-neutral-900 border border-neutral-700 rounded-lg mb-2"
          >
            <h4
              class="md:col-span-2 text-[#D4D4D4] font-semibold mb-1 border-b border-neutral-700 pb-1"
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
          class="text-xl border-b border-neutral-700 pb-2 mb-4 text-[#D4D4D4]"
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
          class="text-xl border-b border-neutral-700 pb-2 mb-4 text-[#D4D4D4]"
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

        <!-- Check de Términos y Condiciones -->
        <div
          class="mb-6 flex items-start gap-3 bg-neutral-900 p-4 rounded-lg border border-neutral-700"
        >
          <input
            type="checkbox"
            id="terminos"
            v-model="aceptaTerminos"
            class="mt-1 w-5 h-5 accent-[#202A78] cursor-pointer"
          />
          <label
            for="terminos"
            class="text-sm text-neutral-400 select-none cursor-pointer"
          >
            He leído y acepto los
            <button
              type="button"
              @click="mostrarTerminos = true"
              class="text-[#D4D4D4] font-bold hover:text-white underline transition-colors"
            >
              Términos, Condiciones y Aviso de Privacidad</button
            >.
          </label>
        </div>

        <!-- Botón Guardar modificado para requerir los términos -->
        <button
          type="submit"
          :disabled="guardando || !aceptaTerminos"
          class="w-full bg-[#202A78] hover:bg-[#1c256b] text-white font-bold py-4 px-4 rounded text-lg transition duration-300 disabled:bg-neutral-700 disabled:text-neutral-500 disabled:cursor-not-allowed"
        >
          {{ guardando ? "Enviando Datos..." : "Guardar y Enviar Expediente" }}
        </button>
      </form>
    </div>

    <!-- MODAL TÉRMINOS Y CONDICIONES -->
    <div
      v-if="mostrarTerminos"
      class="fixed inset-0 z-[9999] flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm"
    >
      <div
        class="bg-[#171717] border-t-4 border-[#202A78] rounded-xl shadow-2xl w-full max-w-3xl max-h-[85vh] flex flex-col overflow-hidden animate-fade-in-up"
      >
        <div
          class="p-5 border-b border-neutral-700 flex justify-between items-center bg-[#222222]"
        >
          <h3
            class="text-lg md:text-xl font-bold text-white uppercase tracking-wider"
          >
            Aviso Legal
          </h3>
          <button
            @click="mostrarTerminos = false"
            class="text-neutral-400 hover:text-white transition-colors"
            aria-label="Cerrar modal"
          >
            <svg
              class="w-6 h-6"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M6 18L18 6M6 6l12 12"
              ></path>
            </svg>
          </button>
        </div>

        <div class="p-6 overflow-y-auto text-neutral-300 text-sm space-y-5">
          <div class="text-center mb-6">
            <h4 class="text-xl font-black text-white mb-2">
              TÉRMINOS, CONDICIONES Y AVISO DE PRIVACIDAD
            </h4>
            <p class="text-xs text-neutral-500 uppercase tracking-widest">
              Última actualización: 28/06/2024
            </p>
          </div>

          <p>
            Bienvenido(a) a lionsssacademy.com.mx. Al registrarte, acceder y
            utilizar nuestros servicios, aceptas someterte a los presentes
            Términos, Condiciones y Políticas de Privacidad. Te rogamos leerlos
            cuidadosamente antes de proporcionar cualquier información.
          </p>

          <h5
            class="text-[#D4D4D4] font-bold text-base mt-6 border-b border-neutral-700 pb-1"
          >
            1. AVISO DE PRIVACIDAD Y PROTECCIÓN DE DATOS PERSONALES
          </h5>
          <p>
            En cumplimiento con la Ley Federal de Protección de Datos Personales
            en Posesión de los Particulares (en adelante, la "Ley") vigente en
            los Estados Unidos Mexicanos, y en alineación con los estándares
            internacionales de protección de datos, lionsssacademy.com.mx
            garantiza la protección y el uso estrictamente confidencial de tu
            información.
          </p>

          <p>
            <strong class="text-white">1.1. Datos Recopilados:</strong> Para la
            correcta prestación de nuestros servicios, recopilaremos los
            siguientes datos personales y datos personales sensibles:
          </p>
          <ul class="list-disc pl-5 space-y-2 text-neutral-400">
            <li>
              <strong>Datos de Identificación y Contacto:</strong> Nombre
              completo, correo electrónico, fecha de nacimiento.
            </li>
            <li>
              <strong>Datos Biométricos y Físicos:</strong> Peso, estatura,
              limitaciones físicas.
            </li>
            <li>
              <strong>Datos de Salud (Sensibles):</strong> Historial médico,
              enfermedades crónicas, lesiones preexistentes.
            </li>
            <li>
              <strong>Datos de Estilo de Vida:</strong> Objetivos principales,
              días de entrenamiento, experiencia previa entrenando.
            </li>
            <li>
              <strong>Datos Nutricionales:</strong> Número de comidas diarias,
              preferencias alimenticias, intolerancias, alergias y alimentos no
              deseados.
            </li>
          </ul>

          <p>
            <strong class="text-white"
              >1.2. Finalidad del Tratamiento de Datos:</strong
            >
            La información proporcionada será utilizada única y exclusivamente
            con los siguientes fines:
          </p>
          <ul class="list-disc pl-5 space-y-2 text-neutral-400">
            <li>
              Diseñar, estructurar y personalizar planes de acondicionamiento
              físico.
            </li>
            <li>
              Elaborar guías y recomendaciones de alimentación adaptadas a tus
              objetivos, preferencias y restricciones.
            </li>
            <li>Dar seguimiento a tu progreso dentro de la plataforma.</li>
          </ul>

          <p>
            <strong class="text-white"
              >1.3. No Transferencia a Terceros:</strong
            >
            Tus datos personales y sensibles no serán vendidos, alquilados ni
            compartidos con terceros para fines comerciales, publicitarios o
            ajenos a la estructuración de tus planes físicos y nutricionales.
          </p>
          <p>
            <strong class="text-white">1.4. Derechos ARCO:</strong> Como titular
            de los datos, tienes derecho a Acceder, Rectificar, Cancelar u
            Oponerte (Derechos ARCO) al uso de tu información en cualquier
            momento, enviando una solicitud al correo
            <a
              href="mailto:lionsssacademy@gmail.com"
              class="text-blue-400 hover:underline"
              >lionsssacademy@gmail.com</a
            >.
          </p>

          <h5
            class="text-[#D4D4D4] font-bold text-base mt-8 border-b border-neutral-700 pb-1"
          >
            2. TÉRMINOS Y CONDICIONES DE USO
          </h5>
          <p>
            <strong class="text-white">2.1. Naturaleza del Servicio:</strong>
            lionsssacademy.com.mx es una herramienta digital diseñada para
            brindar orientación en acondicionamiento físico y nutrición. No
            somos un centro médico. Las rutinas de ejercicio y planes
            alimenticios se proporcionan a modo de sugerencia basada en la
            información ingresada por el usuario. No sustituyen el diagnóstico,
            tratamiento ni la consulta presencial con un médico, nutriólogo
            clínico o fisioterapeuta.
          </p>

          <p>
            <strong class="text-white">2.2. Obligaciones del Usuario:</strong>
            Al utilizar la plataforma, el usuario se compromete a:
          </p>
          <ul class="list-disc pl-5 space-y-2 text-neutral-400">
            <li>
              Proporcionar información médica, física y nutricional veraz,
              completa y actualizada. La omisión de enfermedades crónicas o
              lesiones es responsabilidad exclusiva del usuario.
            </li>
            <li>
              Consultar a un profesional de la salud antes de iniciar cualquier
              programa de ejercicios o dieta, especialmente si padece
              enfermedades cardíacas, metabólicas o limitaciones físicas graves.
            </li>
          </ul>

          <p>
            <strong class="text-white"
              >2.3. Deslinde de Responsabilidad (Exención de Responsabilidad
              Médica y Física):</strong
            >
            lionsssacademy.com.mx y sus desarrolladores no se hacen responsables
            por:
          </p>
          <ul class="list-disc pl-5 space-y-2 text-neutral-400">
            <li>
              Lesiones físicas, daños a la salud, descompensaciones o cualquier
              efecto adverso derivado de la ejecución de las rutinas de
              entrenamiento.
            </li>
            <li>
              Reacciones alérgicas o problemas de salud derivados de no seguir
              correctamente las indicaciones del plan alimenticio, o por la
              falta de divulgación de intolerancias/alergias en el formulario de
              registro.
            </li>
            <li>
              El uso indebido de la plataforma, la sobreexigencia física o la
              falta de técnica adecuada al realizar los ejercicios sugeridos. El
              usuario asume el 100% del riesgo asociado con la realización de
              las actividades físicas y el seguimiento de las sugerencias
              nutricionales.
            </li>
          </ul>

          <p>
            <strong class="text-white">2.4. Resultados No Garantizados:</strong>
            El éxito del acondicionamiento físico y la alimentación depende de
            factores individuales, constancia y genética. No garantizamos
            resultados específicos, pérdida de peso o ganancia muscular en un
            tiempo determinado.
          </p>
          <p>
            <strong class="text-white"
              >2.5. Jurisdicción y Legislación Aplicable:</strong
            >
            Para la interpretación, cumplimiento y ejecución de los presentes
            términos, las partes se someten expresamente a las leyes federales
            de los Estados Unidos Mexicanos y a la jurisdicción de los
            tribunales competentes en México, renunciando a cualquier otro fuero
            que pudiera corresponderles por razón de sus domicilios presentes o
            futuros.
          </p>
        </div>

        <div
          class="p-5 border-t border-neutral-700 flex justify-end bg-[#222222]"
        >
          <button
            @click="mostrarTerminos = false"
            class="bg-[#202A78] hover:bg-[#1c256b] text-white font-bold py-2 px-6 rounded-lg transition-colors shadow-lg"
          >
            Cerrar y Aceptar
          </button>
        </div>
      </div>
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

/* Nuevas variables para los Términos y Condiciones */
const aceptaTerminos = ref(false);
const mostrarTerminos = ref(false);

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
    guardando.value = true;
    console.log("Iniciando proceso de guardado...");

    // 1. CREAMOS LA CUENTA DE USUARIO
    const numAleatorio = Math.floor(1000 + Math.random() * 9000);
    const passwordTemp = `Lionsss-${numAleatorio}!`;

    const { data: authData, error: authError } = await supabase.auth.signUp({
      email: form.value.correo,
      password: passwordTemp,
      options: {
        data: {
          password_temporal: passwordTemp,
        },
      },
    });
    if (authError) throw authError;
    console.log("Usuario creado correctamente.");

    // 2. CREAMOS EL PERFIL
    const { error: perfilError } = await supabase.from("perfiles").insert([
      {
        id: authData.user.id,
        nombre_completo: form.value.nombre_completo,
        rol: "asesorado",
      },
    ]);
    if (perfilError) throw perfilError;

    // 3. PREPARAMOS Y SANITIZAMOS LOS DATOS
    const datosActualizados = {
      ...form.value,
      id_auth: authData.user.id,
      estado_registro: "completado",
    };

    // --- CORRECCIÓN: Evitamos enviar textos vacíos ("") a campos tipo Date en Supabase ---
    if (datosActualizados.fecha_nacimiento === "") {
      datosActualizados.fecha_nacimiento = null;
    }
    if (datosActualizados.fecha_proximo_periodo === "") {
      datosActualizados.fecha_proximo_periodo = null;
    }

    // 4. ACTUALIZAMOS EL EXPEDIENTE EN LA TABLA ASESORADOS
    const { error: updateError } = await supabase
      .from("asesorados")
      .update(datosActualizados)
      .eq("token_registro", tokenActual.value);

    if (updateError) throw updateError;

    // ÉXITO TOTAL
    registroCompletado.value = true;
    console.log("Expediente guardado y usuario registrado.");
  } catch (error) {
    console.error("Error en el registro:", error);
    Swal.fire("Error", "Hubo un problema: " + error.message, "error");
  } finally {
    guardando.value = false;
  }
};
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
  /* Actualizado al azul institucional */
  border-color: #202a78;
}

/* Animación opcional para la entrada del modal */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.animate-fade-in-up {
  animation: fadeInUp 0.3s ease-out forwards;
}
</style>
