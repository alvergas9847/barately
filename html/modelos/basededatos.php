<?php
class BasedeDatos{
    //const servidor = "localhost";  // Cambiar localhost por el nombre del contenedor en Docker
    const servidor = "mysql";  // Nombre del servicio en Docker, no "localhost"
    const usuariobd = "root";
    const pass = "12345";
    const nombrebd = "barately";

    public static function Conectar(){
        try{
            $conexion = new PDO
            ("mysql:host=".self::servidor.";dbname=".self::nombrebd.";charset=utf8",
            self::usuariobd,self::pass);

            $conexion->setAttribute(PDO::ATTR_ERRMODE, 
            PDO::ERRMODE_EXCEPTION);
            return $conexion;
        }catch(PDOException $e){
            return "Falló: ".$e->getMessage();
        }
    }
}

?>