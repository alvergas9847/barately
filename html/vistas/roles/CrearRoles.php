<div class="container my-5">
    <?php if (isset($titulo) && $titulo <> "Registrar"){ ?>
    <h2 class="text-center mb-4"><?php echo $titulo; ?> los datos de Roles</h2>

 
<!-- Alerta de éxito -->
<div id="successAlert" class="alert alert-success alert-dismissible fade" role="alert" style="display: none;">
    Los datos fueron grabados exitosamente.
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>

 

    <form action="?c=roles&a=Guardar" method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>
        <!-- rol__codigo -->
        <div class="mb-3">
            <input type="hidden" class="form-control"  name="RolId" maxlength="3" value="<?php echo($regresa->getRol_id()); ?>" required>
        </div>
    <!-- Nombres -->
        <div class="mb-3">
            <label for="RolNom" required class="form-label">Nombre</label>
            <input type="text" class="form-control"  name="RolNom" maxlength="100" value="<?php echo($regresa->getRol_nombre()); ?>" required>
            <div class="invalid-feedback">Por favor ingrese el nombre.</div>
        </div>
        <!-- descripcion -->
        <div class="mb-3">
            <label for="RolDesc" required  class="form-label">Descripcion</label>
            <input type="text" class="form-control"  name="RolDesc" maxlength="100" value="<?php echo($regresa->getRol_descripcion()); ?>" required>
            <div class="invalid-feedback">Por favor ingrese la descripcion.</div>
        </div>

     <!-- situacion -->
        <div class="mb-3">
            <label for="RolSituacion" class="form-label">Estado</label>
            <select class="form-select" name="RolSit" >
                <option name="RolSit" value="0" <?= $regresa->getRol_situacion() == 0 ? 'selected' : '' ?>>Inactivo</option>
                <option name="RolSit" value="1" <?= $regresa->getRol_situacion() == 1 ? 'selected' : '' ?>>Activo</option>
            </select>
            <div class="invalid-feedback">Seleccione la Situacion.</div>

        </div>
               <!-- Botón Enviar -->
        <div class="text-center">
            <button type="submit" class="btn btn-outline-warning">Editar</button>
            <button type="reset" class="btn btn-secondary">Limpiar</button>
        </div>
    </form>

<?php }else { ?>
    <h2 class="text-center mb-4"><?php echo $titulo; ?> los Roles </h2>

 
    <div class="alert alert-success" role="alert" style="display: none;"></div>
<div class="alert alert-danger" role="alert" style="display: none;"></div>

        <!-- Mostrar errores si existen -->
       
          

    <form action="?c=roles&a=Guardar" method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>
        <!-- per_codigo -->
        <div class="mb-3">
            <input type="hidden" class="form-control"  name="RolId" maxlength="3"  required>
        </div>
    <!-- Nombres -->
        <div class="mb-3">
            <label for="RolNom"  class="form-label">Nombres</label>
            <input type="text" class="form-control"  name="RolNom" maxlength="100"  required>
            <div class="invalid-feedback">Por favor ingrese los nombres.</div>
        </div>
       
        <!-- Dirección -->
        <div class="mb-3">
            <label for="RolDesc" class="form-label">Dirección</label>
            <textarea class="form-control"  name="RolDesc" maxlength="255" rows="3" "></textarea>
        </div>
        <!-- Estado -->
        <div class="mb-3">
            <label for="RolSit" class="form-label">Estado</label>
            <select class="form-select" name="RolSit" required>
                <option name="RolSit" value="0" >Inactivo</option>
                <option name="RolSit" value="1" selected>Activo</option>
            </select>
            <div class="invalid-feedback">Seleccione el estado del personal.</div>

        </div>
 
        <!-- Botón Enviar -->
        <div class="text-center">
            <button type="submit" class="btn btn-primary">Registrar</button>
            <button type="reset" class="btn btn-secondary">Limpiar</button>
        </div>
    </form>
<?php } ?>
</div>
