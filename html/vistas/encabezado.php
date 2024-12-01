<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BARATELY</title>
  <!-- BOOTSTRAP   -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <!-- DATATABLES 5  -->  
  <link href="https://cdn.datatables.net/v/dt/dt-2.1.8/datatables.min.css" rel="stylesheet">
  <link href="assets/css/carousel.css" rel="stylesheet">
 
<body>
  <header>
      <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <!-- Navbar content -->
        <div class="container-fluid">
          <a class="navbar-brand" href="index.php">Barately</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
              <!-- Productos --> 
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">Producto </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                  <li><a class="dropdown-item" href="#"> x x x </a></li>
                  <li><a class="dropdown-item" href="#">x x x </a></li>
                  <li><a class="dropdown-item" href="#">x x x </a></li>
                </ul>
              </li>
              <!-- Personal -->
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  Personal
                </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                  <li><a class="dropdown-item" href="?c=personal">Buscar</a></li>
                  <li><a class="dropdown-item" href="?c=personal&a=FormCrear">Agregar</a></li>
                </ul>
              </li>
              <!-- Usuarios --> 
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">Usuario </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                  <li><a class="dropdown-item" href="?c=roles"> Roles </a></li>
                  <li><a class="dropdown-item" href="?c=usuario">Buscar </a></li>
                  <li><a class="dropdown-item" href="#">x x x </a></li>
                </ul>
              </li>                 
              <!-- PROVEEDORES --> 
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">Proveedor </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                  <li><a class="dropdown-item" href="#"> x x x </a></li>
                  <li><a class="dropdown-item" href="#">x x x </a></li>
                  <li><a class="dropdown-item" href="#">x x x </a></li>
                </ul>
              </li>
              <!-- INFORMES --> 
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">Informe </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                  <li><a class="dropdown-item" href="#"> x x x </a></li>
                  <li><a class="dropdown-item" href="#">x x x </a></li>
                  <li><a class="dropdown-item" href="#">x x x </a></li>
                </ul>
              </li>
              <!-- Agregar más menús según sea necesario -->
            </ul>
          </div>
        </div>
      </nav>
  </header>
<div class="mobile-menu-overlay">
