<div class="row border-bottom white-bg">
    <nav class="navbar navbar-static-top  navbar-fixed-top" role="navigation">
        <div class="navbar-header">
            <button aria-controls="navbar" aria-expanded="false" data-target="#navbar" data-toggle="collapse" class="navbar-toggle collapsed" type="button">
                <i class="fa fa-reorder"></i>
            </button>
            <a href="{{ url('/grupos') }}" class="navbar-brand">CENAL</a>
        </div>
        <div class="navbar-collapse collapse" id="navbar">
            <ul class="nav navbar-nav">
                @role('Estudiante')
                <li class="">
                    <a href="{{ url('estudiante/perfil') }}"><i class="fa fa-home"></i> <span class="nav-label">Inicio</span></a>
                </li>
                @endrole
                @role('Administrador|Coordinador|Profesor')
                <li>
                    <a href="{{ url('/grupos') }}"><i class="fa fa-calendar"></i> <span class="nav-label">Grupos</span> </a>
                </li>
                @endrole
                @role('Administrador')
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true"><i class="fa fa-gears"></i> <span class="nav-label">Administración</span> </a>
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
                        <li>
                            <a href="{{ url('user') }}"><i class="fa fa-user"></i> <span class="nav-label">Usuarios</span> </a>
                        </li>
                      </ul>
                </li>
                @endrole
            </ul>
            <ul class="nav navbar-top-links navbar-right">
                <li>
                    <span class="label label-success">{{ Auth::user()->roles[0]->name }}</span>
                </li>
                @role('Administrador')
                <li><a href="{{ route('clients') }}"><i class="fa fa-code"></i> Soy desarrollador</a></li>
                @endrole
                @if (Auth::guest())
                    <li>
                        <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                            <i class="fa fa-sign-out"></i> Entrar
                        </a>
                    </li>
                @else
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
                            {{ Auth::user()->name }} <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu" role="menu">
                            @role('Estudiante')
                            <li>
                                <a href="{{ url('/estudiante/perfil') }}"><i class="fa fa-user-circle"></i> <span class="nav-label">Perfil</span> </a>
                            </li>
                            @endrole
                            <li>
                                <a href="{{ route('logout') }}"
                                    onclick="event.preventDefault();
                                             document.getElementById('logout-form').submit();">
                                    <i class="fa fa-sign-out"></i> Salir
                                </a>

                                <form id="logout-form" action="{{ route('logout') }}" method="POST" style="display: none;">
                                    {{ csrf_field() }}
                                </form>
                            </li>
                        </ul>
                    </li>
                @endif
            </ul>
        </div>
    </nav>
</div>