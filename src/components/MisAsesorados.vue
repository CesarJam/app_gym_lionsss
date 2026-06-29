<template>
  <div class="font-montserrat">
    <!-- VISTA PRINCIPAL (LISTA) -->
    <div v-if="!asesoradoSeleccionadoId">
      <!-- HEADER RESPONSIVO -->
      <header
        class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8"
      >
        <div>
          <h2
            class="text-2xl md:text-3xl font-black uppercase text-[#FAFAFA] tracking-tight m-0"
          >
            Mis <span class="text-[#D4D4D4]">Asesorados</span>
          </h2>
          <p
            class="text-[#888888] text-xs sm:text-sm mt-1 uppercase tracking-wider font-bold"
          >
            Genera enlaces y administra expedientes
          </p>
        </div>
        <button
          class="w-full sm:w-auto px-6 py-3 rounded-full font-extrabold text-sm uppercase tracking-wide transition-all duration-300 shadow-lg"
          :class="
            mostrarFormulario
              ? 'border-2 border-[#D4D4D4] text-[#D4D4D4] hover:bg-[#202A78] hover:border-[#202A78] hover:text-white'
              : 'bg-[#D4D4D4] text-[#222222] hover:bg-[#202A78] hover:text-white hover:-translate-y-1 hover:shadow-[0_0_20px_rgba(32,42,120,0.6)]'
          "
          @click="mostrarFormulario = !mostrarFormulario"
        >
          {{ mostrarFormulario ? "Cancelar Registro" : "+ Nuevo Asesorado" }}
        </button>
      </header>

      <!-- FORMULARIO RÁPIDO -->
      <div
        v-if="mostrarFormulario"
        class="bg-[#171717] p-6 rounded-xl mb-8 border border-[#3B3B3B] shadow-2xl transition-all duration-300"
      >
        <h3
          class="mt-0 mb-2 text-[#D4D4D4] font-black uppercase tracking-widest text-sm"
        >
          Alta Rápida
        </h3>
        <p class="text-xs text-[#888888] mb-5 border-b border-[#3B3B3B] pb-3">
          Solo necesitas su nombre. El sistema generará un enlace para que el
          cliente llene el resto de su información.
        </p>

        <form
          @submit.prevent="guardarAsesorado"
          class="flex flex-col sm:flex-row gap-4 items-end"
        >
          <div class="flex flex-col flex-grow w-full">
            <label
              class="text-xs font-bold text-[#888888] mb-2 uppercase tracking-wide"
              >Nombre Completo del Cliente</label
            >
            <input
              type="text"
              v-model="nuevoNombre"
              placeholder="Ej. María Sánchez"
              required
              class="w-full p-3 bg-[#222222] border border-[#3B3B3B] rounded-lg text-[#EEEEEE] placeholder-[#555555] focus:outline-none focus:border-[#D4D4D4] focus:ring-1 focus:ring-[#D4D4D4] transition-colors"
            />
          </div>
          <div class="w-full sm:w-auto">
            <button
              type="submit"
              :disabled="cargando"
              class="w-full sm:w-auto bg-[#D4D4D4] hover:bg-[#202A78] hover:text-white text-[#222222] font-extrabold uppercase tracking-wide py-3 px-6 rounded-lg transition duration-300 disabled:opacity-50 disabled:cursor-not-allowed flex justify-center items-center gap-2"
            >
              <svg
                v-if="cargando"
                class="animate-spin h-5 w-5 text-current"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
              >
                <circle
                  class="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  stroke-width="4"
                ></circle>
                <path
                  class="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                ></path>
              </svg>
              {{ cargando ? "Generando..." : "Generar Enlace" }}
            </button>
          </div>
        </form>
      </div>

      <!-- LISTA (Tarjetas en Móvil, Tabla en Escritorio) -->
      <div class="bg-[#171717] rounded-xl shadow-xl border border-[#3B3B3B]">
        <!-- Vista de Escritorio (Tabla) -->
        <div class="hidden md:block overflow-visible">
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="bg-[#222222]">
                <th
                  class="text-[#888888] font-bold text-xs uppercase tracking-wider p-4 border-b border-[#3B3B3B] rounded-tl-xl"
                >
                  Nombre
                </th>
                <th
                  class="text-[#888888] font-bold text-xs uppercase tracking-wider p-4 border-b border-[#3B3B3B]"
                >
                  Estado
                </th>
                <th
                  class="text-[#888888] font-bold text-xs uppercase tracking-wider p-4 border-b border-[#3B3B3B]"
                >
                  Enlace de Registro
                </th>
                <th
                  class="text-[#888888] font-bold text-xs uppercase tracking-wider p-4 border-b border-[#3B3B3B] text-center"
                >
                  WhatsApp
                </th>
                <th
                  class="text-[#888888] font-bold text-xs uppercase tracking-wider p-4 border-b border-[#3B3B3B] text-center rounded-tr-xl"
                >
                  Acciones
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="asesorados.length === 0">
                <td
                  colspan="5"
                  class="p-8 text-center text-[#555555] font-bold uppercase tracking-widest"
                >
                  No tienes asesorados registrados aún.
                </td>
              </tr>
              <tr
                v-for="cliente in asesorados"
                :key="cliente.id"
                class="hover:bg-[#222222]/50 transition duration-150"
              >
                <td
                  class="p-4 border-b border-[#3B3B3B] text-[#EEEEEE] font-bold"
                >
                  {{ cliente.nombre_completo }}
                </td>
                <td class="p-4 border-b border-[#3B3B3B]">
                  <span
                    :class="[
                      'px-3 py-1 rounded-full text-[10px] uppercase font-black tracking-widest border',
                      cliente.estado_registro === 'completado'
                        ? 'bg-green-500/10 text-green-400 border-green-500/20'
                        : 'bg-amber-500/10 text-amber-400 border-amber-500/20',
                    ]"
                  >
                    {{ cliente.estado_registro }}
                  </span>
                </td>
                <td class="p-4 border-b border-[#3B3B3B]">
                  <button
                    v-if="cliente.estado_registro === 'pendiente'"
                    @click="copiarEnlace(cliente.token_registro)"
                    class="flex items-center gap-2 text-xs font-bold uppercase tracking-wide bg-[#222222] hover:bg-[#D4D4D4] text-[#D4D4D4] hover:text-[#222222] border border-[#555555] py-2 px-4 rounded-lg transition-colors"
                  >
                    <svg
                      class="w-4 h-4"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M15.666 3.888A2.25 2.25 0 0013.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 01-.75.75H9a.75.75 0 01-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 01-2.25 2.25H6.75A2.25 2.25 0 014.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 011.927-.184"
                      />
                    </svg>
                    <span>Copiar Enlace</span>
                  </button>
                  <span
                    v-else
                    class="text-xs font-bold uppercase tracking-wide text-[#888888] flex items-center gap-2"
                  >
                    <svg
                      class="w-5 h-5 text-[#202A78]"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                      />
                    </svg>
                    Formulario llenado
                  </span>
                </td>

                <!-- NUEVA COLUMNA: WHATSAPP -->
                <td class="p-4 border-b border-[#3B3B3B] text-center">
                  <button
                    v-if="cliente.estado_registro === 'pendiente'"
                    @click="enviarWhatsApp(cliente)"
                    class="inline-flex items-center justify-center gap-2 text-xs font-bold uppercase tracking-wide bg-[#25D366]/10 hover:bg-[#25D366] text-[#25D366] hover:text-white border border-[#25D366]/50 hover:border-[#25D366] py-2 px-4 rounded-lg transition-colors w-full md:w-auto"
                  >
                    <svg
                      class="w-4 h-4"
                      fill="currentColor"
                      viewBox="0 0 16 16"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      <path
                        d="M13.601 2.326A7.854 7.854 0 0 0 7.994 0C3.627 0 .068 3.558.064 7.926c0 1.399.366 2.76 1.057 3.965L0 16l4.204-1.102a7.933 7.933 0 0 0 3.79.965h.004c4.368 0 7.926-3.558 7.93-7.93A7.898 7.898 0 0 0 13.6 2.326zM7.994 14.521a6.573 6.573 0 0 1-3.356-.92l-.24-.144-2.494.654.666-2.433-.156-.251a6.56 6.56 0 0 1-1.007-3.505c0-3.626 2.957-6.584 6.591-6.584a6.56 6.56 0 0 1 4.66 1.931 6.557 6.557 0 0 1 1.928 4.66c-.004 3.639-2.961 6.592-6.592 6.592zm3.615-4.934c-.197-.099-1.17-.578-1.353-.646-.182-.065-.315-.099-.445.099-.133.197-.513.646-.627.775-.114.133-.232.148-.43.05-.197-.1-.836-.308-1.592-.985-.59-.525-.985-1.175-1.103-1.372-.114-.198-.011-.304.088-.403.087-.088.197-.232.296-.346.1-.114.133-.198.198-.33.065-.134.034-.248-.015-.347-.05-.099-.445-1.076-.612-1.47-.16-.389-.323-.335-.445-.34-.114-.007-.247-.007-.38-.007a.729.729 0 0 0-.529.247c-.182.198-.691.677-.691 1.654 0 .977.71 1.916.81 2.049.098.133 1.394 2.132 3.383 2.992.47.205.84.326 1.129.418.475.152.904.129 1.246.08.38-.058 1.171-.48 1.338-.943.164-.464.164-.86.114-.943-.049-.084-.182-.133-.38-.232z"
                      />
                    </svg>
                    Enviar
                  </button>
                </td>

                <td class="p-4 border-b border-[#3B3B3B] text-center relative">
                  <!-- MENÚ DE 3 PUNTOS AQUÍ (Permanece igual) -->
                  <div
                    v-if="menuAbierto === cliente.id"
                    @click="cerrarMenu"
                    class="fixed inset-0 z-10 cursor-default"
                  ></div>
                  <button
                    @click="toggleMenu(cliente.id)"
                    class="text-[#888888] hover:text-[#FAFAFA] transition p-2 relative z-20 rounded-lg hover:bg-[#222222]"
                  >
                    <svg
                      class="w-6 h-6"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"
                      ></path>
                    </svg>
                  </button>

                  <div
                    v-if="menuAbierto === cliente.id"
                    class="absolute right-12 top-10 w-48 bg-[#222222] border border-[#555555] rounded-xl shadow-2xl z-30 py-2 text-left overflow-hidden"
                  >
                    <button
                      v-if="cliente.estado_registro === 'completado'"
                      @click="abrirExpediente(cliente.id)"
                      class="w-full text-left px-4 py-3 text-xs font-bold uppercase tracking-wide text-[#D4D4D4] hover:bg-[#3B3B3B] hover:text-[#FAFAFA] transition flex items-center gap-3"
                    >
                      <svg
                        class="w-4 h-4 text-[#888888]"
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="2"
                        stroke="currentColor"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"
                        />
                      </svg>
                      Ver Expediente
                    </button>
                    <hr
                      v-if="cliente.estado_registro === 'completado'"
                      class="border-[#3B3B3B] my-1"
                    />
                    <button
                      @click="eliminarAsesorado(cliente.id)"
                      class="w-full text-left px-4 py-3 text-xs font-bold uppercase tracking-wide text-red-500 hover:bg-[#3B3B3B] hover:text-red-400 transition flex items-center gap-3"
                    >
                      <svg
                        class="w-4 h-4"
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="2"
                        stroke="currentColor"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"
                        />
                      </svg>
                      Eliminar
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Vista Móvil (Tarjetas Apiladas) -->
        <div class="md:hidden flex flex-col divide-y divide-[#3B3B3B]">
          <div
            v-if="asesorados.length === 0"
            class="p-8 text-center text-[#555555] font-bold uppercase tracking-widest text-sm"
          >
            No tienes asesorados registrados aún.
          </div>
          <div
            v-for="cliente in asesorados"
            :key="'mob-' + cliente.id"
            class="p-4 flex flex-col gap-4 relative"
          >
            <div class="flex justify-between items-start">
              <div>
                <h4 class="text-lg font-bold text-[#EEEEEE] m-0">
                  {{ cliente.nombre_completo }}
                </h4>
                <div class="mt-2">
                  <span
                    :class="[
                      'px-3 py-1 rounded-full text-[10px] uppercase font-black tracking-widest border inline-block',
                      cliente.estado_registro === 'completado'
                        ? 'bg-green-500/10 text-green-400 border-green-500/20'
                        : 'bg-amber-500/10 text-amber-400 border-amber-500/20',
                    ]"
                  >
                    {{ cliente.estado_registro }}
                  </span>
                </div>
              </div>

              <!-- MENÚ DE 3 PUNTOS (Móvil) -->
              <div class="relative">
                <button
                  @click="toggleMenu('mob-' + cliente.id)"
                  class="text-[#888888] hover:text-[#FAFAFA] p-1 rounded-lg bg-[#222222] border border-[#3B3B3B]"
                >
                  <svg
                    class="w-6 h-6"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"
                    ></path>
                  </svg>
                </button>

                <div
                  v-if="menuAbierto === 'mob-' + cliente.id"
                  @click="cerrarMenu"
                  class="fixed inset-0 z-10 cursor-default"
                ></div>

                <div
                  v-if="menuAbierto === 'mob-' + cliente.id"
                  class="absolute right-0 top-10 w-48 bg-[#222222] border border-[#555555] rounded-xl shadow-2xl z-30 py-2 text-left overflow-hidden"
                >
                  <button
                    v-if="cliente.estado_registro === 'completado'"
                    @click="abrirExpediente(cliente.id)"
                    class="w-full text-left px-4 py-3 text-xs font-bold uppercase tracking-wide text-[#D4D4D4] hover:bg-[#3B3B3B] transition flex items-center gap-3"
                  >
                    <svg
                      class="w-4 h-4 text-[#888888]"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"
                      />
                    </svg>
                    Ver Expediente
                  </button>
                  <hr
                    v-if="cliente.estado_registro === 'completado'"
                    class="border-[#3B3B3B] my-1"
                  />
                  <button
                    @click="eliminarAsesorado(cliente.id)"
                    class="w-full text-left px-4 py-3 text-xs font-bold uppercase tracking-wide text-red-500 hover:bg-[#3B3B3B] transition flex items-center gap-3"
                  >
                    <svg
                      class="w-4 h-4"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"
                      />
                    </svg>
                    Eliminar
                  </button>
                </div>
              </div>
            </div>

            <!-- Zona inferior de la tarjeta -->
            <div class="pt-2 border-t border-[#3B3B3B]">
  <div v-if="cliente.estado_registro === 'pendiente'" class="flex flex-col sm:flex-row gap-3">
    <!-- Botón Copiar Original -->
    <button
      @click="copiarEnlace(cliente.token_registro)"
      class="w-full flex justify-center items-center gap-2 text-xs font-bold uppercase tracking-wide bg-[#222222] hover:bg-[#D4D4D4] text-[#D4D4D4] hover:text-[#222222] border border-[#555555] py-3 rounded-lg transition-colors"
    >
      <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" d="M15.666 3.888A2.25 2.25 0 0013.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 01-.75.75H9a.75.75 0 01-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 01-2.25 2.25H6.75A2.25 2.25 0 014.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 011.927-.184" />
      </svg>
      Copiar
    </button>
    
    <!-- Botón WhatsApp Móvil -->
    <button
      @click="enviarWhatsApp(cliente)"
      class="w-full flex justify-center items-center gap-2 text-xs font-bold uppercase tracking-wide bg-[#25D366]/10 hover:bg-[#25D366] text-[#25D366] hover:text-white border border-[#25D366]/50 hover:border-[#25D366] py-3 rounded-lg transition-colors"
    >
      <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
        <path d="M13.601 2.326A7.854 7.854 0 0 0 7.994 0C3.627 0 .068 3.558.064 7.926c0 1.399.366 2.76 1.057 3.965L0 16l4.204-1.102a7.933 7.933 0 0 0 3.79.965h.004c4.368 0 7.926-3.558 7.93-7.93A7.898 7.898 0 0 0 13.6 2.326zM7.994 14.521a6.573 6.573 0 0 1-3.356-.92l-.24-.144-2.494.654.666-2.433-.156-.251a6.56 6.56 0 0 1-1.007-3.505c0-3.626 2.957-6.584 6.591-6.584a6.56 6.56 0 0 1 4.66 1.931 6.557 6.557 0 0 1 1.928 4.66c-.004 3.639-2.961 6.592-6.592 6.592zm3.615-4.934c-.197-.099-1.17-.578-1.353-.646-.182-.065-.315-.099-.445.099-.133.197-.513.646-.627.775-.114.133-.232.148-.43.05-.197-.1-.836-.308-1.592-.985-.59-.525-.985-1.175-1.103-1.372-.114-.198-.011-.304.088-.403.087-.088.197-.232.296-.346.1-.114.133-.198.198-.33.065-.134.034-.248-.015-.347-.05-.099-.445-1.076-.612-1.47-.16-.389-.323-.335-.445-.34-.114-.007-.247-.007-.38-.007a.729.729 0 0 0-.529.247c-.182.198-.691.677-.691 1.654 0 .977.71 1.916.81 2.049.098.133 1.394 2.132 3.383 2.992.47.205.84.326 1.129.418.475.152.904.129 1.246.08.38-.058 1.171-.48 1.338-.943.164-.464.164-.86.114-.943-.049-.084-.182-.133-.38-.232z"/>
      </svg>
      Enviar
    </button>
  </div>
  
  <!-- Mensaje Formulario Llenado (Sin cambios) -->
  <span
    v-else
    class="text-xs font-bold uppercase tracking-wide text-[#888888] flex items-center justify-center gap-2 py-2"
  >
    <svg class="w-5 h-5 text-[#202A78]" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
    Formulario llenado exitosamente
  </span>
</div>
          </div>
        </div>
      </div>
    </div>

    <!-- VISTA SECUNDARIA (EXPEDIENTE) -->
    <div v-else>
      <ExpedienteAsesorado
        :idAsesorado="asesoradoSeleccionadoId"
        @volver="asesoradoSeleccionadoId = null"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { supabase } from "../supabase.js";
import Swal from "sweetalert2";
import ExpedienteAsesorado from "./ExpedienteAsesorado.vue";

const mostrarFormulario = ref(false);
const cargando = ref(false);
const asesorados = ref([]);
const nuevoNombre = ref("");
const miEntrenadorId = ref(null);

const asesoradoSeleccionadoId = ref(null);
const menuAbierto = ref(null);

onMounted(async () => {
  await obtenerMiId();
  await cargarAsesorados();
});

const obtenerMiId = async () => {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (user) {
    miEntrenadorId.value = user.id;
  }
};

const cargarAsesorados = async () => {
  if (!miEntrenadorId.value) return;
  try {
    const { data, error } = await supabase
      .from("asesorados")
      .select("*")
      .eq("id_entrenador", miEntrenadorId.value)
      .order("fecha_creacion", { ascending: false });

    if (error) throw error;
    asesorados.value = data;
  } catch (error) {
    console.error("Error al cargar:", error.message);
  }
};

const guardarAsesorado = async () => {
  if (!nuevoNombre.value.trim()) return;
  try {
    cargando.value = true;
    const { error } = await supabase.from("asesorados").insert([
      {
        nombre_completo: nuevoNombre.value,
        id_entrenador: miEntrenadorId.value,
      },
    ]);

    if (error) throw error;

    Swal.fire({
      title: "¡Generado!",
      text: "El registro se creó con éxito. Ya puedes copiar su enlace.",
      icon: "success",
      background: "#171717",
      color: "#FAFAFA",
      timer: 2500,
      showConfirmButton: false,
    });

    nuevoNombre.value = "";
    mostrarFormulario.value = false;
    await cargarAsesorados();
  } catch (error) {
    Swal.fire({
      title: "Error",
      text: error.message,
      icon: "error",
      background: "#171717",
      color: "#FAFAFA",
    });
  } finally {
    cargando.value = false;
  }
};

const copiarEnlace = (token) => {
  const urlBase = window.location.origin;
  const enlaceMagico = `${urlBase}/registro/${token}`;

  navigator.clipboard.writeText(enlaceMagico).then(() => {
    Swal.fire({
      toast: true,
      position: "top-end",
      icon: "success",
      title: "¡Enlace copiado!",
      showConfirmButton: false,
      timer: 2500,
      background: "#171717",
      color: "#FAFAFA",
    });
  });
};

const enviarWhatsApp = (cliente) => {
  const urlBase = window.location.origin;
  const enlaceMagico = `https://lionsssacademy.com.mx/registro/${cliente.token_registro}`;

  // Construye el texto con espacios y saltos de línea codificados correctamente para URLs
  const textoMensaje = `¡Hola, ${cliente.nombre_completo}! Aquí tienes tu enlace de registro para Lionsss Academy:\n\n${enlaceMagico}`;
  const urlWhatsapp = `https://api.whatsapp.com/send?text=${encodeURIComponent(textoMensaje)}`;

  // Abre WhatsApp Web (o la App si están en móvil) en una nueva pestaña
  window.open(urlWhatsapp, "_blank");
};

const toggleMenu = (id) => {
  if (menuAbierto.value === id) {
    menuAbierto.value = null;
  } else {
    menuAbierto.value = id;
  }
};

const cerrarMenu = () => {
  menuAbierto.value = null;
};

const abrirExpediente = (id) => {
  cerrarMenu();
  asesoradoSeleccionadoId.value = id;
};

const eliminarAsesorado = async (id) => {
  cerrarMenu();
  const result = await Swal.fire({
    title: "¿Estás seguro?",
    text: "Se borrará este registro por completo.",
    icon: "warning",
    showCancelButton: true,
    background: "#171717",
    color: "#FAFAFA",
    confirmButtonColor: "#ef4444",
    cancelButtonColor: "#3B3B3B",
    confirmButtonText: "Sí, borrar",
    cancelButtonText: "Cancelar",
  });

  if (result.isConfirmed) {
    const { error } = await supabase.from("asesorados").delete().eq("id", id);
    if (!error) {
      Swal.fire({
        title: "Eliminado",
        text: "El registro ha sido borrado.",
        icon: "success",
        background: "#171717",
        color: "#FAFAFA",
        confirmButtonColor: "#D4D4D4",
        customClass: {
          confirmButton: "text-[#222222] font-bold px-6 py-2 rounded-full",
        },
      });
      await cargarAsesorados();
    }
  }
};
</script>
