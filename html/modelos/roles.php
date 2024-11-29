<?php
//clase
class Roles{
    //la variable pdo para la conexion a la base de datos
    private $pdo;

    // atributos segun la tabla Roles
    private $rol_id;
    private $rol_nombre;
    private $rol_descripcion;
    private $rol_situacion;

       //metodo constructor
    public function __CONSTRUCT(){
        $this->pdo = BasedeDatos::Conectar();
    }
    
    //metodos de obtension codigo roles
    public function getRol_id() : ? int{
        return $this->rol_id;
    }

    // Método para asignar el código roles
    public function setRol_id(int $RolId): void {
        $this->rol_id = $RolId;
    }
    
    
    //metodos de obtension nombres rol
    public function getRol_nombre() : ?string{
        return $this->rol_nombre;
    }

    //metodos de asignacion nombres rol
    public function setRol_nombre(string $RolNom){
        $this->rol_nombre=$RolNom;
    }

     //metodos de obtension descripcion de roles
    public function getRol_descripcion() : ?string{
        return $this->rol_descripcion;
    }

    //metodos de asignacion descripcion de roles
    public function setRol_descripcion(string $RolDesc){
        $this->rol_descripcion=$RolDesc;
    }
    
      //metodos de obtension situacion roles
   public function getRol_situacion() : ?int{
    return $this->Rol_situacion;
    }

    //metodos de asignacion situacion roles
    public function setRol_situacion(int $RolSit){
        $this->Rol_situacion=$RolSit;
    }


    ///aqui llamamos con un SELEC* FROM roles a todas las descripciones
    public function RolesSelect(){
        try {
            // Preparar la consulta
            $consulta = $this->pdo->prepare("SELECT * FROM roles WHERE rol_situacion > 0 ;");
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
    
    
/////////////////////////////////
////=====================[ paso No2  ] ============================================
////////////////////////

}