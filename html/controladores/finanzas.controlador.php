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


    //vamos a crear un metodo que se llama incio que trae encabezado, index y pie de pagina
    public function Inicio(){
        require_once "vistas/encabezado.php";
        require_once "vistas/finanzas/index.php";
        require_once "vistas/pie.php";
    }

}