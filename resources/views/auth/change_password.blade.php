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
            <!-- <p><small>CENTRO NACIONAL DE CAPACITACIÓN LABORAL</small></p> -->
            @if (session('change_password'))
                <div class="alert alert-warning">
                    <h4>{{ session('change_password') }}</h4>
                    <p>Debes cambiar tu contraseña para poder usar la plataforma.</p>
                </div>
            @endif
            <form id="form-login" class="m-t" role="form" method="POST" action="{{ url('change_password') }}">
                {{ csrf_field() }}
                <div class="form-group">
                   <input 
                    name="password"
                    type="password"
                    class="form-control"
                    placeholder="Contraseña nueva"
                    required=""
                    value="{{ old('password') }}" 
                    >
                </div>
                <div class="form-group {{ $errors->has('password') ? 'has-error' : '' }}">
                    <input name="password_confirmation" type="password" class="form-control" placeholder="Confirmar contraseña" required="">
                    {!! $errors->first('password', '<span class="help-block">:message</span>') !!}
                </div>
                <button type="submit" class="btn btn-success block full-width m-b">Cambiar</button>
                {{-- <a href="#"><small>Olvidaste tu contraseña?</small></a> --}}
                {{-- <p class="text-muted text-center"><small>Do not have an account?</small></p> --}}
                
            </form>
                @if(Auth::guest())
                <a class="btn btn-sm btn-white btn-block" href="{{ route('home') }}">
                    <i class="fa fa-home"></i> Inicio
                </a>
                @else
                <a class="btn btn-sm btn-white btn-block" href="{{ route('logout') }}" onclick="event.preventDefault();document.getElementById('logout-form').submit();">
                    <i class="fa fa-sign-out"></i> Salir
                </a>
                <form id="logout-form" action="{{ route('logout') }}" method="POST" style="display: none;">
                    {{ csrf_field() }}
                </form>
                @endif
        </div>
    </div>
</div>
  <script src="{{ asset('js/plantilla.js') }}"></script>
</body>
</html>