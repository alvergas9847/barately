<div class="container ">
 
    <?php if (isset($titulo) && $titulo <> "Modificar"){ ?>


    <h2 class="text-center mb-4"><?php echo $titulo; ?> los datos del Registro de Servicios</h2>
        <!-- de aqui al controlador-->
        <form action="?c=finanzas&a=GuardarServicios" method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>
        <input type="hidden" class="form-control"  name="SerCodigo" maxlength="3"  required>
            <div class="mb-3">
                <label for="SerNombre" class="form-label">Nombre del Servicio:</label>
                <input type="text" class="form-control" name="SerNombre" required>
            </div>
            <div class="mb-3">
                <label for="SerDescri" class="form-label">Descripción del Servicio:</label>
                <textarea class="form-control" name="SerDescri" rows="3" required></textarea>
            </div>
            <div class="mb-3">
                <label for="SerTipo" class="form-label">Tipo de Servicio:</label>
                <select class="form-select" name="SerTipo" required>
                    <option name="SerTipo"  value="1">Servicios básicos</option>
                    <option name="SerTipo"  value="2">Rentas</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Registrar Servicio</button>
        </form>

<?php }else { ?>

 <h2 class="text-center mb-4"><?php echo $titulo; ?> los datos del Registro de Servicios edit</h2>


        <!-- de aqui al controlador-->
        <form action="?c=finanzas&a=GuardarServicios" method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>
        <input type="hidden" class="form-control"  name="SerCodigo" maxlength="3"  value="<?php echo($regresa->getSer_codigo()); ?>" required>
            <div class="mb-3">
                <label for="SerNombre" class="form-label">Nombre del Servicio:</label>
                <input type="text" class="form-control" name="SerNombre" value="<?php echo($regresa->getSer_nombre()); ?>" required>
            </div>
            <div class="mb-3">
                <label for="SerDescri" class="form-label">Descripción del Servicio:</label>
                <input class="form-control" name="SerDescri" value="<?php echo($regresa->getSer_descri()); ?>" required>
            </div>
            <div class="mb-3">
                <label for="SerTipo" class="form-label">Tipo de Servicio:</label>
                <select class="form-select" name="SerTipo" required>
                    <option name="SerTipo"  value="1" <?php echo ($regresa->getSer_tipo() == 1) ? 'selected' : ''; ?>>Servicios básicos</option>
                    <option name="SerTipo"  value="2" <?php echo ($regresa->getSer_tipo() == 2) ? 'selected' : ''; ?>>Rentas</option> 
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Registrar Servicio</button>
        </form>

        <?php } ?>

    </div>