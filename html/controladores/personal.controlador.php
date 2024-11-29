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

    // Asignar valores del formulario
    $respuestas->setPer_codigo(intval($_POST['PerCodigo']));
    $respuestas->setPer_nombres($_POST['PerNombres']);
    $respuestas->setPer_apellidos($_POST['PerApellidos']);
    $respuestas->setPer_dpi($_POST['PerDpi']);
    $respuestas->setPer_nit($_POST['PerNit']);
    $respuestas->setPer_tel1((int)($_POST['PerTel1']));
    $respuestas->setPer_tel2((int)($_POST['PerTel2']));
    $respuestas->setPer_mail($_POST['PerMail']);
    $respuestas->setPer_direccion($_POST['PerDireccion']);
    $respuestas->setPer_fecha_registro($_POST['FechaRegistro'] ?? date('Y-m-d'));
    $respuestas->setPer_situacion((int)($_POST['PerSituacion']));

    // Verificar si se subió una imagen
    if (isset($_FILES['PerImagen']) && $_FILES['PerImagen']['error'] == 0) {
        // Cargar la imagen y obtener su información
        $imagePath = $_FILES['PerImagen']['tmp_name'];
        $imageInfo = getimagesize($imagePath);

        if ($imageInfo) {
            $originalWidth = $imageInfo[0];
            $originalHeight = $imageInfo[1];

            // Establecer las dimensiones deseadas para todas las imágenes (105x196 px)
            $desiredWidth = 105;
            $desiredHeight = 196;

            // Verificar si la imagen es muy pequeña o muy grande y redimensionarla de forma adecuada
            if ($originalWidth > $desiredWidth || $originalHeight > $desiredHeight) {
                // Redimensionar la imagen a las dimensiones deseadas, manteniendo la relación de aspecto
                $aspectRatio = $originalWidth / $originalHeight;
                if ($aspectRatio > 1) {
                    // Si la imagen es más ancha que alta
                    $newWidth = $desiredWidth;
                    $newHeight = round($desiredWidth / $aspectRatio);
                } else {
                    // Si la imagen es más alta que ancha o cuadrada
                    $newHeight = $desiredHeight;
                    $newWidth = round($desiredHeight * $aspectRatio);
                }
            } else {
                // Si la imagen es más pequeña que las dimensiones deseadas, se ajusta a un tamaño estándar (para no perder calidad)
                $newWidth = $originalWidth;
                $newHeight = $originalHeight;
            }

            // Crear una nueva imagen con las dimensiones ajustadas
            $newImage = imagecreatetruecolor($newWidth, $newHeight);

            // Cargar la imagen original dependiendo del formato
            if ($imageInfo['mime'] == 'image/jpeg') {
                $originalImage = imagecreatefromjpeg($imagePath);
            } elseif ($imageInfo['mime'] == 'image/png') {
                $originalImage = imagecreatefrompng($imagePath);
            } elseif ($imageInfo['mime'] == 'image/gif') {
                $originalImage = imagecreatefromgif($imagePath);
            }

            // Redimensionar la imagen original y guardarla en la nueva imagen
            imagecopyresampled($newImage, $originalImage, 0, 0, 0, 0, $newWidth, $newHeight, $originalWidth, $originalHeight);

            // Guardar la imagen redimensionada en un archivo temporal
            ob_start();
            imagejpeg($newImage);  // Guarda la imagen en formato JPEG
            $imageData = ob_get_contents();
            ob_end_clean();

            // Asignar la imagen redimensionada a la propiedad de la clase
            $respuestas->setPer_imagen($imageData);
        } else {
            // Si la imagen no tiene formato válido, se puede gestionar el error aquí
            echo "Formato de imagen no soportado.";
        }
    }

    // Si no hay errores, procesar el guardado
    if ($respuestas->getPer_codigo() > 0) {
        $this->modelo->Actualizar($respuestas);
    } else {
        $this->modelo->Insertar($respuestas);
    }

    // Redirigir a la lista de personal si todo va bien
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