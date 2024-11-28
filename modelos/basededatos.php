<?php

class BasedeDatos{
    const servidor = "localhost";
    const usuariobd = "root";
    const pass = "";
    const nombrebd = "barately";

    public static function Conectar(){
        try{
            $conexion = new PDO
            ("mysql:host=".self::servidor.";
            dbname=".self::nombrebd.";chartset=utf8",
            self::usuariobd,self::pass);

            $conexion->setAttribute(PDO::ATTR_ERRMODE, 
            PDO::ERRMODE_EXCEPTION);
            return $conexion;
        }catch(PDOException $e){
            return "Falló".$e->getMessage();
        }
         
    
    }
}

?>