<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no">
    <meta name="mobile-web-app-capable" content=yes>
    <link rel="icon" sizes="192x192" href="{{ asset('img/logo_cenal.png') }}">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>CENAL</title>

    <!-- Styles -->
    <link href="{{ asset('font-awesome/css/font-awesome.min.css') }}" rel="stylesheet">
    <link href="{{ asset('css/plantilla.css') }}" rel="stylesheet">
</head>
<body class="gray-bg">
    <div class="middle-box text-center loginscreen animated fadeInDown">
        <div>
            <div>
                <h5 class="logo-name">
                    <img src="{{ asset('img/logo_cenal.png') }}" alt="">
                </h5>
            </div>
            <h3>Bienvenido a CENAL</h3>
            <p><small>CENTRO NACIONAL DE CAPACITACIÓN LABORAL</small></p>
            <h4>Validar cuenta</h4>
            <p>Verifica si tienes una cuenta en el sistema con tu código de estudiante.</p>
            @if(Session::has('no_cuenta'))
                <div class="alert alert-warning">
                    <h4>{{ Session::get('no_cuenta') }}</h4>
                    <p>Acercate a la sede más cercana para realizar el proceso de inscripción.</p>
                </div>
            @endif
            <form id="form-login" class="m-t" role="form" method="POST" action="{{ route('validar') }}">
                {{ csrf_field() }}
                <div class="form-group {{ $errors->has('documneto') ? 'has-error' : '' }}">
                    <input name="code" type="text" class="form-control" placeholder="Código" required="">
                    {!! $errors->first('code', '<span class="help-block">:message</span>') !!}
                </div>
                <button type="submit" class="btn btn-success block full-width m-b">Validar</button>
                <a class="btn btn-sm btn-white btn-block" href="{{ route('login') }}">Volver</a>
            </form>
        </div>
    </div>
</div>
  <script src="{{ asset('js/plantilla.js') }}"></script>
</body>
</html>