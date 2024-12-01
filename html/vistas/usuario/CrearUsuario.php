<div class="container my-5">
    <?php if (isset($titulo) && $titulo <> "Registrar"){ ?>
    <h2 class="text-center mb-4"><?php echo $titulo; ?> los datos de usuario</h2>

    
    <!-- Alerta de éxito -->
    <div id="successAlert" class="alert alert-success alert-dismissible fade" role="alert" style="display: none;">
        Los datos fueron grabados exitosamente.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>

  
 
        <form action="?c=usuario&a=Guardar" method="POST">
            <!-- Código del usuario (Auto Incremento) -->
            <div class="mb-3">
                <label for="usu_codigo" class="form-label">Código de Usuario</label>
                <input type="text" class="form-control" id="usu_codigo" name="usu_codigo" readonly>
            </div>

            <!-- Código del personal (FK) -->
            <div class="mb-3">
                <label for="per_codigo" class="form-label">Código del Personal</label>
                <input type="number" class="form-control" id="per_codigo" name="per_codigo" required>
            </div>

            <!-- Nombre de Usuario -->
            <div class="mb-3">
                <label for="usu_nombre" class="form-label">Nombre de Usuario</label>
                <input type="text" class="form-control" id="usu_nombre" name="usu_nombre" required>
            </div>

            <!-- Contraseña -->
            <div class="mb-3">
                <label for="usu_pass" class="form-label">Contraseña</label>
                <input type="password" class="form-control" id="usu_pass" name="usu_pass" required>
            </div>

            <!-- Rol -->
            <div class="mb-3">
                <label for="rol_id" class="form-label">Rol</label>
                <select class="form-select" id="rol_id" name="rol_id" required>
                    <!-- Aquí debes llenar los roles desde tu base de datos -->
                    <option value="">Seleccionar Rol</option>
                    <option value="1">Administrador</option>
                    <option value="2">Usuario Regular</option>
                    <!-- Agregar más roles según tu base de datos -->
                </select>
            </div>

            <!-- Situación del usuario -->
            <div class="mb-3">
                <label for="usu_situacion" class="form-label">Situación</label>
                <select class="form-select" id="usu_situacion" name="usu_situacion" required>
                    <option value="1">Activo</option>
                    <option value="0">Inactivo</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Guardar Usuario</button>
        </form>
</div>
        <?php }else { ?>
    <h2 class="text-center mb-4"><?php echo $titulo; ?> los Roles </h2>

    <!-- Mostrar errores si existen -->
    <div class="alert alert-success" role="alert" style="display: none;"></div>
    <div class="alert alert-danger" role="alert" style="display: none;"></div>

        
        <form action="?c=usuario&a=Guardar" method="POST">
            <!-- Nombre de Usuario -->
            <div class="mb-3">
                <label for="UsuNom" class="form-label">Nombre dess Usuario</label>
                <input type="text" class="form-control"  name="UsuNom" required>
            </div>

            <!-- Contraseña -->
            <div class="mb-3">
                <label for="UsuPass" class="form-label">Contraseña</label>
                <input type="password" class="form-control" name="UsuPass" required>
            </div>

            <!-- Rol -->
            <div class="mb-3">
            <label for="RolId" class="form-label">Rol</label>
            <select class="form-select" name="RolId" required>
                <!-- Recorrer los roles y agregar las opciones dentro del select -->
                <?php foreach ($this->modelo->SelectRoles() as $resultado): 
                    // Asignamos las variables con los valores del resultado
                    $rol_id = $resultado->rol_id;
                    $rol_nombre = $resultado->rol_nombre;
                    $rol_situacion = $resultado->rol_situacion;
                ?>
                    <option value="<?php echo $rol_id; ?>"><?php echo $rol_nombre; ?></option>
                <?php endforeach; ?>
            </select>
        </div>


            <!-- Situación del usuario -->
            <div class="mb-3">
                <label for="usu_situacion" class="form-label">Situación</label>
                <select class="form-select" id="usu_situacion" name="usu_situacion" required>
                    <option value="1" Seleted>Activo</option>
                   
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Guardar Usuario</button>
        </form>
</div>
            <?php } ?>
       