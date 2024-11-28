<?php

require_once "modelos/personal.php";

class InicioControlador{
    private $modelo;

    public function __CONSTRUCT(){
      $this->modelo=new Personal();
    }
    public function Inicio(){
       // echo "este es el controlador de Inicio";
       //$bd = BasedeDatos::Conectar();
       require_once "vistas/encabezado.php";
       require_once "vistas/inicio/principal.php";
       require_once "vistas/pie.php";       
    }
}
?>