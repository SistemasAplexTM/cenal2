@extends('layouts.app')
@section('title', 'Perfil')
@section('content')
<style>
    #modal-edit{
      width: 100% !important;
    }
  </style>
<div class="row animated fadeInRight">
    @if(session('mora'))
        <div class="alert alert-danger">
            <h2>Mensajdelkmlkmdflskm</h2>
        </div>
    @endif
    <div class="col-md-4">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <h5>Perfil</h5>
            </div>
            <div>
                <div class="ibox-content no-padding border-left-right">
                    @if($data->genero_id == 1)
                        <a type="button" data-toggle="modal" data-target="#modal-img">
                            <img alt="image" class="img-responsive " src="{{ asset('img/user-default.png') }}">
                        </a>
                    @elseif($data->genero_id == 1)
                        <img alt="image" class="img-responsive" src="{{ asset('img/user-default-f.png') }}">
                    @else
                        <img alt="image" class="img-responsive" src="{{ asset('img/user-update.png') }}">
                    @endif
                </div>
                <div class="ibox-content profile-content">
                    <p class="no-margins">
                        <span class="label label-success"><i class="fa fa-barcode"></i> {{ $data->consecutivo }}</span>
                    </p>
                    <h4><strong>{{ $data->nombres . ' ' .$data->primer_apellido . ' ' . $data->segundo_apellido  }}</strong>&nbsp;<span class="badge badge-success"> {{ $data->sede }} &nbsp;<i class="fa fa-map-marker"></i></span></h4>
                    <p><i class="fa fa-id-card-o icon-separed" ></i>{{ $data->num_documento }}</p>
                    <p><i class="fa fa-envelope icon-separed" ></i>{{ $data->correo }}</p>
                    {{-- <h5>
                        About me
                    </h5>
                    <p>
                        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitat.
                    </p> --}}
                    <div class="user-button">
                        <div class="row">
                            <div class="col-md-12">
                                <a data-toggle="modal" data-target="#modal-edit" class="btn btn-success btn-sm btn-circle pull-right"><i class="fa fa-gears"></i></a>
                                <hr>
                                <h4>Mensajes</h4>
                                <hr>
                            </div>
                        </div>
                    </div>
                    <div>
                        <div class="feed-activity-list disabled">
                            <div class="feed-element">
                                <a href="#" class="pull-left">
                                    <img alt="image" class="img-circle" src="{{ asset('img/user-default.png') }}">
                                </a>
                                <div class="media-body ">
                                    <small class="pull-right">Hace 40 min.</small>
                                    <strong>Julian Lasso</strong><br>
                                    <small class="text-muted">27-10-2017 9:10 am</small>
                                    <div >
                                        Los requerimientos del documento IEEE deben estar justificados con la firma del cliente.
                                    </div>
                                    <div class="pull-right">
                                        <a class="btn btn-xs btn-primary"><i class="fa fa-pencil"></i> Responder</a>
                                    </div>
                                </div>
                            </div>
                            <div class="feed-element">
                                <a href="#" class="pull-left">
                                    <img alt="image" class="img-circle" src="{{ asset('img/user-default-f.png') }}">
                                </a>
                                <div class="media-body ">
                                    <small class="pull-right">Hace 1 día.</small>
                                    <strong>Maria Doneya</strong><br>
                                    <small class="text-muted">26-10-2017 8:43 am</small>
                                     <div >
                                        La estructura de la base de datos se hace en la fase planeación, no en la fase de desarrolo y menos en la de pruebas.
                                    </div>
                                    <div class="pull-right">
                                        <a class="btn btn-xs btn-primary"><i class="fa fa-pencil"></i> Responder</a>
                                    </div>
                                </div>
                            </div>
                            <div class="feed-element">
                                <a href="#" class="pull-left">
                                    <img alt="image" class="img-circle" src="{{ asset('img/user-default.png') }}">
                                </a>
                                <div class="media-body ">
                                    <small class="pull-right">Hace 3 día.</small>
                                    <strong>Andrés</strong><br>
                                    <small class="text-muted">24-10-2017 11:00 am</small>
                                     <div >
                                        El plazo para la entrega de evidencia se vence en 2 horas.
                                    </div>
                                    <div class="pull-right">
                                         <div class="well">
                                            La plataforma está bloqueada, no he podido subir mi evidencia.
                                        </div>
                                        <a class="btn btn-xs btn-primary"><i class="fa fa-pencil"></i> Responder</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-block "><i class="fa fa-arrow-down"></i> Ver más</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-8">
        <div class="tabs-container">
            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#tab-1"><i class="fa fa-money"></i>Finanzas</a></li>
                <li><a data-toggle="tab" href="#" ><i class="fa fa-clock-o"></i>Calificaciones</a></li>
                <li><a data-toggle="tab" href="#" ><i class="fa fa-clock-o"></i>Calificaciones</a></li>
                <li><a data-toggle="tab" href="#" ><i class="fa fa-clock-o"></i>Certificados</a></li>
                <li><a data-toggle="tab" href="#" ><i class="fa fa-clock-o"></i>Clases</a></li>
            </ul>
            <div class="tab-content">
                <div id="tab-1" class="tab-pane active">
                    <div class="panel-body">
                        <table class="table table-striped" id="tbl-finanzas">
                            <thead>
                            <tr>
                                <th>Estado</th>
                                <th>Concepto</th>
                                <th>Fecha</th>
                                <th>Valor</th>
                                <th>Días</th>
                                <th>Observación</th>
                            </tr>
                            </thead>
                            <tbody>
                                @foreach($finanzas as $val)
                                    <tr>
                                        <td>
                                        @if($val->dias == 0)
                                            <span class="label label-primary"><i class="fa fa-check"></i> Pagado</span>
                                        @elseif($val->dias > 0 && $val->dias < 6)
                                            <span class="label label-danger"><i class="fa fa-exclamation-circle"></i> En mora</span>
                                        @else
                                            <span class="label label-warning"><i class="fa fa-exclamation"></i> Pendiente</span>
                                        @endif
                                        </td>
                                        <td>{{ $val->descripcion }}</td>
                                        <td>{{ $val->fecha_inicio }}</td>
                                        <td>$ {{ number_format($val->cuota,2) }}</td>
                                        <td>{{ ($val->dias == 0)? '' : $val->dias }}</td>
                                        <td>{{ $val->observacion }}</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
                <div id="tab-2" class="tab-pane">
                    <div class="panel-body">
                       <div class="col-md-6">
                            <div class="ibox float-e-margins">
                                <div class="ibox-title">
                                    <h5>Pagado</h5>
                                </div>
                                <div class="ibox-content">
                                    <div class="table-responsive">
                                        <table class="table table-bordered" id="tbl-recibos-pagados" width="100%">
                                            <thead>
                                                <tr>
                                                    <th>Fecha</th>
                                                    <th>Valor</th>
                                                    <th>Descuento</th>
                                                    <th>Neto</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                       <div class="col-md-6">
                            <div class="ibox float-e-margins">
                                <div class="ibox-title">
                                    <h5>Pendiente </h5>
                                </div>
                                <div class="ibox-content">
                                    <div class="table-responsive">
                                        <table class="table table-bordered" id="tbl-pendiente" width="100%">
                                            <thead>
                                                <tr>
                                                    <th>Descripción</th>
                                                    <th>Fecha</th>
                                                    <th>Cuota</th>
                                                    <th>Saldo vencido</th>
                                                    <th>Días</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="tab-3" class="tab-pane">
                    <div class="panel-body">
                       

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal de imagen-->
<div id="modal-img" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Imágen de perfil</h4>
      </div>
      <div class="modal-body">
        <img alt="image" class="img-responsive" src="{{ asset('img/user-default.png') }}">
        <div class="row">
            <input type="file" class="form-control">
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">cerrar</button>
      </div>
    </div>

  </div>
</div>
<!-- Modal de editar-->
<div id="modal-edit" class="modal fade" role="dialog">
  <div class="modal-dialog modal-lg">

    <!-- Modal content-->
    <div class="modal-content animated flipInY">
    <form action="{{ url('perfil/update') }}/{{ $data->id }}" method="POST">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Imágen de perfil</h4>
      </div>
      <div class="modal-body">
             {{ csrf_field() }}
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="">Nombre</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-user"></i></span>
                            <input name="nombres" type="text" class="form-control" value="{{ $data->nombres }}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Primer apellido</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-user"></i></span>
                            <input name="primer_apellido" type="text" class="form-control" value="{{ $data->primer_apellido }}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Segundo apellido</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-user"></i></span>
                            <input name="segundo_apellido" type="text" class="form-control" value="{{ $data->segundo_apellido }}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Correo</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
                            <input name="correo" type="text" class="form-control" value="{{ $data->correo }}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Fecha de nacimiento: {{ date('d-m-Y', strtotime(trim($data->fecha_nacimiento))) }}</label>
                        <div id="data_1">
                            <div class="input-group date">
                                <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                <input name="fecha_nacimiento" id="fecha_nacimiento" type="text" class="form-control" placeholder="aaaa-mm-dd" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="">Documento</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-id-card-o"></i></span>
                            <input class="form-control" value="{{ $data->num_documento }}" readonly="">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Lugar de expedición</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-map-marker"></i></span>
                            <input name="expedicion_documento" type="text" class="form-control" value="{{ $data->expedicion_documento }}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Dirección</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-map-marker"></i></span>
                            <input name="direccion" type="text" class="form-control" value="{{ $data->direccion }}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Celular</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-mobile-phone"></i></span>
                            <input name="tel_movil" type="text" class="form-control" value="{{ $data->tel_movil }}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Teléfono</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-phone"></i></span>
                            <input name="tel_fijo" type="text" class="form-control" value="{{ $data->tel_fijo }}">
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="">Libreta militar</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-address-card"></i></span>
                            <input name="num_libreta" type="text" class="form-control" value="{{ $data->num_libreta }}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Nivel de estudio</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-graduation-cap"></i></span>
                            <select name="nivel_academico_id" class="form-control">
                                @foreach($nivel_academico as $n_a)
                                    <option value="{{ $n_a->id }}" {{ $n_a->id == $data->nivel_academico_id ? 'selected' : '' }}>
                                        {{ $n_a->descripcion }}
                                    </option>
                                @endforeach
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Institución</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-university"></i></span>
                            <input name="institucion" type="text" class="form-control" value="{{ $data->institucion }}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Estado civil</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-blind"></i></span>
                            <select name="estado_civil_id" class="form-control">
                                @foreach($estado_civil as $e_c)
                                    <option value="{{ $e_c->id }}" {{ $e_c->id == $data->estado_civil_id ? 'selected' : '' }}>
                                        {{ $e_c->descripcion }}
                                    </option>
                                @endforeach
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="">Ocupación</label>
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-briefcase"></i></span>
                            <input name="ocupacion" type="text" class="form-control" value="{{ $data->ocupacion }}">
                        </div>
                    </div>
                </div>
            </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">cerrar</button>
        <button type="submit" class="btn btn-success btn-sm"><i class="fa fa-save"></i>&nbsp;Actualizar</button>
      </div>
    </form>
    </div>

  </div>
</div>
@stop
@push('scripts')
<script src="{{ asset('js/perfil.js') }}"></script>
@endpush