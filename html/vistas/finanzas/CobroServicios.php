<div class="container">

<?php
//primer modificamos el encabezado y nos redirecciona a la carpeta con el nombre
//creamos un index
//creamos dentro de controladores roles.controlador.php
?>
<br>
<div class="position-relative">
  <div class="position-absolute top-0 start-50 translate-middle">
    <a  href="?c=finanzas&a=CrearServicios">	<button type="button" class="btn btn-outline-primary">Agregar</button> </a>
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
            <span class="dt-column-title" role="button">Tipo</span>
        </th>
        <th data-dt-column="4" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Salary: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Accion</span>
        </th>
    </tr>
</thead>
<tbody>
    <?php  $no = 1;
    // vamos hacer un foreach y vamos a descomponer todo el resultado 
    foreach ($this->modelo->SelectCobroServicios() as $resultado): 
        
        $pagser_codigo = $resultado->pagser_codigo;
        $pagser_per_codigo = $resultado->pagser_per_codigo;
        $pagser_ser_codigo = $resultado->pagser_ser_codigo;
        $pagser_monto = $resultado->pagser_monto;
        $pagser_fecha_ini = $resultado->pagser_fecha_ini;
        $agser_fecha_fin = $resultado->agser_fecha_fin;
        $pagser_total = $resultado->pagser_total;
        $pagser_descripcion = $resultado->pagser_descripcion;
        $pagser_pag_tipo_id = $resultado->pagser_pag_tipo_id;
        $pagser_meto_pago_id = $resultado->pagser_meto_pago_id;
        $pagser_situacion = $resultado->pagser_situacion;
        $rol_id = $resultado->rol_id;
        $rol_descripcion = $resultado->rol_descripcion;
        $metodo_pago_id = $resultado->metodo_pago_id;
        $metodo_pago_nombre = $resultado->metodo_pago_nombre; 
        $pago_codigo = $resultado->pago_codigo;
        $pago_nombre = $resultado->pago_nombre;
        $pago_descripcion = $resultado->pago_descripcion;
        $per_codigo = $resultado->per_codigo;
        $per_nombres = $resultado->per_nombres;
        $per_apellidos = $resultado->per_apellidos;
    ?>
      
    <tr>
        <td ><?php echo($no) ?> </td>
        <td ><?php echo($per_nombres.' '.$per_apellidos)?></td>
        <td ><?php echo($pagser_monto)?></td>

        <input type="hidden" value="<?php $ser_codigo?>"></input>

        <td > <?php if($pagser_situacion==1){ echo("Servicios Básicos");}else{echo("Rentas");}?> </td>
        <td >
        <a  href='?c=finanzas&a=CrearServicios&SerCodigo=<?php echo $ser_codigo; ?>'>	<button type="button" class="btn btn-warning" > Editar </button> </a>
        <a  href='?c=finanzas&a=EliminarServicios&SerCodigo=<?php echo $ser_codigo; ?>'>	<button type="button" class="btn btn-danger">Eliminar</button></td> </a>
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
            <span class="dt-column-title" role="button">Tipo</span>
        </th>
        <th data-dt-column="4" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Salary: Activate to sort" tabindex="0">
            <span class="dt-column-title" role="button">Accion</span>
        </th>
    </tr>
</tfoot>
</table>


 
</div>
