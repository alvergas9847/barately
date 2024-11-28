
        <table id="example" class="display dataTable"  aria-describedby="example_info">
            <colgroup>
                <col data-dt-column="0">
                <col data-dt-column="1">
                <col data-dt-column="2">
                <col data-dt-column="3">
                <col data-dt-column="4">
                <col data-dt-column="5">
            </colgroup>
            <thead>
                <tr>
					<th data-dt-column="3" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Age: Activate to sort" tabindex="0">
                        <span class="dt-column-title" role="button">No.</span>
                    </th>
                    <th data-dt-column="0" rowspan="1" colspan="1" class="dt-orderable-asc dt-orderable-desc dt-ordering-asc" aria-sort="ascending" aria-label="Name: Activate to invert sorting" tabindex="0">
                        <span class="dt-column-title" role="button">Imagen</span>
                    </th>
					<th data-dt-column="0" rowspan="1" colspan="1" class="dt-orderable-asc dt-orderable-desc dt-ordering-asc" aria-sort="ascending" aria-label="Name: Activate to invert sorting" tabindex="0">
                        <span class="dt-column-title" role="button">Nombres</span>
                    </th>
                    <th data-dt-column="1" rowspan="1" colspan="1" class="dt-orderable-asc dt-orderable-desc" aria-label="Position: Activate to sort" tabindex="0">
                        <span class="dt-column-title" role="button">Apellidos</span>
                    </th>
                    <th data-dt-column="2" rowspan="1" colspan="1" class="dt-orderable-asc dt-orderable-desc" aria-label="Office: Activate to sort" tabindex="0">
                        <span class="dt-column-title" role="button">Telefono Personal</span>
                    </th>
					<th data-dt-column="2" rowspan="1" colspan="1" class="dt-orderable-asc dt-orderable-desc" aria-label="Office: Activate to sort" tabindex="0">
                        <span class="dt-column-title" role="button">Telefono de Contacto</span>
                    </th>
                    <th data-dt-column="4" rowspan="1" colspan="1" class="dt-type-date dt-orderable-asc dt-orderable-desc" aria-label="Start date: Activate to sort" tabindex="0">
                        <span class="dt-column-title" role="button">DPI</span>
                    </th>
                    <th data-dt-column="5" rowspan="1" colspan="1" class="dt-type-numeric dt-orderable-asc dt-orderable-desc" aria-label="Salary: Activate to sort" tabindex="0">
                        <span class="dt-column-title" role="button">Acciones</span>
                    </th>
                </tr>
            </thead>
            <tbody>
				<?php  $no = 1;
				// vamos hacer un foreach y vamos a descomponer todo el resultado 
				foreach ($this->modelo->ListaPersonal() as $resultado): 
                    
					$per_codigo = $resultado->per_codigo;
					$per_nombres = $resultado->per_nombres;
					$per_apellidos = $resultado->per_apellidos;
					$per_dpi = $resultado->per_dpi;
					$per_nit = $resultado->per_nit;
					$per_tel1 = $resultado->per_tel1;
					$per_tel2 = $resultado->per_tel2;
					$per_mail = $resultado->per_mail;
                    
					$per_imagen = $resultado->per_imagen;
					$per_direccion = $resultado->per_direccion;
					$per_fecha_registro = $resultado->per_fecha_registro;
					$per_situacion = $resultado->per_situacion;
				
				?>
                  
				<tr>
					<td class="dt-type-numeric"><?php echo($no) ?> </td>
                    <td class="sorting_1"> <?php     
                    if ($per_imagen) {
                        // Mostrar la imagen en formato base64 con tamaño de 96x96 píxeles
                        echo ' <img src="data:image/jpeg;base64,' . base64_encode($per_imagen) . '" alt="Imagen de Personal" width="105" height="196" />';
                    } else {
                        echo 'No hay imagen disponible.';
                    }
                    ?></td>
                    
					<td class="sorting_1"><?php echo($per_nombres)?></td>
                    <td><?php echo($per_apellidos)?></td>
                    <td><?php echo($per_tel1)?></td>
					<td><?php echo($per_tel2)?></td>
                    <input type="hidden" value="<?php$per_codigo?>"></input>
                    <input type="hidden" value="<?php$per_nit?>"></input>
                    <input type="hidden" value="<?php $per_mail?>"> </input>
                    <input type="hidden" value="<?php $per_direccion?>"> </input>
                    <td class="dt-type-date"><?php echo($per_dpi)?></td>
                    <td class="dt-type-numeric">
					<a  href='?c=personal&a=FormCrear&Percodigo=<?php echo $per_codigo; ?>'>	<button type="button" class="btn btn-warning" > Editar </button> </a>
					<a  href='?c=personal&a=EliminarPersonal&Percodigo=<?php echo $per_codigo; ?>'>	<button type="button" class="btn btn-danger">Eliminar</button></td> </a>
                </tr>
                <?php $no =$no+1; ?>
				<?php endforeach; ?>
            </tbody>
            <tfoot>
                <tr>
					<th data-dt-column="3" rowspan="1" colspan="1" class="dt-type-numeric">
                        <span class="dt-column-title">No.</span>
                    </th>
                    <th data-dt-column="0" rowspan="1" colspan="1">
                        <span class="dt-column-title">Imagen</span>
                    </th>
					<th data-dt-column="0" rowspan="1" colspan="1">
                        <span class="dt-column-title">Nombres</span>
                    </th>
					<th data-dt-column="1" rowspan="1" colspan="1">
                        <span class="dt-column-title">Apellidos</span>
                    </th>
                    <th data-dt-column="2" rowspan="1" colspan="1">
                        <span class="dt-column-title">Telefono Personal</span>
                    </th>
                    
                    <th data-dt-column="2" rowspan="1" colspan="1">
                        <span class="dt-column-title">Telefono de Contacto</span>
                    </th>
                    <th data-dt-column="4" rowspan="1" colspan="1" class="dt-type-date">
                        <span class="dt-column-title">DPI</span>
                    </th>
                    <th data-dt-column="5" rowspan="1" colspan="1" class="dt-type-numeric">
                        <span class="dt-column-title">Acciones</span>
                    </th>
                </tr>
            </tfoot>
        </table>
 
