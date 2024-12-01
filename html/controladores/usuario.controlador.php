<?php //despues de dar inicio al controlador
//pide que creemoes el archivo modelos/usuario.php
//de qui referimo a modelos/usuario.php donde van a estar todos los querys a ejecutar
require_once "modelos/usuario.php";
//aquisiempre va a llevar UsuarioControlador la palabra controlador siempre
class UsuarioControlador{

    //vamos a usar al modelo de la tabla producto
    private $modelo;

    //vamos a inicializar el modelo que es nuvo producto
    public function __CONSTRUCT(){
        $this->modelo=new Usuario;
    }


    //vamos a crear un metodo que se llama incio que trae encabezado, index y pie de pagina
    public function Inicio(){
        require_once "vistas/encabezado.php";
        require_once "vistas/usuario/index.php";
        require_once "vistas/pie.php";
    }

 //===================================================
 //===================[PASO NO 2]=====================
 //===================================================

     // este controlador es donde se encuentra la ubicacion de los formualrios para ingresar registros de personal
     public function CrearUsuario() {

        // Título dinámico: por defecto será "Registrar"
        $titulo = "Registrar";
        
        // Verificar si 'UsuCodigo' está presente en la URL
     if (isset($_GET['UsuCodigo'])) {
         // Obtenemos el objeto RoUsuCodigolId y lo guardamos en la variable $regresar
         //creaamos la funcion obtener en roles.php
         $regresa = $this->modelo->Obtener($_GET['UsuCodigo']);
    
         // Cambiar el título a "Modificar" para edición
         $titulo = "Modificar";
     }
    
        // Incluir las vistas necesarias
        require_once "vistas/encabezado.php";
        require_once "vistas/usuario/CrearUsuario.php"; // Pasamos $p y $titulo
        require_once "vistas/pie.php";
    }



     //===================================================
 //===================[PASO NO 3]=====================
 //===================================================
 //despues de hacer el formulario en el post hace referencia guardar
    //vamos a crear metodo para Guardar el formulario de agregar
    public function Guardar() {
        $respuestas = new Usuario();
    
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
    


}