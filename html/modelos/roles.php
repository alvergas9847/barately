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
    return $this->rol_situacion;
    }

    //metodos de asignacion situacion roles
    public function setRol_situacion(int $RolSit){
        $this->rol_situacion=$RolSit;
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
//////////////////////// creamos la funcion obtener para obtener el ID
    ///=============================================
    //====================[OBTENER]================   
    //
    
    public function Obtener($RolId) {
        try {
            // Preparamos la consulta con un parámetro vinculado
            $consulta = $this->pdo->prepare("SELECT * FROM roles WHERE rol_id = :rolid");
    
            // Vinculamos el parámetro a la consulta
            $consulta->bindParam(':rolid', $RolId, PDO::PARAM_INT);
    
            // Ejecutamos la consulta
            $consulta->execute();
    
            // Obtenemos el resultado
            $respuesta = $consulta->fetch(PDO::FETCH_OBJ);
    
            // Verificamos si se encontró el registro
            if ($respuesta) {
                // Creamos una instancia de la clase Personal
                $regresa = new Roles();
                
                // Asignamos los valores del resultado a la instancia
                $regresa->setRol_id($respuesta->rol_id); 
                $regresa->setRol_nombre($respuesta->rol_nombre); 
                $regresa->setRol_descripcion($respuesta->rol_descripcion); 
                $regresa->setRol_situacion($respuesta->rol_situacion);
    
                // Devolvemos la instancia con los datos
                return $regresa;
            } else {
                // Si no se encontró el registro, retornamos null o false
                return null;
            }
    
        } catch (Exception $e) {
            // Si ocurre un error, lo gestionamos
            die($e->getMessage());
        }
    }
    
/////////////////////////////////
////=====================[ paso No 3  ] ============================================
//////////////////////// creamos la funcion obtener para obtener el ID
public function Insertar(Roles $respuesta) {
    try {
        // Consulta SQL
        $consulta = "INSERT INTO roles (rol_nombre, rol_descripcion)
                     VALUES (?, ?);";

        // Ejecución de la consulta
        $this->pdo->prepare($consulta)->execute(array(
        $respuesta->getRol_nombre(),
        $respuesta->getRol_descripcion(),
     
        ));
  
        } catch (Exception $e) {
        // Captura y muestra el error
        die("Error en la base de datos: " . $e->getMessage()." COMUNICARSE CON LA ADMINISTRACION" );
        }
        return $respuesta;  // Devolver el objeto con los errores (si los hay)
    }


 ///=============================================
    //====================[ACTUALIZAR]================
        
    public function Actualizar(Roles $respuesta) {
        try {
            // Consulta SQL corregida
            $consulta = "UPDATE roles SET 
                rol_nombre = COALESCE(?, rol_nombre), 
                rol_descripcion = COALESCE(?, rol_descripcion),
                rol_situacion = COALESCE(?, rol_situacion)
                WHERE rol_id = ?";
    
            // Array de los valores que se insertarán en la consulta
            $valores = array(
                $respuesta->getRol_nombre(), 
                $respuesta->getRol_descripcion(),
                $respuesta->getRol_situacion(),
                $respuesta->getRol_id()
            );
    
        // **Imprimir el array de valores**
        //echo "<pre>Array de valores a insertar:\n";
        //print_r($valores);
        //echo "</pre>";
        //exit; // Detener ejecución para ver los valores
           // Preparación de la consulta con los parámetros proporcionados
           $stmt = $this->pdo->prepare($consulta);
           $stmt->execute($valores);
   
       } catch (Exception $e) {
           // Captura y muestra el error si ocurre un problema durante la ejecución
           die("Error en la base de datos: " . $e->getMessage()." COMUNICARSE CON EL DBA DE BARATELY");
       }
   
       return $respuesta;  // Devolver el objeto con los posibles errores (si los hay)
   }
    
   ///=============================================
    //====================[ELIMINAR]================
    
    public function Eliminar(Roles $respuesta) {
        try {
            // Consulta SQL
            $consulta = "UPDATE roles SET rol_situacion = 0 WHERE rol_id = :codigo";
    
            // Preparar la consulta
            $stmt = $this->pdo->prepare($consulta);
    
            // Ejecutar la consulta con el valor de per_codigo
            $stmt->execute(array(
                ':codigo' => $respuesta->getRol_id()  // Solo necesitas pasar per_codigo
            ));
    
            // Imprimir la consulta con los valores
           // echo '<pre>';
           // echo "Consulta: " . $consulta . "\n";
           // echo "Valor de :codigo = " . $respuesta->getPer_codigo();
           // echo '</pre>';
           // exit;  // Detener el script después de mostrar la consulta
    
        } catch (Exception $e) {
            // Captura y muestra el error
            die("Error en la base de datos: " . $e->getMessage() . " COMUNICARSE CON LA ADMINISTRACION");
        }
    
        return $respuesta;  // Devolver el objeto con los posibles errores (si los hay)
    }
    
    

}