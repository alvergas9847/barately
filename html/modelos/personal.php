<?php
//clase
class Personal{
    //la variable pdo para la conexion a la base de datos
    private $pdo;

    
    // atributos segun la tabla personal
    private $per_codigo;
    private $per_nombres;
    private $per_apellidos;
    private $per_dpi;
    private $per_nit;
    private $per_tel1;
    private $per_tel2;
    private $per_mail;
    private $per_imagen;
    private $per_direccion;
    private $per_fecha_registro;
    private $per_situacion;

   

    //metodo constructor
    public function __CONSTRUCT(){
        $this->pdo = BasedeDatos::Conectar();
    }
    //metodos de obtension codigo personal
    public function getPer_codigo() : ? int{
        return $this->per_codigo;
    }

    // Método para asignar el código personal
    public function setPer_codigo(int $PerCodigo): void {
        $this->per_codigo = $PerCodigo;
    }
    

    //metodos de obtension nombres personal
    public function getPer_nombres() : ?string{
        return $this->per_nombres;
    }

    //metodos de asignacion nombres personal
    public function setPer_nombres(string $perNom){
        $this->per_nombres=$perNom;
    }

    //metodos de obtension apellidos personal
    public function getPer_apellidos() : ?string{
        return $this->per_apellidos;
    }

    //metodos de asignacion apellidos personal
    public function setPer_apellidos(string $perApe){
        $this->per_apellidos=$perApe;
    }

    //metodos de obtension dpi personal
    public function getPer_dpi() : ?int{
        return $this->per_dpi;
    }

    //metodos de asignacion dpi personal
    public function setPer_dpi(int $perDpi){
        $this->per_dpi=$perDpi;
    }

    // Método de obtención NIT personal
    public function getPer_nit() : ?string {
        return $this->per_nit;
    }

    // Método de asignación NIT personal
    public function setPer_nit(string $perNit){
        $this->per_nit = $perNit;
    }

    //metodos de obtension te1 personal
    public function getPer_tel1() : ?int{
        return $this->per_tel1;
    }

    //metodos de asignacion te1 personal
    public function setPer_tel1(int $perTel1){
        $this->per_tel1=$perTel1;
    }


    //metodos de obtension tel2 personal
    public function getPer_tel2() : ?int{
        return $this->per_tel2;
    }

    //metodos de asignacion tel2 personal
    public function setPer_tel2(int $perTel2){
        $this->per_tel2=$perTel2;
    }

    //metodos de obtension MAIL personal
    public function getPer_mail() : ?string{
        return $this->per_mail;
    }

    //metodos de asignacion MAIL personal
    public function setPer_mail(string $perMail){
        $this->per_mail=$perMail;
    }

    //metodos de obtension IMAGEN personal
    public function getPer_imagen(){
        return $this->per_imagen;
    }

    //metodos de asignacion IMAGEN personal
    public function setPer_imagen($perImagen){
        $this->per_imagen=$perImagen;
    }

    //metodos de obtension DIRECCION personal
    public function getPer_direccion() : ?string{
        return $this->per_direccion;
    }

    //metodos de asignacion DIRECCION personal
    public function setPer_direccion(string $perDire){
        $this->per_direccion=$perDire;
    }


   //metodos de obtension FECHA de registro personal
   public function getPer_fecha_registro(){
    return $this->per_fecha_registro;
    }

    //metodos de asignacion FECHA de registro personal
    public function setPer_fecha_registro($perReg){
        $this->per_fecha_registro=$perReg;
    }


   //metodos de obtension situacion personal
   public function getPer_situacion() : ?int{
    return $this->per_situacion;
    }

    //metodos de asignacion situacion personal
    public function setPer_situacion(int $perSit){
        $this->per_situacion=$perSit;
    }

 

    //vamos a consultar a la tabla
    public function Cantidad() {
        try {
            // Preparar la consulta
            $consulta = $this->pdo->prepare("SELECT COUNT(per_codigo) AS total FROM personal;");
            $consulta->execute();
            // Obtener el resultado como un arreglo asociativo
            $resultado = $consulta->fetch(PDO::FETCH_ASSOC);
            // Retornar el valor como entero
            return (int) $resultado['total'];
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    

    public function ListaPersonal(){
        try {
            // Preparar la consulta
            $consulta=$this->pdo->prepare("SELECT * FROM personal WHERE per_situacion > 0;");
            $consulta->execute();
            //este FetchAll trae todos los resultados
            return $consulta->fetchAll(PDO::FETCH_OBJ);
        } catch (Exception $e) {
            //throw $th;
            die($e->getMessage());
        }
    }

     ///=============================================
    //====================[OBTENER]================   

    
    public function Obtener($Percodigo) {
        try {
            // Preparamos la consulta con un parámetro vinculado
            $consulta = $this->pdo->prepare("SELECT * FROM personal WHERE per_codigo = :percodigo");
    
            // Vinculamos el parámetro a la consulta
            $consulta->bindParam(':percodigo', $Percodigo, PDO::PARAM_INT);
    
            // Ejecutamos la consulta
            $consulta->execute();
    
            // Obtenemos el resultado
            $respuesta = $consulta->fetch(PDO::FETCH_OBJ);
    
            // Verificamos si se encontró el registro
            if ($respuesta) {
                // Creamos una instancia de la clase Personal
                $regresa = new Personal();
                
                // Asignamos los valores del resultado a la instancia
                $regresa->setPer_codigo($respuesta->per_codigo); 
                $regresa->setPer_nombres($respuesta->per_nombres); 
                $regresa->setPer_apellidos($respuesta->per_apellidos); 
                $regresa->setPer_dpi($respuesta->per_dpi); 
                $regresa->setPer_nit($respuesta->per_nit); 
                $regresa->setPer_tel1($respuesta->per_tel1); 
                $regresa->setPer_tel2($respuesta->per_tel2); 
                $regresa->setPer_mail($respuesta->per_mail); 
                $regresa->setPer_direccion($respuesta->per_direccion); 
                $regresa->setPer_imagen($respuesta->per_imagen);
                $regresa->setPer_fecha_registro($respuesta->per_fecha_registro);
                $regresa->setPer_situacion($respuesta->per_situacion);
    
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
    //====================[INSERTAR]================

    public function Insertar(Personal $respuesta) {
        try {
 
                // Consulta SQL
            $consulta = "INSERT INTO personal (per_nombres, per_apellidos, per_dpi, per_nit, per_tel1, per_tel2, per_mail, per_direccion, per_imagen, per_fecha_registro, per_situacion)
                         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    
            // Ejecución de la consulta
            $this->pdo->prepare($consulta)->execute(array(
                $respuesta->getPer_nombres(), 
                $respuesta->getPer_apellidos(), 
                $respuesta->getPer_dpi(), 
                $respuesta->getPer_nit(), 
                $respuesta->getPer_tel1(), 
                $respuesta->getPer_tel2(), 
                $respuesta->getPer_mail(), 
                $respuesta->getPer_direccion(), 
                $respuesta->getPer_imagen(),
                $respuesta->getPer_fecha_registro(),
                $respuesta->getPer_situacion()
            ));
        } catch (Exception $e) {
            // Captura y muestra el error
            die("Error en la base de datos: " . $e->getMessage()." COMUNICARSE CON LA ADMINISTRACION" );
        }
    
        return $respuesta;  // Devolver el objeto con los errores (si los hay)
    }
    
    ///=============================================
    //====================[ACTUALIZAR]================
        
    public function Actualizar(Personal $respuesta) {
        try {
            // Consulta SQL con placeholders
            $consulta = "UPDATE personal SET 
            per_nombres = COALESCE(?, per_nombres), 
            per_apellidos = COALESCE(?, per_apellidos),
            per_dpi = COALESCE(?, per_dpi),
            per_nit = COALESCE(?, per_nit),
            per_tel1 = COALESCE(?, per_tel1),
            per_tel2 = COALESCE(?, per_tel2),
            per_mail = COALESCE(?, per_mail),
            per_direccion = COALESCE(?, per_direccion),
            per_imagen = COALESCE(?, per_imagen),
            per_fecha_registro = COALESCE(?, per_fecha_registro),
            per_situacion = COALESCE(?, per_situacion)
            WHERE per_codigo = ?";
    
            // Array de los valores que se insertarán en la consulta
            $valores = array(
                $respuesta->getPer_nombres(), 
                $respuesta->getPer_apellidos(),
                $respuesta->getPer_dpi(),
                $respuesta->getPer_nit(),
                $respuesta->getPer_tel1(),
                $respuesta->getPer_tel2(),
                $respuesta->getPer_mail(),
                $respuesta->getPer_direccion(),
                $respuesta->getPer_imagen(),
                $respuesta->getPer_fecha_registro(),
                $respuesta->getPer_situacion(),
                $respuesta->getPer_codigo()  // El código del personal para la condición WHERE
            );
    
            // Imprimir la consulta con los valores
            //$consultaConValores = vsprintf(str_replace("?", "'%s'", $consulta), $valores);
            //echo '<pre>';
            //echo $consultaConValores;  // Imprime la consulta con los valores insertados
            //echo '</pre>';
            //exit;  // Detener el script después de mostrar la consulta
    
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
    
    public function Eliminar(Personal $respuesta) {
        try {
            // Consulta SQL
            $consulta = "UPDATE personal SET per_situacion = 0 WHERE per_codigo = :codigo";
    
            // Preparar la consulta
            $stmt = $this->pdo->prepare($consulta);
    
            // Ejecutar la consulta con el valor de per_codigo
            $stmt->execute(array(
                ':codigo' => $respuesta->getPer_codigo()  // Solo necesitas pasar per_codigo
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
?>