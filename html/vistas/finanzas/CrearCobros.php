<div class="container mt-5">
    <h2 class="mb-4">Formulario de Pago de Servicio</h2>
    <form action="procesar_pago_servicio.php" method="POST" class="needs-validation" novalidate>
        <div class="mb-3">
            <label for="pagser_per_codigo" class="form-label">Cliente</label>
            <select class="form-select" name="pagser_per_codigo" id="pagser_per_codigo" required>
                <option value="">Seleccione un cliente</option>
                <option value="1">Cliente 1</option>
                <option value="2">Cliente 2</option>
                <option value="3">Cliente 3</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="pagser_ser_codigo" class="form-label">Servicio</label>
            <select class="form-select" name="pagser_ser_codigo" id="pagser_ser_codigo" required>
                <option value="">Seleccione un servicio</option>
                <option value="1">Servicio 1</option>
                <option value="2">Servicio 2</option>
                <option value="3">Servicio 3</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="pagser_monto" class="form-label">Monto</label>
            <input type="number" class="form-control" id="pagser_monto" name="pagser_monto" step="0.01" required>
        </div>
        <div class="mb-3">
            <label for="pagser_fecha_ini" class="form-label">Fecha Inicio</label>
            <input type="datetime-local" class="form-control" id="pagser_fecha_ini" name="pagser_fecha_ini" required>
        </div>
        <div class="mb-3">
            <label for="pagser_fecha_fin" class="form-label">Fecha Fin</label>
            <input type="datetime-local" class="form-control" id="pagser_fecha_fin" name="pagser_fecha_fin" required>
        </div>
        <div class="mb-3">
            <label for="pagser_total" class="form-label">Monto Total</label>
            <input type="number" class="form-control" id="pagser_total" name="pagser_total" step="0.01" required>
        </div>
        <div class="mb-3">
            <label for="pagser_descripcion" class="form-label">Descripción</label>
            <textarea class="form-control" id="pagser_descripcion" name="pagser_descripcion" rows="3" required></textarea>
        </div>
        <div class="mb-3">
            <label for="pagser_pag_tipo_id" class="form-label">Tipo de Pago</label>
            <select class="form-select" name="pagser_pag_tipo_id" id="pagser_pag_tipo_id" required>
                <option value="">Seleccione un tipo</option>
                <option value="1">Por día</option>
                <option value="2">Por semana</option>
                <option value="3">Por quincena</option>
                <option value="4">Por mes</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="pagser_meto_pago_id" class="form-label">Método de Pago</label>
            <select class="form-select" name="pagser_meto_pago_id" id="pagser_meto_pago_id" required>
                <option value="">Seleccione un método</option>
                <option value="1">Efectivo</option>
                <option value="2">Tarjeta</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="pagser_situacion" class="form-label">Situación</label>
            <select class="form-select" name="pagser_situacion" id="pagser_situacion" required>
                <option value="">Seleccione una situación</option>
                <option value="1">Cobro</option>
                <option value="2">Pago</option>
                <option value="0">Inactivo</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Guardar</button>
    </form>
</div>