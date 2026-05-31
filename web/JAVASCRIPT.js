// Lógica del sitio web BookFlow

// Función para gestionar la suscripción del boletín informativo
function suscribirse() {
    // Soportar tanto "caja-correo" como "emailInput"
    var correoInput = document.getElementById("caja-correo") || document.getElementById("emailInput");
    // Soportar tanto "mensaje-suscripcion" como "msg-suscripcion"
    var mensajeSpan = document.getElementById("mensaje-suscripcion") || document.getElementById("msg-suscripcion");
    
    if (!correoInput || !mensajeSpan) return;

    var correo = correoInput.value.trim();
    
    if (correo === "" || !correo.includes("@")) {
        mensajeSpan.textContent = "Por favor, escribe un correo válido con @.";
        mensajeSpan.style.color = "#ff8585"; // Un color rojo más agradable y legible sobre fondo verde
    } else {
        mensajeSpan.textContent = "¡Gracias por suscribirte!";
        mensajeSpan.style.color = "#ffffff";
        correoInput.value = "";
    }
}

// Función para gestionar el envío del formulario de contacto
function enviarMensaje() {
    // Soportar tanto "mensaje-formulario" como "msg-formulario"
    var mensajeSpan = document.getElementById("mensaje-formulario") || document.getElementById("msg-formulario");
    
    if (mensajeSpan) {
        mensajeSpan.textContent = "¡Mensaje enviado correctamente! Te responderemos pronto.";
        mensajeSpan.style.color = "var(--color-verde)";
    }
}

// Escuchar eventos al cargar el DOM de forma limpia y moderna
document.addEventListener("DOMContentLoaded", function() {
    // Asociar botón de suscripción
    var btnSuscribir = document.getElementById("btn-suscribir");
    if (btnSuscribir) {
        btnSuscribir.addEventListener("click", function(e) {
            e.preventDefault();
            suscribirse();
        });
    }

    // Asociar botón de formulario de contacto
    var btnFormulario = document.getElementById("btn-formulario");
    if (btnFormulario) {
        btnFormulario.addEventListener("click", function(e) {
            e.preventDefault();
            enviarMensaje();
        });
    }

    // Inicializar observador para animaciones al hacer scroll
    var observador = new IntersectionObserver(function(entradas) {
        for (var i = 0; i < entradas.length; i++) {
            if (entradas[i].isIntersecting) {
                entradas[i].target.classList.add("visible");
            }
        }
    }, { threshold: 0.1 });

    var elementos = document.querySelectorAll(".animar");
    for (var i = 0; i < elementos.length; i++) {
        observador.observe(elementos[i]);
    }
});