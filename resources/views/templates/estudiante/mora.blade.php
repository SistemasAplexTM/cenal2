@extends('layouts.app')
@section('title', 'Metodos de pago')
@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <div class="alert alert-danger alert-dismissable">
                <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                <p class="alert-link"><i class="fa fa-warning"></i> Debe estar al día para poder ingresar.</p>
                <p>A continuación encontrará los diferentes metodos de pago disponibles.</p>
            </div>
        </div>  
    </div>
    <div class="row">
        <div class="col-lg-8">
            <div class="tabs-container">
                <div class="tabs-left">
                    <ul class="nav nav-tabs">
                        <li class="active">
                            <a data-toggle="tab" href="#tab-pse"> 
                                <img src="{{ asset('img/pse.png') }}" alt="" width="35px">
                            </a>
                        </li>
                        <li class="">
                            <a data-toggle="tab" href="#tab-baloto">
                                <img src="{{ asset('img/baloto.png') }}" alt="" width="70px">
                            </a>
                        </li>
                        <li class="">
                            <a data-toggle="tab" href="#tab-cenal">
                                <img src="{{ asset('img/cenal.png') }}" alt="" width="70px">
                            </a>
                        </li>
                    </ul>
                    <div class="tab-content ">
                        <div id="tab-pse" class="tab-pane active">
                            <div class="panel-body text-center">
                                <h3>Pago a través de PSE </h3>
                                <p>Puede realizar sus pagos a través de la plataforma PSE haciendo
                                    <a href="https://www.psepagos.co/PSEHostingUI/ShowTicketOffice.aspx?ID=2545">click aquí</a>.
                                </p>
                                <a href="https://www.psepagos.co/PSEHostingUI/ShowTicketOffice.aspx?ID=2545">
                                    <img src="{{ asset('img/pse.png') }}" alt="" width="120px">
                                </a>
                            </div>
                        </div>
                        <div id="tab-baloto" class="tab-pane">
                            <div class="panel-body text-center">
                                <h3>Pago a través de Baloto </h3>
                                    <p>Haga <a href="{{ route('baloto') }}">click aquí</a> para descargar instrucciones.</p>
                                    <a href="{{ route('baloto') }}">
                                        <img src="{{ asset('img/baloto.png') }}" alt="" width="170px">
                                    </a>
                            </div>
                        </div>
                        <div id="tab-cenal" class="tab-pane">
                            <div class="panel-body text-center">
                                <h3 >Pago en las sedes de CENAL </h3>
                                <p>Puede realizar sus pagos acercandose a las diferentes sedes.</p>    
                                <ul class="list-group text-left">
                                    <li class="list-group-item">
                                        <strong>
                                            Cali:
                                        </strong>
                                        <p>Dirección: Calle 34 No. 2 Bis - 70 </p>
                                        <p>PBX: 6817301 - 6615883</p>
                                    </li>
                                    <li class="list-group-item">
                                        <strong>
                                            Palmira:
                                        </strong>
                                        <p>Dirección: Calle 31 No. 23 - 44</p>
                                        <p>Teléfono: 2660099 - 2708888</p>
                                    </li>
                                    <li class="list-group-item">
                                        <strong>
                                            Tuluá:
                                        </strong>
                                        <p>Dirección: Carrera 23 No. 32 - 41 </p>
                                        <p>Teléfono: 2243285 - 2257787</p>
                                    </li>
                                    <li class="list-group-item">
                                        <strong>
                                            Popayán:
                                        </strong>
                                        <p>Dirección: Carrera 3 No. 1A Norte - 15</p>
                                        <p>Teléfono: 8221132</p>
                                    </li><li class="list-group-item text-center">
                                        <img src="{{ asset('img/tarjetas-credito.png') }}" alt="" width="170px">
                                        
                                        <img src="{{ asset('img/cenal.png') }}" alt="" width="160px">
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="panel panel-success">
                <div class="panel-heading">
                    Pagos pendientes
                </div>
                <div class="panel-body">
                    <ul class="list-group">
                        <li class="list-group-item">
                            <strong>
                                Código:     
                            </strong>
                            {{ $mora[0]->consecutivo }}
                        </li>
                        <li class="list-group-item">
                            <strong>
                                Nombre:     
                            </strong>
                            {{ Auth::user()->name }}
                        </li>
                        <li class="list-group-item">
                            <strong>
                                Correo:
                            </strong>
                            {{ Auth::user()->email }}
                        </li>
                    </ul>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Concepto</th>
                                <th>Fecha</th>
                                <th>Valor</th>
                                <th>Días</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($mora as $val)
                                <tr>
                                    <td>{{ $val->descripcion }}</td>
                                    <td>{{ $val->fecha_inicio }}</td>
                                    <td>$ {!! number_format($val->saldo_vencido, 2) !!}</td>
                                    <td>{{ $val->dias }}</td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
    	<div class="col-md-2 ">
            <a class="btn btn-success btn-block" href="{{ route('logout') }}" onclick="event.preventDefault();document.getElementById('logout-form').submit();">
                <i class="fa fa-arrow-left"></i>
                Volver
            </a>
            <form id="logout-form" action="{{ route('logout') }}" method="POST" style="display: none;">
                {{ csrf_field() }}
            </form>
    	</div>
    </div>
</div>
@stop