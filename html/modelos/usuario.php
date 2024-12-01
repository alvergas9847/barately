<?php
// Cambiar el nombre de la clase de "Usuarios" a "Usuario"
class Usuario {
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

    // Métodos de obtención y asignación de los atributos
    public function getUsu_codigo(): ?int {
        return $this->usu_codigo;
    }

    public function setUsu_codigo(int $UsuCodigo): void {
        $this->usu_codigo = $UsuCodigo;
    }

   
    
    public function getUsu_nombre(): ?string {
        return $this->usu_nombre;
    }

    public function setUsu_nombre(string $UsuNom): void {
        $this->usu_nombre = $UsuNom;
    }


    public function getUsu_pass(): ?string {
        return $this->usu_pass;
    }

    public function setUsu_pass(string $UsuPass): void {
        $this->usu_pass = $UsuPass;
    }

        //inicia talba roles
    public function getRol_id(): ?int {
        return $this->rol_id;
    }

    public function setRol_id(int $RolId): void {
        $this->rol_id = $RolId;
    }

    public function getRol_nombre(): ?string {
        return $this->rol_nombre;
    }

    public function setRol_nombre(string $RolNom): void {
        $this->rol_nombre = $RolNom;
    }


    public function getProveedor(): ?string {
        return $this->proveedor;
    }

    public function setProveedor(string $Proveedor): void {
        $this->proveedor = $Proveedor;
    }

    public function getProveedor_id(): ?string {
        return $this->proveedor_id;
    }

    public function setProveedor_id(string $ProvId): void {
        $this->proveedor_id = $ProvId;
    }



    public function getRol_situacion(): ?int {
        return $this->rol_situacion;
    }

    public function setRol_situacion(int $RolSit): void {
        $this->rol_situacion = $RolSit;
    }    
    //finaliza tabla roles
    public function getUsu_situacion(): ?int {
        return $this->usu_situacion;
    }

    public function setUsu_situacion(int $UsuSit): void {
        $this->usu_situacion = $UsuSit;
    }



    ///aqui llamamos con un SELEC* FROM usuario a todas las descripciones
    public function UsuarioSelect(){
        try {
            // Preparar la consulta
            $consulta = $this->pdo->prepare("SELECT 
                                                usuario.usu_codigo, 
                                                usuario.usu_nombre, 
                                                usuario.usu_pass, 
                                                usuario.rol_id, 
                                                roles.rol_nombre, 
                                                roles.rol_situacion, 
                                                usuario.usu_situacion, 
                                                usuario.proveedor, 
                                                usuario.proveedor_id
                                            FROM 
                                                usuario 
                                            JOIN 
                                                roles 
                                            ON 
                                                usuario.rol_id = roles.rol_id
                                            WHERE 
                                                usuario.usu_situacion > 0;
                                            ");
            $consulta->execute();
            
            // Verificar cuántos resultados se obtienen
            $resultados = $consulta->fetchAll(PDO::FETCH_OBJ);
           // echo '<pre>';
           //  print_r($resultados);  // Ver los resultados
            //echo '</pre>';
            
            // Si no hay resultados
            if (empty($resultados)) {
                echo "No se encontraron resultados";
            }
            
            return $resultados;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    ///aqui llamamos con un SELEC* FROM usuario a todas las descripciones
    public function SelectRoles(){
        try {
            // Preparar la consulta
            $consulta = $this->pdo->prepare("SELECT rol_id, rol_nombre, rol_situacion FROM roles WHERE rol_situacion > 0;");
            $consulta->execute();
            
            // Verificar cuántos resultados se obtienen
            $resultados = $consulta->fetchAll(PDO::FETCH_OBJ);
            // echo '<pre>';
           //  print_r($resultados);  // Ver los resultados
            //echo '</pre>';
            
            // Si no hay resultados
            if (empty($resultados)) {
                echo "No se encontraron resultados";
            }
            
            return $resultados;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    

}
?>
