<?php //despues de dar inicio al controlador
//pide que creemoes el archivo modelos/usuario.php
//de qui referimo a modelos/usuario.php donde van a estar todos los querys a ejecutar
require_once "modelos/finanzas.php";
//aquisiempre va a llevar UsuarioControlador la palabra controlador siempre
class FinanzasControlador{

    //vamos a usar al modelo de la tabla producto
    private $modelo;

    //vamos a inicializar el modelo que es nuvo producto
    public function __CONSTRUCT(){
        $this->modelo=new Finanzas;
    }
    //===================================================
    //===================[PASO NO 1]=====================
    //===================================================

    //vamos a crear un metodo que se llama incio que trae encabezado, index y pie de pagina
    public function Inicio(){
        require_once "vistas/encabezado.php";
        require_once "vistas/finanzas/index.php";
        require_once "vistas/pie.php";
    }
 

    //===================================================
    //===================[PASO NO 2]=====================
    //===================================================
    // aqui van el METHODO de servicios Basicos
     public function ServiciosRentas() {
    
        // Incluir las vistas necesarias
        require_once "vistas/encabezado.php";
        require_once "vistas/finanzas/ServiciosRentas.php"; // Pasamos $p y $titulo
        require_once "vistas/pie.php";
    }
 
    public function CrearServicios() {
            // Título dinámico: por defecto será "Registrar"
            $titulo = "Registrar";
        
            // Verificar si 'SerCodigo' está presente en la URL
         if (isset($_GET['SerCodigo'])) {
             // Obtenemos el objeto RolId y lo guardamos en la variable $regresar
             //creaamos la funcion obtener en roles.php
             $regresa = $this->modelo->ObtenerSerCodigo($_GET['SerCodigo']);
        
             // Cambiar el título a "Modificar" para edición
             $titulo = "Modificar";
         }
        // Incluir las vistas necesarias
        require_once "vistas/encabezado.php";
        require_once "vistas/finanzas/CrearServicios.php"; // Pasamos $p y $titulo
        require_once "vistas/pie.php";
    }
 
 //===================================================
 //===================[PASO NO 3]=====================
 //===================================================
 //despues de hacer el formulario en el post hace referencia guardar
    //vamos a crear metodo para Guardar el formulario de agregar
    public function GuardarServicios() {
        $respuestas = new Finanzas();
    
        // Asignar valores del formulario
        $respuestas->setSer_codigo(intval($_POST['SerCodigo']));
        $respuestas->setSer_nombre($_POST['SerNombre']);
        $respuestas->setSer_descri($_POST['SerDescri']);
        $respuestas->setSer_tipo($_POST['SerTipo']);
        
    
            // **Imprimir los valores asignados a la clase Roles**
            //echo "<pre>";
            //print_r($respuestas);
            //echo "</pre>";
            //exit; // Detener la ejecución para inspeccionar los valores
    
           // Si no hay errores, procesar el guardado
           if ($respuestas->getSer_codigo() > 0) {
            $this->modelo->UpdateServicio($respuestas);
        } else {
            $this->modelo->InsertServicio($respuestas);
        }
    
        // Redirigir a la lista de personal si todo va bien
        header("location:?c=finanzas&a=ServiciosRentas");
        exit();
        }


 //===================================================
 //===================[PASO NO 4]=====================
 //====================ELIMINAR===============================

    // esto es para eliminar al personal
    public function EliminarServicios() {
        //aqui tenemos un objeto con valores de un array
        $respuestas = $this->modelo->ObtenerSerCodigo($_GET['SerCodigo']);
       //$respuestas->setPer_codigo(intval($_POST['PerCodigo']));

        // Asignamos el valor de 'per_codigo' a una variable en personal.php tenetmos ya definimos la variable, y lo obtenemos con getPer_codigo();
         $codigoPersonal = $respuestas->getSer_codigo();
       // echo '<pre>';
       // print_r( $codigoPersonal); // Muestra las propiedades y valores del objeto
       // echo '</pre>';
       // exit;
        //ahora vamos a ejecutar el query para actualizar la situacion
        $this->modelo->DeleteServicios($respuestas);
        // Incluir las vistas necesarias
        require_once "vistas/encabezado.php";
        require_once "vistas/finanzas/ServiciosRentas.php"; // Pasamos $p y $titulo
        require_once "vistas/pie.php";
}


    //===================================================
    //===================[HACEMOS CobroServicios]=====================
    //===================================================
    // aqui van el METHODO de servicios Basicos
    public function CobroServicios() {
    
        // Incluir las vistas necesarias
        require_once "vistas/encabezado.php";
        require_once "vistas/finanzas/CobroServicios.php"; // Pasamos $p y $titulo
        require_once "vistas/pie.php";
    }

}