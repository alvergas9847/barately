<?php 
//de qui referimo a modelos/roles.php donde van a estar todos los querys a ejecutar
require_once "modelos/roles.php";

class RolesControlador{

    //vamos a usar al modelo de la tabla producto
    private $modelo;

    //vamos a inicializar el modelo que es nuvo producto
    public function __CONSTRUCT(){
        $this->modelo=new Roles;
    }


    //vamos a crear un metodo que se llama incio que trae encabezado, index y pie de pagina
    public function Inicio(){
        require_once "vistas/encabezado.php";
        require_once "vistas/roles/index.php";
        require_once "vistas/pie.php";
    }

 //===================================================
 //===================[PASO NO 2]=====================
 //===================================================

     // este controlador es donde se encuentra la ubicacion de los formualrios para ingresar registros de personal
     public function CrearRoles() {

        // Título dinámico: por defecto será "Registrar"
        $titulo = "Registrar";
        
        // Verificar si 'RolId' está presente en la URL
     if (isset($_GET['RolId'])) {
         // Obtenemos el objeto RolId y lo guardamos en la variable $regresar
         //creaamos la funcion obtener en roles.php
         $regresa = $this->modelo->Obtener($_GET['RolId']);
    
         // Cambiar el título a "Modificar" para edición
         $titulo = "Modificar";
     }
    
        // Incluir las vistas necesarias
        require_once "vistas/encabezado.php";
        require_once "vistas/roles/CrearRoles.php"; // Pasamos $p y $titulo
        require_once "vistas/pie.php";
    }

 //===================================================
 //===================[PASO NO 3]=====================
 //===================================================
 //despues de hacer el formulario en el post hace referencia guardar
    //vamos a crear metodo para Guardar el formulario de agregar
    public function Guardar() {
    $respuestas = new Roles();

    // Asignar valores del formulario
    $respuestas->setRol_id(intval($_POST['RolId']));
    $respuestas->setRol_nombre($_POST['RolNom']);
    $respuestas->setRol_descripcion($_POST['RolDesc']);
    $respuestas->setRol_situacion($_POST['RolSit']);

        // **Imprimir los valores asignados a la clase Roles**
        //echo "<pre>";
        //print_r($respuestas);
        //echo "</pre>";
        //exit; // Detener la ejecución para inspeccionar los valores

       // Si no hay errores, procesar el guardado
       if ($respuestas->getRol_id() > 0) {
        $this->modelo->Actualizar($respuestas);
    } else {
        $this->modelo->Insertar($respuestas);
    }

    // Redirigir a la lista de personal si todo va bien
    header("location:?c=roles");
    exit();
    }


 //===================================================
 //===================[PASO NO 4]=====================
 //====================ELIMINAR===============================

    // esto es para eliminar al personal
    public function EliminarRoles() {
        //aqui tenemos un objeto con valores de un array
        $respuestas = $this->modelo->Obtener($_GET['RolId']);
       //$respuestas->setPer_codigo(intval($_POST['PerCodigo']));

        // Asignamos el valor de 'per_codigo' a una variable en personal.php tenetmos ya definimos la variable, y lo obtenemos con getPer_codigo();
         $codigoPersonal = $respuestas->getRol_id();
       // echo '<pre>';
       // print_r( $codigoPersonal); // Muestra las propiedades y valores del objeto
       // echo '</pre>';
       // exit;
        //ahora vamos a ejecutar el query para actualizar la situacion
        $this->modelo->Eliminar($respuestas);
        // Incluir las vistas necesarias
        require_once "vistas/encabezado.php";
        require_once "vistas/roles/index.php"; // Pasamos $p y $titulo
        require_once "vistas/pie.php";
}

}