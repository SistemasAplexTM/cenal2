@extends('layouts.app')
@section('title', 'Clases')
@section('content')
<div class="container-fluid" id="clases">
    <div class="row animated fadeInDown">
        <div class="col-lg-4">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    {!! "<span class='label label-".$data->clase_estado." pull-right'>".$data->estado."</span>" !!}
                    <h5>
                        <i class="fa fa-puzzle-piece"></i> Módulo {{ $data->modulo }}
                    </h5>
                </div>
                <div class="ibox-content text-center">
                    <div class="row">
                        <div class="col-xs-4">
                            <small class="stats-label">
                               <i class="fa fa-calendar"></i> Fecha de inicio
                            </small>
                            <h4>
                                {{ date("d-m-Y", strtotime($data->fecha_inicio)) }}
                            </h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">
                                <i class="fa fa-calendar"></i> Fecha de fin
                            </small>
                            <h4>
                                {{ date("d-m-Y", strtotime($data->fecha_fin)) }}
                            </h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">
                                <i class="fa fa-calendar"></i> Fecha actual
                            </small>
                            <h4>
                                {{ date("d-m-Y") }}
                            </h4>
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-xs-4">
                            <small class="stats-label">
                                <i class="fa fa-suitcase"></i> Jornada
                            </small>
                            <h4>
                                {{ $data->jornada }}
                            </h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">
                               <i class="fa fa-clock-o"></i> Hora de inicio
                            </small>
                            <h4>
                                {{ date("H:i", strtotime($data->inicio_jornada)) }}
                            </h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">
                                <i class="fa fa-clock-o"></i> Hora de fin
                            </small>
                            <h4>
                                {{ date("H:i", strtotime($data->fin_jornada)) }}
                            </h4>
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-xs-5">
                            <small class="stats-label">
                               <i class="fa fa-home"></i> Salón &nbsp;&nbsp;&nbsp; / &nbsp;&nbsp;&nbsp;<i class="fa fa-group"></i> Capacidad
                            </small>
                            <h4>
                                {!! str_replace(',', '<br>', $data->salon) !!}
                            </h4>
                        </div>
                        <div class="col-xs-3">
                            <small class="stats-label">
                               <i class="fa fa-group"></i> Cupos usados
                            </small>
                            <h4>
                                @{{ estudiantes_inscritos.length }}
                            </h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">
                               <i class="fa fa-map-marker"></i> Sede
                            </small>
                            <h4>
                                {{ $data->sede }}
                            </h4>
                        </div>
                    </div>
                </div>
                @role('Administrador')
                <div class="ibox-content">
                    <div class="row">
                        <div class="form-group">
                            <div class="col-lg-12">
                                <small class="stats-label">
                                    <i class="fa fa-user-circle-o"></i> Profesor
                                </small>
                                {{-- <a href="" class="btn pull-right" title="Cambiar profesor"><i class="fa fa-refresh"></i></a> --}}

                                <div class="input-group"  v-if="profesor_asignado.length <= 0">
                                    <span class="input-group-addon">
                                        <i class="fa fa-user-plus">
                                        </i>
                                    </span>
                                    <input class="form-control" id="burcar_profesor" name="burcar_profesor" placeholder="Asignar profesor" type="text" v-model="dato_profesor">
                                        <a @click.prevent="buscar_profesor()" class="input-group-addon btn btn-primary" type="button">
                                            Buscar
                                        </a>
                                    </input>
                                </div>
                                <dd class="project-people" v-if="profesor_asignado.length > 0">
                                    <a href="#">
                                        <h3>
                                            <img alt="image" width='60px' class='img-circle' src="{{ $data->perfil_profesor }}">
                                                @{{ profesor_asignado }}
                                            </img>
                                        </h3>
                                    </a>
                                </dd>
                            </div>
                        </div>
                    </div>
                </div>
                @endrole
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="progress progress-striped active m-b-sm">
                                {!! "<div class='progress-bar' style='width: ".$porcentaje."%;background-color: #1c84c6'></div>" !!}
                            </div>
                            <small>
                                Se han dictado
                                <strong>
                                    {{ $data->completadas }}
                                </strong>
                                clases de {{ $data->total }} en total.
                            </small>
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-xs-12">
                            <span class="stats-label">
                               <i class="fa fa-comments"></i> Observación:
                            </span>
                            <p>
                                {{ $data->observacion }}
                            </p>
                        </div>
                    </div>
                </div>
            </div>   
        </div>
        <div class="col-lg-4">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5>
                        Clases
                    </h5>
                    <div class="ibox-tools">
                        <a class="collapse-link">
                            <i class="fa fa-chevron-up">
                            </i>
                        </a>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="feed-activity-list">
                        @role('Administrador')
                        <div class="feed-element">
                            <div class="form-group">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <i class="fa fa-user-plus">
                                        </i>
                                    </span>
                                    <input class="form-control" id="burcar_estudiante" name="burcar_estudiante" placeholder="Agregar estudiante - Código o Documento" type="text" v-model="dato_estudiante">
                                        <a @click.prevent="buscar_estudiante()" class="input-group-addon btn btn-primary" type="button">
                                            Buscar
                                        </a>
                                    </input>
                                </div>
                            </div>
                        </div>
                        @endrole
                        <div class="feed-element text-center">
                            <a class="btn btn-block btn-warning right-sidebar-toggle" @click="verSidebar=0">
                                <i class="fa fa-group"></i> Estudiantes inscritos - @{{ estudiantes_inscritos.length }}
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="ibox">
                <div class="ibox-title">
                    <h5>Listado de clases</h5>
                    <div class="ibox-tools">
                        <a class="collapse-link">
                            <i class="fa fa-chevron-up">
                            </i>
                        </a>
                    </div>
                </div>
                <div class="ibox-content">

                    <div class="table-responsive">
                        <table class="table table-hover issue-tracker">
                            <tbody>
                                <tr v-for="clase in clases" :style="clase.estado=='Terminado' ? 'background-color: rgba(168, 178, 193, 0.3)' : ''">
                                    <td class="issue-info">
                                        <a href="#">
                                            @{{ clase.start }}
                                        </a>
                                    </td>
                                    <td>
                                        @{{ clase.salon }}
                                    </td>
                                    <td class="text-right">
                                        <a class="btn btn-default right-sidebar-toggle" @click="verSidebar=2;verClase(clase)"> Ver</a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
        <div class="col-lg-4">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5>
                        Calendario
                    </h5>
                    <div class="ibox-tools">
                        <a class="collapse-link">
                            <i class="fa fa-chevron-up">
                            </i>
                        </a>
                    </div>
                </div>
                <div class="ibox-content">
                    <div id="calendar">
                    </div>
                </div>
            </div>
        </div>
    </div>
    @include('layouts.sidebar')
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/clases_detail.js') }}">
</script>
@endpush
