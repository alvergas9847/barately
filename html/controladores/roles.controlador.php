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

 
}