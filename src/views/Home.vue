<template>
  <!-- Fondo principal aplicado a un div envolvente o al body vía directivas globales. Aquí lo aplicamos al contenedor principal -->
  <div
    class="min-h-screen bg-[#222222] text-[#FAFAFA] font-montserrat overflow-x-hidden"
  >
    <!-- NAVBAR -->
    <nav
      class="fixed top-0 left-0 w-full z-[9999] bg-black/95 backdrop-blur-md border-b-8 border-[#202A78] flex justify-between items-center px-4 md:px-8 py-3 md:py-4 transition-all duration-300"
    >
      <div class="flex items-center">
        <img
          src="/images/logo.png?v=2"
          alt="Lionsss Academy Logo"
          class="h-12 md:h-16 w-auto transition-transform duration-300 hover:scale-105"
        />
      </div>

      <button
        class="md:hidden text-[#D4D4D4] text-3xl focus:outline-none z-[10000]"
        @click="toggleMenu"
        aria-label="Menú"
      >
        &#9776;
      </button>

      <div
        :class="
          isMenuActive
            ? 'opacity-100 visible translate-y-0'
            : 'opacity-0 invisible -translate-y-4 md:opacity-100 md:visible md:translate-y-0'
        "
        class="absolute top-full left-0 w-full md:w-auto md:static bg-black/98 md:bg-transparent border-b-2 border-[#202A78] md:border-none flex flex-col md:flex-row md:items-center gap-0 md:gap-6 transition-all duration-300 ease-in-out shadow-xl md:shadow-none"
      >
        <div class="p-4 md:p-0 flex flex-col items-center relative">
          <button
            @click="isDropdownOpen = !isDropdownOpen"
            class="inline-flex items-center gap-2 border border-[#D4D4D4] text-[#D4D4D4] font-bold px-6 py-2 rounded-full hover:bg-[#202A78] hover:border-[#202A78] hover:text-white transition-all duration-300 text-lg md:text-sm focus:outline-none"
          >
            Ingresar a la manada
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-4 w-4 transition-transform duration-300"
              :class="isDropdownOpen ? 'rotate-180' : 'rotate-0'"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="3"
                d="M19 9l-7 7-7-7"
              />
            </svg>
          </button>

          <div
            v-show="isDropdownOpen"
            class="md:absolute top-full md:mt-4 mt-2 w-56 bg-[#171717] border border-[#202A78] rounded-xl shadow-[0_4_20px_rgba(32,42,120,0.3)] overflow-hidden flex flex-col z-50 transition-all duration-300"
          >
            <a
              href="/admin/login"
              @click="closeMenu"
              class="px-4 py-3 text-[#D4D4D4] hover:bg-[#202A78] hover:text-white transition-colors duration-200 font-bold text-center border-b border-[#3B3B3B]"
            >
              Cachorro Lionsss
            </a>
            <a
              href="/admin/login"
              @click="closeMenu"
              class="px-4 py-3 text-[#D4D4D4] hover:bg-[#202A78] hover:text-white transition-colors duration-200 font-bold text-center border-b border-[#3B3B3B]"
            >
              Jovén Lionsss
            </a>
            <a
              href="/admin/login"
              @click="closeMenu"
              class="px-4 py-3 text-[#D4D4D4] hover:bg-[#202A78] hover:text-white transition-colors duration-200 font-bold text-center"
            >
              Couch Lionsss
            </a>
          </div>
        </div>
      </div>
    </nav>

    <!-- HERO SECTION -->
    <section
      class="mt-[70px] md:mt-[90px] h-[600px] md:h-[850px] w-full flex items-center justify-center text-center relative px-4 bg-cover bg-center bg-no-repeat"
      style="background-image: url(&quot;/images/portada.png&quot;)"
    >
      <!-- Overlay oscuro -->
      <div
        class="absolute inset-0 bg-gradient-to-b from-[#222222]/60 to-[#222222]/95 z-0"
      ></div>

      <div
        class="relative z-10 max-w-3xl mx-auto flex flex-col items-center text-center"
      >
        <!-- Aumentamos drásticamente el tamaño del texto aquí -->

        <h1
          class="text-3xl sm:text-4xl md:text-6xl lg:text-7xl font-black uppercase leading-tight mb-4 mt-2 text-center"
        >
          <div
            class="split-text-container flex flex-col justify-center items-center gap-2"
          >
            <span class="text-part left text-[#FAFAFA]">BIENVENIDO</span>
            <span class="text-part right text-[#D4D4D4]">A LA MANADA</span>
          </div>
        </h1>

        <p
          class="text-sm sm:text-base md:text-xl mb-8 text-[#BBBBBB] drop-shadow-md max-w-2xl px-2 mt-4"
        >
          La plataforma definitiva para gestionar tu rendimiento, tus socios y
          tu éxito.
        </p>

        <!-- Botones CTA -->
        <div
          class="flex flex-col sm:flex-row w-full sm:w-auto gap-4 justify-center items-center px-4 sm:px-0"
        >
          <router-link
            to="/admin/login"
            class="w-full sm:w-auto px-6 py-4 md:px-10 rounded-md font-extrabold text-sm md:text-base uppercase tracking-wide bg-[#202A78] text-white transition-all duration-300 hover:bg-[#1c256b] hover:-translate-y-1 shadow-[0_0_15px_rgba(32,42,120,0.4)] hover:shadow-[0_0_25px_rgba(32,42,120,0.7)] text-center"
          >
            GESTIONAR GIMNASIO
          </router-link>
        </div>
      </div>
    </section>

    <!-- INFO BAR -->
    <section
      class="bg-[#171717] py-10 px-4 flex flex-col md:flex-row justify-center items-center md:items-start gap-8 md:gap-16 border-b border-[#3B3B3B]"
    >
      <!-- Item 1: Ubicación -->
      <div
        class="flex flex-col sm:flex-row items-center text-center sm:text-left gap-4"
      >
        <div class="text-[#D4D4D4] flex-shrink-0">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            class="w-10 h-10 text-[#202A78]"
          >
            <path
              fill-rule="evenodd"
              d="m11.54 22.351.07.04.028.016a.76.76 0 0 0 .723 0l.028-.015.071-.041a16.975 16.975 0 0 0 1.144-.742 19.58 19.58 0 0 0 2.683-2.282c1.944-1.99 3.963-4.98 3.963-8.827a8.25 8.25 0 0 0-16.5 0c0 3.846 2.02 6.837 3.963 8.827a19.58 19.58 0 0 0 2.682 2.282 16.975 16.975 0 0 0 1.145.742ZM12 13.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        <div>
          <h4 class="text-lg font-bold text-[#EEEEEE]">Ubicación Central</h4>
          <p class="text-sm text-[#888888]">Chilpancingo, Gro.</p>
        </div>
      </div>

      <!-- Item 2: Sistema Online -->
      <div
        class="flex flex-col sm:flex-row items-center text-center sm:text-left gap-4"
      >
        <div class="text-[#D4D4D4] flex-shrink-0">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            class="w-10 h-10 text-[#202A78]"
          >
            <path
              fill-rule="evenodd"
              d="M14.615 1.595a.75.75 0 0 1 .359.852L12.982 9.75h7.268a.75.75 0 0 1 .548 1.262l-10.5 11.25a.75.75 0 0 1-1.272-.71l1.992-7.302H3.75a.75.75 0 0 1-.548-1.262l10.5-11.25a.75.75 0 0 1 .913-.143Z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        <div>
          <h4 class="text-lg font-bold text-[#EEEEEE]">Sistema Online</h4>
          <p class="text-sm text-[#888888]">Disponible 24/7</p>
        </div>
      </div>

      <!-- Item 3: Comunidad -->
      <div
        class="flex flex-col sm:flex-row items-center text-center sm:text-left gap-4"
      >
        <div class="text-[#D4D4D4] flex-shrink-0">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            class="w-10 h-10 text-[#202A78]"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M16.5 18.75h-9m9 0a3 3 0 0 1 3 3h-15a3 3 0 0 1 3-3m9 0v-3.375c0-.621-.503-1.125-1.125-1.125h-.871M7.5 18.75v-3.375c0-.621.504-1.125 1.125-1.125h.872m5.007 0H9.497m5.007 0a7.454 7.454 0 0 1-.982-3.172M9.497 14.25a7.454 7.454 0 0 0 .981-3.172M5.25 4.236c-.982.143-1.954.317-2.916.52A6.003 6.003 0 0 0 7.73 9.728M5.25 4.236V4.5c0 2.108.966 3.99 2.48 5.228M5.25 4.236V2.721C7.456 2.41 9.71 2.25 12 2.25c2.291 0 4.545.16 6.75.47v1.516M7.73 9.728a6.726 6.726 0 0 0 2.748 1.35m8.272-6.842V4.5c0 2.108-.966 3.99-2.48 5.228m2.48-5.492a46.32 46.32 0 0 1 2.916.52 6.003 6.003 0 0 1-5.395 4.972m0 0a6.726 6.726 0 0 1-2.749 1.35m0 0a6.772 6.772 0 0 1-3.044 0"
            />
          </svg>
        </div>
        <div>
          <h4 class="text-lg font-bold text-[#EEEEEE]">Comunidad Lionsss</h4>
          <p class="text-sm text-[#888888]">Solo para campeones</p>
        </div>
      </div>
    </section>

    <!-- GALERÍA / CARRUSEL -->
    <section class="py-16 px-4 text-center bg-[#222222]">
      <h2
        class="text-2xl sm:text-3xl md:text-4xl font-black uppercase mb-10 text-[#FAFAFA]"
      >
        Acerca de...<span class="text-[#D4D4D4]"> </span>
      </h2>

      <div
        class="relative max-w-4xl mx-auto overflow-hidden rounded-xl border border-[#555555] shadow-2xl"
      >
        <!-- Botones Carrusel -->
        <button
          class="absolute left-2 top-1/2 -translate-y-1/2 bg-black/60 hover:bg-[#555555] text-[#FAFAFA] text-2xl px-3 py-2 rounded-lg z-10 transition-colors"
          @click="prevSlide"
        >
          &#10094;
        </button>
        <button
          class="absolute right-2 top-1/2 -translate-y-1/2 bg-black/60 hover:bg-[#555555] text-[#FAFAFA] text-2xl px-3 py-2 rounded-lg z-10 transition-colors"
          @click="nextSlide"
        >
          &#10095;
        </button>

        <!-- Pista del Carrusel -->
        <div
          class="flex transition-transform duration-500 ease-in-out h-[250px] sm:h-[400px] md:h-[500px]"
          :style="carouselStyle"
        >
          <div class="min-w-full h-full">
            <img
              src="/images/carrusel/gym-1.jpg"
              alt="carrusel-01"
              class="w-full h-full object-cover"
            />
          </div>
          <div class="min-w-full h-full">
            <img
              src="/images/carrusel/gym-2.jpg"
              alt="carrusel-02"
              class="w-full h-full object-cover"
            />
          </div>
          <div class="min-w-full h-full">
            <img
              src="/images/carrusel/gym-3.jpg"
              alt="carrusel-03"
              class="w-full h-full object-cover"
            />
          </div>
          <div class="min-w-full h-full">
            <img
              src="/images/carrusel/gym-4.jpg"
              alt="carrusel-04"
              class="w-full h-full object-cover"
            />
          </div>
          <div class="min-w-full h-full">
            <img
              src="/images/carrusel/gym-5.jpg"
              alt="carrusel-05"
              class="w-full h-full object-cover"
            />
          </div>
          <div class="min-w-full h-full">
            <img
              src="/images/carrusel/gym-6.jpg"
              alt="carrusel-06"
              class="w-full h-full object-cover"
            />
          </div>
          <div class="min-w-full h-full">
            <img
              src="/images/carrusel/gym-7.jpg"
              alt="carrusel-07"
              class="w-full h-full object-cover"
            />
          </div>
        </div>
      </div>
    </section>

    <!-- SECCIÓN SOBRE MÍ (ESTILO CV) -->
    <section class="py-16 md:py-24 px-4 bg-[#171717] border-y border-[#3B3B3B]">
      <div class="max-w-6xl mx-auto">
        <!-- Título de la sección -->
        <div class="mb-12 text-center md:text-left md:pl-4 lg:pl-0">
          <h2
            class="text-3xl md:text-4xl lg:text-5xl font-black uppercase tracking-tight text-[#FAFAFA]"
          >
            Sobre <span class="text-[#D4D4D4]">mí</span>
          </h2>
          <div
            class="h-1.5 w-20 bg-[#202A78] mt-4 mx-auto md:mx-0 rounded-full"
          ></div>
        </div>

        <div
          class="flex flex-col md:flex-row items-center md:items-start gap-10 md:gap-16"
        >
          <!-- Columna Izquierda: Fotografía -->
          <div
            class="w-full md:w-1/3 flex justify-center md:justify-end shrink-0"
          >
            <div class="relative group">
              <!-- Sombra decorativa desfasada -->
              <div
                class="absolute inset-0 bg-[#555555] rounded-2xl transform translate-x-4 translate-y-4 opacity-30 transition-transform duration-500 group-hover:translate-x-6 group-hover:translate-y-6"
              ></div>

              <!-- Imagen principal -->
              <img
                src="/images/about/01profile.jpg"
                alt="Perfil de Jonathan Pastor Terrero"
                class="relative rounded-2xl w-64 h-80 md:w-72 md:h-[400px] lg:w-80 lg:h-[450px] object-cover border border-[#3B3B3B] shadow-2xl z-10 filter grayscale group-hover:grayscale-0 transition duration-500"
              />
            </div>
          </div>

          <!-- Columna Derecha: Contenido y Experiencia -->
          <div class="w-full md:w-2/3 flex flex-col justify-center">
            <!-- Encabezado del CV -->
            <div class="mb-6 text-center md:text-left">
              <h3
                class="text-2xl md:text-3xl font-bold text-[#EEEEEE] uppercase tracking-wide"
              >
                Jonathan Pastor Terrero
              </h3>
              <p
                class="text-[#888888] font-bold tracking-widest uppercase text-xs sm:text-sm mt-2"
              >
                Fitness Coaching & Juez Nacional
              </p>
            </div>

            <!-- Texto Descriptivo principal -->
            <div
              class="text-[#BBBBBB] text-base md:text-lg leading-relaxed space-y-5 text-justify md:text-left"
            >
              <p>
                Soy Licenciado en Administración, pero mi verdadera vocación es
                el Fitness Coaching. Mi camino comenzó a los 13 años en un
                gimnasio de lucha libre, evolucionando desde la calistenia hasta
                el entrenamiento de fuerza, donde forjé mi base a través de la
                experiencia empírica y el trabajo duro.
              </p>
              <p>
                Lo que inició en 2017 como asesorías para amigos, se transformó
                en una carrera profesional de alto nivel. Para ofrecerte el
                mejor respaldo, consolidé mi experiencia con certificaciones de
                prestigio internacional. Hoy, fusiono la estructura estratégica
                de la administración con el conocimiento científico y empírico
                del fitness.
              </p>
              <p>
                <strong class="text-[#EEEEEE]">Mi misión</strong> es guiarte
                hacia tu mejor versión física con un plan diseñado bajo los más
                altos estándares de la industria.
              </p>
            </div>

            <!-- Lista de ventajas competitivas (Rompe el muro de texto) -->
            <div class="mt-8">
              <h4
                class="text-[#D4D4D4] font-bold uppercase tracking-widest text-sm mb-4"
              >
                ¿Por qué elegir mi asesoría?
              </h4>
              <ul class="space-y-4">
                <li class="flex items-start gap-3">
                  <svg
                    class="w-6 h-6 text-[#888888] flex-shrink-0 mt-0.5"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                    ></path>
                  </svg>
                  <p
                    class="text-[#BBBBBB] text-sm md:text-base leading-relaxed"
                  >
                    <strong class="text-[#EEEEEE]">Experiencia Real:</strong>
                    Más de una década viviendo la cultura del gimnasio.
                  </p>
                </li>
                <li class="flex items-start gap-3">
                  <svg
                    class="w-6 h-6 text-[#888888] flex-shrink-0 mt-0.5"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"
                    ></path>
                  </svg>
                  <p
                    class="text-[#BBBBBB] text-sm md:text-base leading-relaxed"
                  >
                    <strong class="text-[#EEEEEE]">Respaldo Académico:</strong>
                    Metodologías certificadas en entrenamiento y nutrición.
                  </p>
                </li>
                <li class="flex items-start gap-3">
                  <svg
                    class="w-6 h-6 text-[#888888] flex-shrink-0 mt-0.5"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                    ></path>
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                    ></path>
                  </svg>
                  <p
                    class="text-[#BBBBBB] text-sm md:text-base leading-relaxed"
                  >
                    <strong class="text-[#EEEEEE]">Visión Profesional:</strong>
                    Como Juez Nacional, entiendo exactamente qué se necesita
                    para lograr un físico de excelencia.
                  </p>
                </li>
              </ul>
            </div>

            <!-- Caja destacada de Credenciales -->
            <div
              class="mt-8 p-5 bg-[#222222] border-l-4 border-[#202A78] rounded-r-xl shadow-lg"
            >
              <h4
                class="text-[#EEEEEE] font-black uppercase text-xs tracking-widest mb-2 flex items-center gap-2"
              >
                <svg
                  class="w-4 h-4 text-[#202A78]"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"
                  ></path>
                </svg>
                Áreas de especialización
              </h4>
              <p class="text-[#BBBBBB] text-sm leading-relaxed">
                Entrenador Profesional y Nutricionista Certificado por el
                Instituto Iberoamericano de Acondicionamiento Físico y Fitness
                (IIAFF). Juez Nacional Certificado en FITNESSMANIA MÉXICO.
              </p>
            </div>

            <!-- Etiquetas de Habilidades (Skills actualizadas) -->
            <div
              class="mt-8 flex flex-wrap justify-center md:justify-start gap-3"
            >
              <span
                class="px-4 py-2 bg-[#222222] border border-[#202A78] text-[#D4D4D4] rounded-full text-[10px] sm:text-xs font-bold uppercase tracking-widest hover:bg-[#202A78] hover:text-white transition-colors cursor-default"
              >
                Entrenamiento de Fuerza
              </span>
              <span
                class="px-4 py-2 bg-[#222222] border border-[#202A78] text-[#D4D4D4] rounded-full text-[10px] sm:text-xs font-bold uppercase tracking-widest hover:bg-[#202A78] hover:text-white transition-colors cursor-default"
              >
                Nutrición Deportiva
              </span>
              <span
                class="px-4 py-2 bg-[#222222] border border-[#202A78] text-[#D4D4D4] rounded-full text-[10px] sm:text-xs font-bold uppercase tracking-widest hover:bg-[#202A78] hover:text-white transition-colors cursor-default"
              >
                Juez Nacional
              </span>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- FOOTER -->
    <footer
      class="bg-[#171717] py-8 text-center text-xs md:text-sm text-[#6E6E6E] border-t border-[#3B3B3B]"
    >
      &copy; 2026 Lionsss Academy. Powered by CesarJam94.
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";

// --- LÓGICA DEL MENÚ Y DROPDOWN ---
const isMenuActive = ref(false);
const isDropdownOpen = ref(false); // Nueva variable para el dropdown

const toggleMenu = () => {
  isMenuActive.value = !isMenuActive.value;
  isDropdownOpen.value = false; // Cierra el dropdown si se interactúa con el menú móvil
};

const closeMenu = () => {
  isMenuActive.value = false;
  isDropdownOpen.value = false; // Asegura que se cierre todo al hacer clic en un enlace
};

// --- LÓGICA DEL CARRUSEL ---
const currentSlide = ref(0);
const totalSlides = 7;
const carouselStyle = ref("transform: translateX(0%)");

const updateCarousel = () => {
  const percentage = -currentSlide.value * 100;
  carouselStyle.value = `transform: translateX(${percentage}%)`;
};

const nextSlide = () => {
  currentSlide.value++;
  if (currentSlide.value >= totalSlides) currentSlide.value = 0;
  updateCarousel();
};

const prevSlide = () => {
  currentSlide.value--;
  if (currentSlide.value < 0) currentSlide.value = totalSlides - 1;
  updateCarousel();
};

// Autoplay del carrusel
let interval;
onMounted(() => {
  interval = setInterval(nextSlide, 4000);
});
onUnmounted(() => {
  clearInterval(interval);
});
</script>

<style>
/* Solo importamos la fuente, Tailwind se encarga del resto */
@import url("https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700;900&display=swap");

.font-montserrat {
  font-family: "Montserrat", sans-serif;
}

/* --- EFECTO SLIDE-IN TEXT --- */
.split-text-container {
  overflow: hidden;
  width: 100%;
}

.text-part {
  display: block;
  position: relative;
  transform: translateX(0);
  animation-duration: 5s; /* Ajusté un poco el tiempo para que sea más ágil, puedes volver a 2s si prefieres */
  animation-timing-function: cubic-bezier(
    0.25,
    1,
    0.5,
    1
  ); /* Un easing más suave al frenar */
  animation-fill-mode: forwards;
}

.text-part.left {
  transform: translateX(-200%);
  animation-name: slide-in-left;
}

.text-part.right {
  transform: translateX(200%);
  animation-name: slide-in-right;
}

@keyframes slide-in-left {
  0% {
    transform: translateX(-200%);
  }
  100% {
    transform: translateX(0);
  }
}

@keyframes slide-in-right {
  0% {
    transform: translateX(200%);
  }
  100% {
    transform: translateX(0);
  }
}
</style>
