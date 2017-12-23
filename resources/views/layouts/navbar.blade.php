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
                <li class="">
                    <a href="{{ route('home') }}"><i class="fa fa-home"></i> <span class="nav-label">Inicio</span></a>
                </li>
                <li>
                    <a href="{{ url('/profesor/clases') }}"><i class="fa fa-calendar"></i> <span class="nav-label">Clases</span> </a>
                </li>
                @if(Auth::user()->rol == 0)
                <li>
                    <a href="{{ url('/estudiante/perfil') }}"><i class="fa fa-user-circle"></i> <span class="nav-label">Perfil</span> </a>
                </li>
                @endif
                @if(Auth::user()->rol == 1)
                <li>
                    <a href="{{ url('/profesor/perfil') }}"><i class="fa fa-user-circle"></i> <span class="nav-label">Perfil</span> </a>
                </li>
                @endif
                @if(Auth::user()->rol == 2)
                <li>
                    <a href="{{ url('/admin/clases') }}"><i class="fa fa-gears"></i> <span class="nav-label">Configuración académica</span> </a>
                @endif
                </li>
            </ul>
            <ul class="nav navbar-top-links navbar-right">
                <li><a href="{{ route('clients') }}"><i class="fa fa-code"></i> Soy desarrollador</a></li>
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