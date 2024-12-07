<?php 
//de estos controladores vamos a las vistas 
//este controlador va llevar el control de toda las listad de personal del modelo personal metodo listaPersonal
require_once "modelos/personal.php";

class PersonalControlador{
//vamos a usar al modelo de la tabla producto
    private $modelo;
//vamos a inicializar el modelo que es nuvo producto
    public function __CONSTRUCT(){
        $this->modelo=new Personal;
    }

    //vamos a crear un metodo que se llama incio que trae encabezado, index y pie de pagina
    public function Inicio(){
        require_once "vistas/encabezado.php";
        require_once "vistas/personal/index.php";
        require_once "vistas/pie.php";
    }

    // este controlador es donde se encuentra la ubicacion de los formualrios para ingresar registros de personal
    public function FormCrear() {

        // Título dinámico: por defecto será "Registrar"
        $titulo = "Registrar";
        
        // Verificar si 'Percodigo' está presente en la URL
       if (isset($_GET['Percodigo'])) {
           // Obtenemos el objeto percodigo y lo guardamos en la variable $regresar
           $regresa = $this->modelo->Obtener($_GET['Percodigo']);
    
           // Cambiar el título a "Modificar" para edición
           $titulo = "Modificar";
       }
    
        // Incluir las vistas necesarias
        require_once "vistas/encabezado.php";
        require_once "vistas/personal/crear.php"; // Pasamos $p y $titulo
        require_once "vistas/pie.php";
    }

  //vamos a crear metodo para Guardar el formulario de agregar
  public function Guardar() {
    $respuestas = new Personal();

    // Función auxiliar para validar y procesar campos
    function procesarCampo($campo, $tipo = 'string') {
        if (empty($campo)) {
            return $tipo === 'int' ? 777 : null;
        }
        return $tipo === 'int' ? (int)$campo : $campo;
    }

    // Asignar valores del formulario
    $respuestas->setPer_codigo(intval($_POST['PerCodigo']));
    $respuestas->setPer_nombres($_POST['PerNombres']);
    $respuestas->setPer_apellidos(procesarCampo($_POST['PerApellidos']));
    $respuestas->setPer_dpi(procesarCampo($_POST['PerDpi'], 'int'));
    $respuestas->setPer_nit(procesarCampo($_POST['PerNit']));
    $respuestas->setPer_tel1(procesarCampo($_POST['PerTel1'], 'int'));
    $respuestas->setPer_tel2(procesarCampo($_POST['PerTel2'], 'int'));
    $respuestas->setPer_mail(procesarCampo($_POST['PerMail']));
    $respuestas->setPer_direccion(procesarCampo($_POST['PerDireccion']));
    $respuestas->setPer_fecha_registro(($_POST['FechaRegistro']) ?? date('Y-m-d'));
    $respuestas->setPer_situacion(intval($_POST['PerSituacion'] ));
    $respuestas->setPer_rol_id(intval($_POST['perRolid']));
    
 
    // Verificar si se subió una imagen
    if (isset($_FILES['PerImagen']) && $_FILES['PerImagen']['error'] == 0) {
        // Cargar la imagen y obtener su información
        $imagePath = $_FILES['PerImagen']['tmp_name'];
        $imageInfo = getimagesize($imagePath);

        if ($imageInfo) {
            $originalWidth = $imageInfo[0];
            $originalHeight = $imageInfo[1];
            $desiredWidth = 105;
            $desiredHeight = 196;

            if ($originalWidth > $desiredWidth || $originalHeight > $desiredHeight) {
                $aspectRatio = $originalWidth / $originalHeight;
                if ($aspectRatio > 1) {
                    $newWidth = $desiredWidth;
                    $newHeight = round($desiredWidth / $aspectRatio);
                } else {
                    $newHeight = $desiredHeight;
                    $newWidth = round($desiredHeight * $aspectRatio);
                }
            } else {
                $newWidth = $originalWidth;
                $newHeight = $originalHeight;
            }

            $newImage = imagecreatetruecolor($newWidth, $newHeight);

            if ($imageInfo['mime'] == 'image/jpeg') {
                $originalImage = imagecreatefromjpeg($imagePath);
            } elseif ($imageInfo['mime'] == 'image/png') {
                $originalImage = imagecreatefrompng($imagePath);
            } elseif ($imageInfo['mime'] == 'image/gif') {
                $originalImage = imagecreatefromgif($imagePath);
            }

            imagecopyresampled($newImage, $originalImage, 0, 0, 0, 0, $newWidth, $newHeight, $originalWidth, $originalHeight);

            ob_start();
            imagejpeg($newImage);
            $imageData = ob_get_contents();
            ob_end_clean();

            $respuestas->setPer_imagen($imageData);
        } else {
            echo "Formato de imagen no soportado.";
        }
    }

    // Procesar el guardado
    if ($respuestas->getPer_codigo() > 0) {
        $this->modelo->Actualizar($respuestas);
    } else {
        $this->modelo->Insertar($respuestas);
    }

    // Redirigir a la lista de personal
    header("location:?c=personal");
    exit();
}



    // esto es para eliminar al personal
    public function EliminarPersonal() {
            //aqui tenemos un objeto con valores de un array
            $respuestas = $this->modelo->Obtener($_GET['Percodigo']);
           //$respuestas->setPer_codigo(intval($_POST['PerCodigo']));
    
            // Asignamos el valor de 'per_codigo' a una variable en personal.php tenetmos ya definimos la variable, y lo obtenemos con getPer_codigo();
             $codigoPersonal = $respuestas->getPer_codigo();
           // echo '<pre>';
           // print_r( $codigoPersonal); // Muestra las propiedades y valores del objeto
           // echo '</pre>';
           // exit;
            //ahora vamos a ejecutar el query para actualizar la situacion
            $this->modelo->Eliminar($respuestas);
            // Incluir las vistas necesarias
            require_once "vistas/encabezado.php";
            require_once "vistas/personal/index.php"; // Pasamos $p y $titulo
            require_once "vistas/pie.php";
    }


}