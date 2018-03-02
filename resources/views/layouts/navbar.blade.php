<div class="row border-bottom white-bg">
    <nav class="navbar navbar-static-top" role="navigation">
        <div class="navbar-header">
            <button aria-controls="navbar" aria-expanded="false" data-target="#navbar" data-toggle="collapse" class="navbar-toggle collapsed" type="button">
                <i class="fa fa-reorder"></i>
            </button>
            <a href="{{ route('home') }}" class="navbar-brand">CENAL</a>
        </div>
        <div class="navbar-collapse collapse" id="navbar">
            <ul class="nav navbar-nav">
                {{-- <li class="">
                    <a href="{{ route('home') }}"><i class="fa fa-home"></i> <span class="nav-label">Inicio</span></a>
                </li> --}}
                <li>
                    <a href="{{ url('/clases') }}"><i class="fa fa-calendar"></i> <span class="nav-label">Módulos programados</span> </a>
                </li>
                @if(Auth::user()->rol == 2)
                <li>
                    <a href="{{ url('/admin/clases') }}"><i class="fa fa-gears"></i> <span class="nav-label">Configuración académica</span> </a>
                </li>
                @endif
                
                {{-- <li class="dropdown">
                    <a href="#" class="dropdown-toggle" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true"><i class="fa fa-archive"></i> <span class="nav-label">Coordinación académica</span> </a>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                            <li>
                                <a href="{{ url('salon') }}"><i class="fa fa-home"></i> <span class="nav-label">Salones</span> </a>
                            </li>
                            <li>
                                <a href="{{ url('profesor') }}"><i class="fa fa-user"></i> <span class="nav-label">Profesor</span> </a>
                            </li>
                            <li>
                                <a href="{{ url('modulo') }}"><i class="fa fa-list"></i> <span class="nav-label">Módulo</span> </a>
                            </li>
                            <li>
                                <a href="{{ url('ubicacion') }}"><i class="fa fa-map-marker"></i> <span class="nav-label">Ubicación</span> </a>
                            </li>
                        </ul>
                </li> --}}
                @role('Administrador|Coordinador')
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true"><i class="fa fa-gears"></i> <span class="nav-label">Administración</span> </a>
                    {{-- <div class=""> --}}
                      {{-- <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                        Dropdown
                        <span class="caret"></span>
                      </button> --}}
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                        <li>
                            <a href="{{ url('programas') }}"><i class="fa fa-briefcase"></i> <span class="nav-label">Programas</span> </a>
                        </li>
                        <li>
                            <a href="{{ url('salon') }}"><i class="fa fa-home"></i> <span class="nav-label">Salones</span> </a>
                        </li>
                        <li>
                            <a href="{{ url('modulo') }}"><i class="fa fa-puzzle-piece"></i> <span class="nav-label">Módulos</span> </a>
                        </li>
                        <li>
                            <a href="{{ url('ubicacion') }}"><i class="fa fa-map-marker"></i> <span class="nav-label">Ubicación</span> </a>
                        </li>
                        @can('ver_usuarios')
                            <li>
                                <a href="{{ url('user') }}"><i class="fa fa-user"></i> <span class="nav-label">Usuarios</span> </a>
                            </li>
                        @endcan
                      </ul>
                    {{-- </div> --}}
                </li>
                @endrole
            </ul>
            <ul class="nav navbar-top-links navbar-right">
                @if(Auth::user()->rol == 0)
                @role('Estudiante')
                <li>
                    <a href="{{ url('/estudiante/perfil') }}"><i class="fa fa-user-circle"></i> <span class="nav-label">Perfil</span> </a>
                </li>
                @endrole
                @endif
                @role('Administrador')
                <li><a href="{{ route('clients') }}"><i class="fa fa-code"></i> Soy desarrollador</a></li>
                @endrole
                @if(Auth::guest())
                <li>
                    <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                        <i class="fa fa-sign-out"></i> Entrar
                    </a>
                </li>
                @else
                <li>
                    <a href="{{ route('logout') }}" onclick="event.preventDefault();document.getElementById('logout-form').submit();">
                        <i class="fa fa-sign-out"></i> Salir
                    </a>
                    <form id="logout-form" action="{{ route('logout') }}" method="POST" style="display: none;">
                        {{ csrf_field() }}
                    </form>
                </li>
                @endif
            </ul>
        </div>
    </nav>
</div>