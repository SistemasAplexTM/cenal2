@extends('layouts.app')
@section('title', 'Clases')
@section('content')
<div class="container-fluid" id="clases">
    <div class="row animated fadeInDown">
        <div class="col-lg-4">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    {!! "<span class='label label-".$data->clase_estado." pull-right'>".$data->estado."</span>" !!}
                    {{-- <span class="label label-warning pull-right"></span> --}}
                    <h5>Módulo {{ $data->modulo }}</h5>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-xs-4">
                            <small class="stats-label">Jornada</small>
                            <h4>{{ $data->jornada }}</h4>
                        </div>

                        <div class="col-xs-4">
                            <small class="stats-label">Inicio</small>
                            <h4>{{ date("d-m-Y", strtotime($data->fecha_inicio)) }}</h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">Fin</small>
                            <h4>{{ date("d-m-Y", strtotime($data->fecha_fin)) }}</h4>
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-xs-4">
                            <small class="stats-label">Salón</small>
                            <h4>{{ $data->salon }}</h4>
                        </div>

                        <div class="col-xs-4">
                            <small class="stats-label">Cupos usados</small>
                            <h4>{{ $data->cant_estudiantes }}</h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">Cupos totales</small>
                            <h4>{{ $data->capacidad }}</h4>
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-xs-12">
                            <small class="stats-label">Profesor</small>
                            <dd class="project-people">
                            <a href="">
                                <h3>
                                    <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                                    Julio Castañeda
                                </h3>
                            </a>
                            </dd>
                        </div>

                        {{-- <div class="col-xs-4">
                            <small class="stats-label">% New Visits</small>
                            <h4>150.23%</h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">Last week</small>
                            <h4>124.990</h4>
                        </div> --}}
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="progress progress-striped active m-b-sm">
                                {!! "<div style='width: ".$porcentaje."%;' class='progress-bar'></div>" !!}
                            </div>
                            <small>Se han dictado <strong>{{ $data->completadas }}</strong> clases de {{ $data->total }} en total.</small>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="feed-activity-list">
                        <div class="feed-element">
                            <div class="form-group">
                                <div class="col-lg-12">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-user-plus"></i></span>
                                        <input v-model="dato_estudiante" name="burcar_estudiante" id="burcar_estudiante" type="text" placeholder="Agregar estudiante" class="form-control" >
                                        <a type="button"  class="input-group-addon btn btn-primary" @click.prevent="buscar_estudiante()">Buscar</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="feed-element">
                            <h5 class="text-center">Estudiantes inscritos</h5>
                        </div>
                        <div class="feed-element">
                            <a href="#" class="pull-left">
                                <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                            </a>
                            <div class="media-body ">
                                <strong>Jhonny Poconuco</strong><br>
                                <small class="text-muted"><strong>Asistencia:</strong> 03 / 15</small><br>
                                <small class="text-muted"><strong>Programa:</strong> Técnico en sistemas</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5>Clases </h5>
                    <div class="ibox-tools">
                        <a class="collapse-link">
                            <i class="fa fa-chevron-up"></i>
                        </a>
                    </div>
                </div>
                <div class="ibox-content">
                    <div id="calendar"></div>
                </div>
            </div>
        </div>
    </div>
    
<div class="modal inmodal" id="mdl_agregar_estudiante" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title">Inscribir estudiante</h4>
                <small class="font-bold">Seleccion un estudiante para inscribirlo a todas las clases del Módulo {{ $data->modulo }}.</small>
            </div>
            <div class="modal-body">
                <table class="table table-hover">
                    <tr>
                        <th>Consecutivo</th>
                        <th>Nombre</th>
                        <th>Apellidos</th>
                        <th></th>
                    </tr>
                    <tr v-for="value in estudiantes">
                        <td>@{{ value.consecutivo }}</td>
                        <td>@{{ value.nombres }}</td>
                        <td>@{{ value.primer_apellido + ' ' + value.segundo_apellido }}</td>
                        <td><button type="button" data-loading-text="Agregando..." id="agregar" class="btn btn-xs btn-primary"><i class="fa fa-add"></i> Agregar</button></td>
                    </tr>
                </table>
            </div>
            <div class="modal-footer ">
                <button type="button" class="btn btn-white " data-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary ">Aceptar</button>
            </div>
        </div>
    </div>
</div>
</div>

@endsection
@push('scripts')
<script src="{{ asset('js/clases.js') }}"></script>
@endpush