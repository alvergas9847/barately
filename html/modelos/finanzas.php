<?php
// Cambiar el nombre de la clase de "Usuarios" a "Usuario"
class Finanzas {
    // La variable pdo para la conexión a la base de datos
    private $pdo;

    // Atributos según la tabla Roles
    private $usu_codigo;
    private $usu_nombre;
    private $usu_pass;
    private $rol_id;
    private $rol_nombre;
    private $rol_situacion;
    private $usu_situacion;
    private $proveedor;
    private $proveedor_id;



    // Método constructor
    public function __CONSTRUCT() {
        $this->pdo = BasedeDatos::Conectar();
    }


}