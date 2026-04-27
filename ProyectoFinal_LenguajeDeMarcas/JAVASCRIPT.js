

function suscribirse() {
    var correo = document.getElementById("caja-correo").value;
    var mensaje = document.getElementById("mensaje-suscripcion");
    
    if (correo == "" || !correo.includes("@")) {
        mensaje.textContent = "Por favor, escribe un correo válido con @.";
        mensaje.style.color = "red";
    } else {
        mensaje.textContent = "¡Gracias por suscribirte!";
        mensaje.style.color = "white";
        document.getElementById("caja-correo").value = "";
    }
}

function enviarMensaje() {
    var mensaje = document.getElementById("mensaje-formulario");
    
    if (mensaje) {
        mensaje.textContent = "¡Mensaje enviado correctamente! Te responderemos pronto.";
        mensaje.style.color = "green";
    }
}

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