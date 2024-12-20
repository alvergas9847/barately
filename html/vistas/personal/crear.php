<div class="container my-5">
    <?php if (isset($titulo) && $titulo <> "Registrar"){ ?>
    <h2 class="text-center mb-4"><?php echo $titulo; ?> los datos del Personal</h2>

 
<!-- Alerta de éxito -->
<div id="successAlert" class="alert alert-success alert-dismissible fade" role="alert" style="display: none;">
    Los datos fueron grabados exitosamente.
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>

 

    <form action="?c=personal&a=Guardar" method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>
        <!-- per_codigo -->
        <div class="mb-3">
            <input type="hidden" class="form-control"  name="PerCodigo" maxlength="3" value="<?php echo($regresa->getPer_codigo()); ?>" required>
        </div>
    <!-- Nombres -->
        <div class="mb-3">
            <label for="PerNombres" required class="form-label">Nombres</label>
            <input type="text" class="form-control"  name="PerNombres" maxlength="100" value="<?php echo($regresa->getPer_nombres()); ?>" required>
            <div class="invalid-feedback">Por favor ingrese los nombres.</div>
        </div>
        <!-- Apellidos -->
        <div class="mb-3">
            <label for="PerApellidos" required  class="form-label">Apellidos</label>
            <input type="text" class="form-control"  name="PerApellidos" maxlength="100" value="<?php echo($regresa->getPer_apellidos()); ?>" required>
            <div class="invalid-feedback">Por favor ingrese los apellidos.</div>
        </div>
        <!-- DPI -->
        <div class="mb-3">
            <label for="PerDpi" class="form-label">DPI</label>
            <input type="text" class="form-control"  name="PerDpi" pattern="[0-9]{13}" maxlength="13" value="<?php echo($regresa->getPer_dpi()); ?>" >
            <div class="invalid-feedback">Ingrese un DPI válido de 13 dígitos.</div>
        </div>
        <!-- NIT -->
        <div class="mb-3">
            <label for="PerNit"  class="form-label">NIT</label>
            <input type="text" class="form-control"  name="PerNit" maxlength="9" value="<?php echo($regresa->getPer_nit()); ?>" >
            <div class="invalid-feedback">Ingrese un NIT válido de 9 caracteres.</div>
        </div>
        <!-- Teléfono Principal -->
        <div class="mb-3">
            <label for="PerTel1"   class="form-label">Teléfono Principal</label>
            <input type="tel" class="form-control"  name="PerTel1" pattern="[0-9]{8}" maxlength="8" value="<?php echo($regresa->getPer_tel1()); ?>" >
            <div class="invalid-feedback">Ingrese un teléfono de 8 dígitos.</div>
        </div>
        <!-- Teléfono Secundario -->
        <div class="mb-3">
            <label for="PerTel2" class="form-label">Teléfono Secundario</label>
            <input type="tel" class="form-control"  name="PerTel2" pattern="[0-9]{8}" maxlength="8" value="<?php echo($regresa->getPer_tel2()); ?>" >
            <div class="invalid-feedback">Ingrese un teléfono de 8 dígitos.</div>
        </div>
        <!-- Correo Electrónico -->
        <div class="mb-3">
            <label for="PerMail" class="form-label">Correo Electrónico</label>
            <input type="email" class="form-control"  name="PerMail" maxlength="50" value="<?php echo($regresa->getPer_mail()); ?>">
            <div class="invalid-feedback">Ingrese un correo válido.</div>
        </div>
        <!-- Imagen -->
        <div class="mb-3">
            <label for="PerImagen" class="form-label">Imagen</label>
            <img src="data:image/png;base64,<?php echo base64_encode($regresa->getPer_imagen()); ?>" alt="Imagen de Personal" width="105" height="196" />

           
        </div>
        <!-- Dirección -->
        <div class="mb-3">
            <label for="PerDireccion" class="form-label">Dirección</label>
            <textarea class="form-control" name="PerDireccion" maxlength="255" rows="3"><?php echo($regresa->getPer_direccion()); ?></textarea>
        </div>
    <!-- SITUACION -->
        
    <input type="hidden" name="PerSituacion" value="<?php echo($regresa->getPer_situacion()); ?>">
        <!-- Estado -->
        <div class="mb-3">
            <label for="perRolid" class="form-label">Estado</label>
            <select class="form-select" name="perRolid" >
                <option name="perRolid" value="3" <?= $regresa->getPer_rol_id() == 3 ? 'selected' : '' ?>>Cliente</option>
                <option name="perRolid" value="2" <?= $regresa->getPer_rol_id() == 2 ? 'selected' : '' ?>>Cajero</option>
                <option name="perRolid" value="4" <?= $regresa->getPer_rol_id() == 4 ? 'selected' : '' ?>>Vendedor</option>
                <option name="perRolid" value="1" <?= $regresa->getPer_rol_id() == 1 ? 'selected' : '' ?>>Administrador</option>
                <option name="perRolid" value="5" <?= $regresa->getPer_rol_id() == 5 ? 'selected' : '' ?>>Encargado Almacen</option>
                <option name="perRolid" value="6" <?= $regresa->getPer_rol_id() == 6 ? 'selected' : '' ?>>Contador</option>
            </select>
            <div class="invalid-feedback">Seleccione el estado del personal.</div>

        </div>
        <!-- Fecha actual (campo hidden) -->
        <input type="hidden" name="FechaRegistro" value="<?= date('Y-m-d H:i:s'); ?>">
        <!-- Botón Enviar -->
        <div class="text-center">
            <button type="submit" class="btn btn-primary">Registrar</button>
            <button type="reset" class="btn btn-secondary">Limpiar</button>
        </div>
    </form>

<?php }else { ?>
    <h2 class="text-center mb-4"><?php echo $titulo; ?> los datos del Personal </h2>

 
    <div class="alert alert-success" role="alert" style="display: none;"></div>
<div class="alert alert-danger" role="alert" style="display: none;"></div>

        <!-- Mostrar errores si existen -->
       
          

    <form action="?c=personal&a=Guardar" method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>
        <!-- per_codigo -->
        <div class="mb-3">
            <input type="hidden" class="form-control"  name="PerCodigo" maxlength="3"  >
        </div>
    <!-- Nombres -->
        <div class="mb-3">
            <label for="PerNombres"  class="form-label">Nombres</label>
            <input type="text" class="form-control"  name="PerNombres" maxlength="100"  required>
            <div class="invalid-feedback">Por favor ingrese los nombres.</div>
        </div>
        <!-- Apellidos -->
        <div class="mb-3">
            <label for="PerApellidos"   class="form-label">Apellidos</label>
            <input type="text" class="form-control"  name="PerApellidos" maxlength="100"  required>
            <div class="invalid-feedback">Por favor ingrese los apellidos.</div>
        </div>
        <!-- DPI -->
        <div class="mb-3">
            <label for="PerDpi" class="form-label">DPI</label>
            <input type="text" class="form-control"  name="PerDpi" pattern="[0-9]{13}" maxlength="13"  >
            <div class="invalid-feedback">Ingrese un DPI válido de 13 dígitos.</div>
        </div>
        <!-- NIT -->
        <div class="mb-3">
            <label for="PerNit"  class="form-label">NIT</label>
            <input type="text" class="form-control"  name="PerNit" maxlength="9"  required>
            <div class="invalid-feedback">Ingrese un NIT válido de 9 caracteres.</div>
        </div>
        <!-- Teléfono Principal -->
        <div class="mb-3">
            <label for="PerTel1"   class="form-label">Teléfono Principal</label>
            <input type="tel" class="form-control"  name="PerTel1" pattern="[0-9]{8}" maxlength="8" >
            <div class="invalid-feedback">Ingrese un teléfono de 8 dígitos.</div>
        </div>
        <!-- Teléfono Secundario -->
        <div class="mb-3">
            <label for="PerTel2" class="form-label">Teléfono Secundario</label>
            <input type="tel" class="form-control"  name="PerTel2" pattern="[0-9]{8}" maxlength="8" >
            <div class="invalid-feedback">Ingrese un teléfono de 8 dígitos.</div>
        </div>
        <!-- Correo Electrónico -->
        <div class="mb-3">
            <label for="PerMail" class="form-label">Correo Electrónico</label>
            <input type="email" class="form-control"  name="PerMail" maxlength="50" >
            <div class="invalid-feedback">Ingrese un correo válido.</div>
        </div>
        <!-- Imagen -->
        <div class="mb-3">
            <label for="PerImagen" class="form-label">Imagen</label>
            <input type="file" class="form-control"  name="PerImagen" accept="image/*" ">
        </div>
        <!-- Dirección -->
        <div class="mb-3">
            <label for="PerDireccion" class="form-label">Dirección</label>
            <textarea class="form-control"  name="PerDireccion" maxlength="255" rows="3" "></textarea>
        </div>
        <!-- Estado -->

        <div class="mb-3">
            <label for="perRolid" class="form-label">Estado</label>
            <select class="form-select" name="perRolid" required>
            <?php foreach ($this->modelo->SelectRoles() as $resultado) {
            $rol_id = $resultado->rol_id;
            $rol_nombre = $resultado->rol_nombre; ?>
            <option value="<?php echo $rol_id; ?>" <?php if ($rol_id == 3) { echo 'selected'; } ?>><?php echo $rol_nombre ?></option>
        <?php } ?>                 
            </select>
            <div class="invalid-feedback">Seleccione el estado del personal.</div>

        </div>
        <!-- SITUACION -->
        
        <input type="hidden" name="PerSituacion" value="1">
        </div>
      
        <!-- Fecha actual (campo hidden) -->
        <input type="hidden" name="FechaRegistro" value="<?= date('Y-m-d H:i:s'); ?>">
        <!-- Botón Enviar -->
        <div class="text-center">
            <button type="submit" class="btn btn-primary">Registrar</button>
            <button type="reset" class="btn btn-secondary">Limpiar</button>
        </div>
    </form>
<?php } ?>
</div>
