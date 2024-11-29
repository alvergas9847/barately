<?php
//primer modificamos el encabezado y nos redirecciona a la carpeta con el nombre
//creamos un index
//creamos dentro de controladores roles.controlador.php
?>
<br>
<div class="position-relative">
  <div class="position-absolute top-0 start-50 translate-middle">
    <a  href="?c=roles&a=CrearRoles">	<button type="button" class="btn btn-outline-primary">Agregar</button> </a>
</div>
</div>

<table id="example" class="display dataTable"  aria-describedby="example_info">
<colgroup>
    <col data-dt-column="0"></col>
    <col data-dt-column="1"></col>
    <col data-dt-column="2"></col>
    <col data-dt-column="3"></col>
</colgroup>
<thead>
    <tr>
        <th data-dt-column="0" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Age: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">No.</span>
        </th>
        
        <th data-dt-column="1" rowspan="1" colspan="1" class="dt-orderable-asc dt-orderable-desc" aria-label="Office: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Nombre</span>
        </th>
        <th data-dt-column="2" rowspan="1" colspan="1" class="dt-type-date dt-orderable-asc dt-orderable-desc" aria-label="Start date: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Descripcion</span>
        </th>
        <th data-dt-column="3" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Salary: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Acciones</span>
        </th>
    </tr>
</thead>
<tbody>
    <?php  $no = 1;
    // vamos hacer un foreach y vamos a descomponer todo el resultado 
    foreach ($this->modelo->RolesSelect() as $resultado): 
        
        $rol_id = $resultado->rol_id;
        $rol_nombre = $resultado->rol_nombre;
        $rol_descripcion = $resultado->rol_descripcion;
        $rol_situacion = $resultado->rol_situacion;
        
    ?>
      
    <tr>
        <td class="dt-type-numeric"><?php echo($no) ?> </td>
    
        <td class="sorting_1"><?php echo($rol_nombre)?></td>
        <td><?php echo($rol_descripcion)?></td>

        <input type="hidden" value="<?php $rol_id?>"></input>
        <input type="hidden" value="<?php $rol_situacion?>"></input>

        <td class="dt-type-numeric">
        <a  href='?c=roles&a=CrearRoles&RolId=<?php echo $rol_id; ?>'>	<button type="button" class="btn btn-warning" > Editar </button> </a>
        <a  href='?c=roles&a=EliminarRoles&RolId=<?php echo $rol_id; ?>'>	<button type="button" class="btn btn-danger">Eliminar</button></td> </a>
    </tr>
    <?php $no =$no+1; ?>
    <?php endforeach; ?>
</tbody>
<tfoot>
    <tr>
        <th data-dt-column="0" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Age: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">No.</span>
        </th>
        
        <th data-dt-column="1" rowspan="1" colspan="1" class="dt-orderable-asc dt-orderable-desc" aria-label="Office: Activate to sort" tabindex="0">
                <span class="dt-column-title" role="button">Nombre</span>
        </th>
        <th data-dt-column="2" rowspan="1" colspan="1" class="dt-type-date dt-orderable-asc dt-orderable-desc" aria-label="Start date: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Descripcion</span>
        </th>
        <th data-dt-column="3" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Salary: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Acciones</span>
        </th>
    </tr>
</tfoot>
</table>

