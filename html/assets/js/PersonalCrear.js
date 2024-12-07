document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('form');
    const successAlert = document.querySelector('.alert-success');
    const errorAlert = document.querySelector('.alert-danger');

    // Ocultar alertas al inicio
    successAlert.style.display = 'none';
    errorAlert.style.display = 'none';

    // Evento submit del formulario
    form.addEventListener('submit', function (event) {
        let isValid = true;
        let errorMessages = [];

        // Limpiar los mensajes de error previos
        document.querySelectorAll('.invalid-feedback').forEach(feedback => {
            feedback.style.display = 'none';
        });

        // Validar cada campo del formulario
        const fields = [
            { 
                name: 'PerNombres', 
                required: true, 
                errorMsg: 'Por favor ingrese los nombres.' 
            },
            { 
                name: 'PerApellidos', 
                required: true, 
                errorMsg: 'Por favor ingrese los apellidos.' 
            },

            { 
                name: 'PerTel1', 
                required: true, 
                regex: /^[0-9]{8}$/, 
                errorMsg: 'Ingrese un teléfono principal de 8 dígitos.' 
            },
            { 
                //name: 'PerMail', 
                //regex: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/, 
               // errorMsg: 'Ingrese un correo electrónico válido.' 
            },
            { 
                name: 'PerSituacion', 
                required: true, 
                errorMsg: 'Seleccione el estado del personal.' 
            }
        ];

        fields.forEach(field => {
            const input = document.querySelector(`[name="${field.name}"]`);

            if (input) {
                if (field.required && !input.value.trim()) {
                    showError(input, field.errorMsg);
                    errorMessages.push(field.errorMsg);
                    isValid = false;
                } else if (field.regex && !field.regex.test(input.value)) {
                    showError(input, field.errorMsg);
                    errorMessages.push(field.errorMsg);
                    isValid = false;
                } else {
                    clearError(input);
                }
            }
        });

        // Si hay errores, mostrar las alertas y prevenir el envío
        if (!isValid) {
            event.preventDefault();
            errorAlert.style.display = 'block';
            successAlert.style.display = 'none';
            errorAlert.textContent = `Error: ${errorMessages.join(' ')}`;
            return;
        }

        // Si todo está bien, mostrar el mensaje de éxito
        successAlert.style.display = 'block';
        errorAlert.style.display = 'none';
        successAlert.textContent = 'Formulario guardado exitosamente.';
    });

    // Función para mostrar errores en los campos
    function showError(input, message) {
        const feedback = input.nextElementSibling;
        if (feedback && feedback.classList.contains('invalid-feedback')) {
            feedback.textContent = message;
            feedback.style.display = 'block';
        }
    }

    // Función para limpiar errores en los campos
    function clearError(input) {
        const feedback = input.nextElementSibling;
        if (feedback && feedback.classList.contains('invalid-feedback')) {
            feedback.style.display = 'none';
        }
    }
});
