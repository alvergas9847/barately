
<br>
<div class="position-relative">
  <div class="position-absolute top-0 start-50 translate-middle">
    <a  href="?c=usuario&a=CrearUsuario">	<button type="button" class="btn btn-outline-primary">Agregar</button> </a>
</div>
</div>

<table id="example" class="display dataTable"  aria-describedby="example_info">
<colgroup>
    <col data-dt-column="0"></col>
    <col data-dt-column="1"></col>
    <col data-dt-column="2"></col>

</colgroup>
<thead>
    <tr>
        <th data-dt-column="0" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Age: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">No.</span>
        </th>
        <th data-dt-column="1" rowspan="1" colspan="1" class="dt-orderable-asc dt-orderable-desc" aria-label="Office: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Alias</span>
        </th>
        <th data-dt-column="1" rowspan="1" colspan="1" class="dt-orderable-asc dt-orderable-desc" aria-label="Office: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Rol</span>
        </th>
        <th data-dt-column="2" rowspan="1" colspan="1" class="dt-type-date dt-orderable-asc dt-orderable-desc" aria-label="Start date: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Acciones</span>
        </th>

    </tr>
</thead>
<tbody>
    <?php 
    $no = 1;
    // Usamos foreach para recorrer los resultados de UsuarioSelect
    foreach ($this->modelo->UsuarioSelect() as $resultado): 
        // Asignamos las variables con los valores del resultado
        $usu_codigo = $resultado->usu_codigo;
        $usu_nombre = $resultado->usu_nombre;
        $usu_pass = $resultado->usu_pass;
        $rol_id = $resultado->rol_id;
        $rol_nombre = $resultado->rol_nombre;
        $usu_situacion = $resultado->usu_situacion;
        $rol_situacion = $resultado->rol_situacion;
        $proveedor = $resultado->proveedor;
        $proveedor_id = $resultado->proveedor_id;
    
   ?>
    <tr>
        <td class="dt-type-numeric"><?php echo $no; ?> </td>
        <td><?php echo $usu_nombre; ?></td>

        <!-- Inputs ocultos con valores correctos -->
        <input type="hidden" value="<?php echo $usu_codigo; ?>">
        <input type="hidden" value="<?php echo $usu_pass; ?>">
        <input type="hidden" value="<?php echo $rol_id; ?>">
        <input type="hidden" value="<?php echo $rol_id; ?>">
        <input type="hidden" value="<?php echo $rol_situacion; ?>">
        <input type="hidden" value="<?php echo $proveedor; ?>">
        <input type="hidden" value="<?php echo $proveedor_id; ?>">     
        <td><?php echo $rol_nombre; ?></td>
        <td class="dt-type-numeric">
            <!-- Botones de acción dentro de enlaces -->
            <a href="?c=roles&a=CrearRoles&UsuCodigo=<?php echo $usu_codigo; ?>">
                <button type="button" class="btn btn-warning">Editar</button>
            </a>
            <a href="?c=roles&a=EliminarRoles&UsuCodigo=<?php echo $usu_codigo; ?>">
                <button type="button" class="btn btn-danger">Eliminar</button>
            </a>
        </td>
    </tr>
    <?php 
    $no = $no + 1; 
    endforeach; 
    ?>
</tbody>

<tfoot>
    <tr>
        <th data-dt-column="0" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Age: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">No.</span>
        </th>
        <th data-dt-column="2" rowspan="1" colspan="1" class="dt-type-date dt-orderable-asc dt-orderable-desc" aria-label="Start date: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Alias</span>
        </th>
        <th data-dt-column="2" rowspan="1" colspan="1" class="dt-type-date dt-orderable-asc dt-orderable-desc" aria-label="Start date: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Rol</span>
        </th>
        <th data-dt-column="3" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Salary: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Acciones</span>
        </th>
    </tr>
</tfoot>
</table>

