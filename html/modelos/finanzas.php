<?php
// Cambiar el nombre de la clase de "Usuarios" a "Usuario"
class Finanzas {
    // La variable pdo para la conexión a la base de datos
    private $pdo;

    // Atributos según la tabla servicio
    private $ser_codigo;
    private $ser_nombre;
    private $ser_descri;
    private $ser_tipo;
    private $ser_sit;
    
    // Atributos según la tablas Pago_Servicio
    private $pagser_codigo;
    private $pagser_per_codigo;
    private $pagser_ser_codigo;
    private $pagser_monto;
    private $pagser_fecha_ini;
    private $pagser_fecha_fin;
    private $pagser_total;
    private $pagser_descripcion;
    private $pagser_pag_tipo_id;
    private $pagser_meto_pago_id;
    private $pagser_situacion;
    // Atributos según la tabla roles
    private $rol_id;
    private $rol_descripcion;
    // Atributos según la tablas metodo_pago 
    private $metodo_pago_id;
    private $metodo_pago_nombre; 
    // Atributos según la tablas pago
    private $pago_codigo;
    private $pago_descripcion;
    private $pago_nombre;
   
    // Atributos según la tablas personal
    private $per_codigo;
    private $per_nombres;
    private $per_apellidos;

    // Método constructor
    public function __CONSTRUCT() {
        $this->pdo = BasedeDatos::Conectar();
    }

    // METODOS DE LA TABLA SERVICIO
    //metodos de obtension codigo servicio
    public function getSer_codigo() : ? int{
    return $this->ser_codigo;
    }
    
    // Método para asignar elcodigo servicio
    public function setSer_codigo(int $SerCodigo): void {
    $this->ser_codigo = $SerCodigo;
    }
    
    // Método de obtención nombre del servicio
    public function getSer_nombre() : ?string {
    return $this->ser_nombre;
    }
    
    // Método de asignación nombre del servicio
    public function setSer_nombre(?string $SerNombre) {
    $this->ser_nombre = $SerNombre ?? ''; // Si recibe null, asigna una cadena vacía
    }
    
    // Método de obtención descripcion del servicio
    public function getSer_descri() : ?string {
    return $this->ser_descri;
    }
        
    // Método de asignación descripcion del servicio
    public function setSer_descri(?string $SerDescri) {
    $this->ser_descri = $SerDescri ?? ''; // Si recibe null, asigna una cadena vacía
    }
        
    //metodos de obtension tipo servicio o renta
    public function getSer_tipo() : ? int{
    return $this->ser_tipo;
    }
        
    // Método para asignar tipo de servicio o renta
    public function setSer_tipo(int $SerTipo): void {
    $this->ser_tipo = $SerTipo;
    }


    // Método de obtención de ser_sit
    public function getSer_sit() : ?int {
        return $this->ser_sit;
    }

    // Método de asignación de ser_sit
    public function setSer_sit(int $SerSit): void {
        $this->ser_sit = $SerSit;
    }

    // METODOS DE LA TABLA PAGO_SERVICIO
    // METODOS DE LA TABLA PAGO_SERVICIO

    public function getPagser_codigo() : ?int {
        return $this->pagser_codigo;
     } 
     
     public function setPagser_codigo(int $PagserCodGo): void {
        $this->pagser_codigo = $PagserCodGo; 
     }
     public function getPagser_per_codigo() : ?int {
        return $this->pagser_per_codigo;
     } 
     
     public function setPagser_per_codigo(int $PagserPerCodigo): void {
        $this->pagser_per_codigo = $PagserPerCodigo; 
     }
     public function getPagser_ser_codigo() : ?int {
        return $this->pagser_ser_codigo;
     } 
     
     public function setPagser_ser_codigo(int $PagserSerCodigo): void {
        $this->pagser_ser_codigo = $PagserSerCodigo; 
     }
     public function getPagser_monto() : ? float{
        return $this->pagser_monto;
     }
     
     public function setPagser_monto(float $PagserMonto): void {
        $this->pagser_monto = $PagserMonto; 
     }
     
     public function getPagser_total() : ? float{
        return $this->pagser_total;
     }
     
     public function setPagser_total(float $PagserTotal): void {
        $this->pagser_total = $PagserTotal; 
     }

     public function getPagser_descripcion() : ?string {
        return $this->pagser_descripcion;
     }
     
     public function setPagser_descripcion(?string $PagserDescripcion){
        $this->pagser_descripcion = $PagserDescripcion ?? '';
     }

     public function getPagser_pag_tipo_id() : ?int {
        return $this->pagser_pag_tipo_id;
     } 
     
     public function setPagser_pag_tipo_id(int $PagserPagTipo_id): void {
        $this->pagser_pag_tipo_id = $PagserPagTipo_id; 
     }
     public function getPagser_meto_pago_id() : ?int {
        return $this->pagser_meto_pago_id;
     } 
     
     public function setPagser_meto_pago_id(int $PagserMet_pago_id): void {
        $this->pagser_meto_pago_id = $PagserMet_pago_id; 
     }

     public function getPagser_fecha_ini() : ?date {
        return $this->pagser_fecha_ini;
     }
     
     public function setPagser_fecha_ini(date $PagserFechaIni): void {
        $this->pagser_fecha_ini = $PagserFechaIni;
     } 

     public function getPagser_fecha_fin() : ?date {
        return $this->pagser_fecha_fin;
     }
     
     public function setPagser_fecha_fin(date $PagserFechaFin): void {
        $this->pagser_fecha_fin = $PagserFechaFin;
     } 
     public function getPagser_situacion() : ?int {
        return $this->pagser_situacion;
     } 
     
     public function setPagser_situacion(int $PagserSitAcion): void {
        $this->pagser_situacion = $PagserSitAcion; 
     }
     
   // METODOS DE LA TABLA ROLES
    // METODOS DE LA TABLA ROLES
    public function getRol_id() : ?int {
        return $this->rol_id;
     }
     
     public function setRol_id(int $RolId): void {
        $this->rol_id =  $RolId;
     }
     
     
     public function setRol_descripcion(?string $RolDescripcion){
        $this->rol_descripcion = $RolDescripcion; 
     }
     
     public function getRol_descripcion() : ?string {
        return $this->rol_descripcion;
     }
     
    
    public function getMetodo_pago_id() : ?int {
        return $this->metodo_pago_id;
    }
    
    public function setMetodo_pago_id(int $MetPagId): void {
        $this->metodo_pago_id = $MetPagId; 
    }
    
    
    public function setMetodo_pago_nombre(?string $MetPagNombre){
        $this->metodo_pago_nombre = $MetPagNombre; 
    } 
    
    public function getMetodo_pago_nombre() : ?string {
        return $this->metodo_pago_nombre;
    } 
    // METODOS DE LA TABLA METODO_PAGO
    // METODOS DE LA TABLA METODO_PAGO 
    
    public function getPago_codigo() : ?int {
        return $this->pago_codigo;
    }

    public function setPago_codigo(int $PagoCodigo){
    $this->pago_codigo = $PagoCodigo; 
    }

    public function getPago_nombre() : ?string {
        return $this->pago_nombre;
     }
     
     public function setPago_nombre(?string $pagoNombre){
        $this->pago_nombre = $pagoNombre; 
     }
     public function getPago_descripcion() : ?string {
        return $this->pago_descripcion;
     }
     
     public function setPago_descripcion(?string $pagoDescripcion){
        $this->pago_descripcion = $pagoDescripcion; 
     }
    // METODOS DE LA TABLA PERSONAL
    // METODOS DE LA TABLA PERSONAL
      
    public function getPer_codigo() : ?int {
        return $this->per_codigo;
    }

    public function setPer_codigo(int $PerCodigo){
    $this->per_codigo = $PerCodigo; 
    }

    public function getPer_nombres() : ?string {
    return $this->per_nombres;
    }

    public function setPer_nombres(?string $perNombres){
    $this->per_nombres = $perNombres; 
    }
    public function getPer_apellidos() : ?string {
    return $this->per_apellidos;
    }

    public function setPer_apellidos(?string $perApellidos){
    $this->per_apellidos = $perApellidos; 
    }

 


 //===================================================
 //===================[PASO NO 1 ]=====================
 //===================================================
 //aqui recibimos la orden desde finanzas controlador.

    ///aqui llamamos con un SELEC* FROM roles a todas las descripciones
    public function SelectServicios(){
        try {
            // Preparar la consulta
            $consulta = $this->pdo->prepare("SELECT * FROM servicio WHERE ser_sit > 0 ;");
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

 //===================================================
 //===================[PASO NO 2]=====================
 //===================================================
 //despues de hacer el formulario en el post hace referencia guardar
 
    public function InsertServicio(Finanzas $respuesta) {
    try {
        // Consulta SQL
        $consulta = "INSERT INTO servicio (ser_nombre, ser_descri, ser_sit)
                     VALUES (?, ?, ?);";
       
        // Ejecución de la consulta
        $this->pdo->prepare($consulta)->execute(array(
        $respuesta->getSer_nombre(),
        $respuesta->getSer_descri(),
        $respuesta->getSer_tipo(),
        ));
      
        } catch (Exception $e) {
        // Captura y muestra el error
        die("Error en la base de datos: " . $e->getMessage()." COMUNICARSE CON LA ADMINISTRACION" );
        }
        return $respuesta;  // Devolver el objeto con los errores (si los hay)
    }

/////////////////////////////////
////=====================[ paso No 3  ] ============================================
//////////////////////// creamos la funcion obtener para obtener el ID
    ///=============================================
    //====================[OBTENER]================   
    //
    
    public function ObtenerSerCodigo($SerCodigo) {
        try {
            // Preparamos la consulta con un parámetro vinculado
            $consulta = $this->pdo->prepare("SELECT * FROM servicio WHERE ser_codigo = :sercodigo");
            
            // Vinculamos el parámetro a la consulta
            $consulta->bindParam(':sercodigo', $SerCodigo, PDO::PARAM_INT);
    
            // Construimos la consulta para imprimirla
            $query_final = str_replace(':sercodigo', $SerCodigo, $consulta->queryString);
            //echo "Consulta a ejecutar: $query_final\n";
            //exit;
            // Ejecutamos la consulta
            $consulta->execute();
    
            // Obtenemos el resultado
            $respuesta = $consulta->fetch(PDO::FETCH_OBJ);
    
            // Verificamos si se encontró el registro
            if ($respuesta) {
                // Creamos una instancia de la clase Finanzas
                $regresa = new Finanzas();
    
                // Asignamos los valores del resultado a la instancia
                $regresa->setSer_codigo($respuesta->ser_codigo); 
                $regresa->setSer_nombre($respuesta->ser_nombre); 
                $regresa->setSer_descri($respuesta->ser_descri); 
                $regresa->setSer_tipo($respuesta->ser_tipo);
                $regresa->setSer_sit($respuesta->ser_sit);
    
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
     

///=============================================
    //====================[ACTUALIZAR]================
        
    public function UpdateServicio(Finanzas $respuesta) {
        try {
            // Consulta SQL corregida
            $consulta = "UPDATE servicio SET 
                ser_nombre = COALESCE(?, ser_nombre), 
                ser_descri = COALESCE(?, ser_descri),
                ser_tipo   = COALESCE(?, ser_tipo)
                WHERE ser_codigo = ?";
    
            // Array de los valores que se insertarán en la consulta
            $valores = array(
                $respuesta->getSer_nombre(), 
                $respuesta->getSer_descri(),
                $respuesta->getSer_tipo(),
                $respuesta->getSer_codigo() // Importante que este valor esté incluido
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
    
    public function DeleteServicios(Finanzas $respuesta) {
        try {
            // Consulta SQL
            $consulta = "UPDATE servicio SET ser_sit = 0 WHERE ser_codigo = :codigo";
    
            // Preparar la consulta
            $stmt = $this->pdo->prepare($consulta);
    
            // Ejecutar la consulta con el valor de per_codigo
            $stmt->execute(array(
                ':codigo' => $respuesta->getSer_codigo()  // Solo necesitas pasar per_codigo
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
    
//=====================================================================================================
//===================[aqui inician los de CobroServicios ]=============================================
//=====================================================================================================
 //aqui recibimos la orden desde finanzas controlador.

    ///este select es para desplegar a todos los pagos a cobrar
    public function SelectCobroServicios(){
        try {
            // Preparar la consulta
            $consulta = $this->pdo->prepare("SELECT 
                                            pagser_codigo, pagser_per_codigo, pagser_ser_codigo, pagser_monto, 
                                            pagser_fecha_ini,pagser_fecha_fin, pagser_total, pagser_descripcion, pagser_pag_tipo_id, 
                                            pagser_meto_pago_id, pagser_situacion, rol_id, rol_descripcion, 
                                            metodo_pago_id, metodo_pago_nombre , pago_codigo, pago_nombre, 
                                            pago_descripcion, per_codigo, per_nombres, per_apellidos
                                            FROM personal, pago_servicio, servicio, pago, metodo_pago, roles
                                            WHERE pagser_per_codigo = per_codigo
                                            AND per_rol_id = rol_id
                                            AND pagser_ser_codigo = ser_codigo 
                                            AND pagser_pag_tipo_id = pago_codigo
                                            AND pagser_meto_pago_id = metodo_pago_id
                                            AND pagser_situacion > 0;
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
    
    
    
}