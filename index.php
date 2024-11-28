<?php
require_once "modelos/basededatos.php";
//de aqui nos hace referencia a los controladores
//de los controladores nos hace referencia a las vistas
//c es mi variable de cum de ahi se define todos los controladores para el acceso a cada vista
//var_dump($_GET['c']);
if(!isset($_GET['c'])){
    require_once "controladores/inicio.controlador.php";
    $controlador = new InicioControlador();
    call_user_func(array($controlador, "inicio"));
    //echo "inicio";
}else{
    $controlador = $_GET['c'];
    require_once 
    "controladores/$controlador.controlador.php";
    $controlador = ucwords($controlador)."Controlador";
    $controlador = new $controlador;
    $accion = isset($_GET['a']) ? $_GET['a']: "Inicio";
    call_user_func(array($controlador, $accion));
}
?>





