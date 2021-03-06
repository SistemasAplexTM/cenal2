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
            <h5 class="logo-name">
                <img src="{{ asset('img/logo_cenal.png') }}" alt="">
            </h5>
        </div>
        <h3>Bienvenido a CENAL</h3>
        <p><small>CENTRO NACIONAL DE CAPACITACIÓN LABORAL</small></p>
        @if(Session::has('notification'))
            <div class="alert alert-warning">
                <h4>{{ Session::get('notification') }}</h4>
            </div>
        @endif
        @if(Session::has('no_cuenta'))
            <div class="alert alert-danger">
                <h4><i class="fa fa-exclamation-circle"></i> {{ Session::get('no_cuenta') }}</h4>
                <p>Acercate a la sede más cercana para realizar el proceso de inscripción.</p>
                <p><a target="_blank" href="https://cenal.com.co/cenal/porque-estudiar-en-cenal.html#nuestras_sedes">Ver sedes</a></p>
            </div>
        @endif
        @if(Session::has('si_cuenta'))
            <div class="alert alert-warning">
                <h4>{{ Session::get('si_cuenta') }} <i class="fa fa-exclamation"></i> </h4>
            </div>
        @endif
        <form id="form-login" class="m-t" role="form" method="POST" action="{{ route('login') }}">
            {{ csrf_field() }}
            <div class="form-group {{ $errors->has('email') ? 'has-error' : '' }}">
               <input 
                name="email"
                type="email"
                class="form-control"
                placeholder="Correo"
                required=""
                value="{{ session('notification') ? session('email'): old('email') }}" 
                >
                {!! $errors->first('email', '<span class="help-block">:message</span>') !!}
            </div>
            <div class="form-group {{ $errors->has('password') ? 'has-error' : '' }}">
                <input name="password" type="password" class="form-control" placeholder="Contraseña" required="">
                {!! $errors->first('password', '<span class="help-block">:message</span>') !!}
            </div>
            <button type="submit" class="btn btn-success block full-width m-b">Entrar</button>
            <a href="{{ route('password.request') }}"><small>Olvidaste tu contraseña?</small></a>
            {{-- <p class="text-muted text-center"><small>Do not have an account?</small></p> --}}
            <a class="btn btn-sm btn-white btn-block" href="{{ route('register') }}">Crear una cuenta</a>
        </form>
        <br>
        <div class="">
            <span class="text-center">
                Administrador: admin@gmail.com
            </span>
            <br>
            <span class="text-center">
                pass: admin
            </span>
            <br>
            <span class="text-center">
                Coordinador: coordinador@gmail.com
            </span>
            <br>
            <span class="text-center">
                pass: admin
            </span>
            <br>
            <span class="text-center">
                Profesor: julio@gmail.com
            </span>
            <br>
            <span class="text-center">
                pass: admin
            </span>
            <br>
            <span class="text-center">
                Estudiante: mafegg@hotmail.es
            </span>
            <br>
            <span class="text-center">
                pass: admin
            </span>
        </div>
    </div>
  <script src="{{ asset('js/plantilla.js') }}"></script>
</body>
</html>