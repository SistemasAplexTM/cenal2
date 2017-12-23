<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Ops! | Acceso denegado</title>
    <link rel="icon" sizes="192x192" href="{{ asset('img/logo_cenal.png') }}">
    <link href="{{ asset('font-awesome/css/font-awesome.min.css') }}" rel="stylesheet">
    <link href="{{ asset('css/plantilla.css') }}" rel="stylesheet">

</head>

<body class="gray-bg">

    <div class="middle-box text-center animated fadeInDown">
        <h1>401</h1>
        <h3 class="font-bold">No tienes permiso para acceder a este sitio.</h3>

        <div class="error-desc">
            Debes estar autenticado para poder acceder a este sitio.
            <br>
            <br>
            <a href="{{ url('/login') }}" class="btn btn-success"><i class="fa fa-sign-in"></i> Iniciar sesión</a>
        </div>
    </div>
    <!-- Mainly scripts -->
    <script src="{{ asset('js/plantilla.js') }}"></script>
</body>

</html>
