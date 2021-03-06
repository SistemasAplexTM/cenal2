@extends('layouts.app')
@section('title', 'Clases')
@section('content')
<div class="container-fluid" id="clases">
    <div class="row animated fadeInDown">
        <div class="col-lg-4">
            <div class="row">
                <div class="col-lg-3">
                    <a href="{{ url()->previous() }}" class="btn btn-block btn-default"><i class="fa fa-arrow-left"></i> Volver</a>
                </div>
                <div class="col-lg-5">
                    <a class="btn btn-block btn-warning" @click="verSidebar=0;open_sidebar=true">
                        <i class="fa fa-group"></i> Ver estudiantes inscritos - @{{ estudiantes_inscritos.length }}
                    </a>
                </div>
                <div class="col-lg-4">
                    <a v-if="estado_clase.descripcion!='Terminado'" class="btn btn-block btn-danger" @click="verSidebar=4;open_sidebar=true">
                        <i class="fa fa-step-forward"></i> Terminar módulo
                    </a>
                    <a v-else class="btn btn-block btn-danger" @click="verSidebar=5;open_sidebar=true">
                        <i class="fa fa-eye"></i> Ver reprobados - @{{ estudiantes_reprobados.length }}
                    </a>
                </div>
            </div>
            <br>
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h2>
                        <span class="pull-right label" :class="'label-' + estado_clase.clase" v-text="estado_clase.descripcion"></span>
                        {{-- {!! "<span class='label label-".$data->clase_estado." pull-right'>".$data->estado."</span>" !!} --}}
                        Módulo {{ $data->modulo }}
                    </h2>
                </div>
                @role('Administrador|Coordinador')
                <div class="ibox-content">
                    <div class="row">
                        <div class="form-group">
                            <div class="col-lg-11">
                                <small class="stats-label">
                                    <i class="fa fa-user-circle-o"></i> Profesor
                                </small>
                                <div class="input-group"  v-if="show_input_teacher">
                                    <span class="input-group-addon">
                                        <i class="fa fa-user-plus">
                                        </i>
                                    </span>
                                    <input class="form-control" id="burcar_profesor" name="burcar_profesor" placeholder="Asignar profesor" type="text" v-model="dato_profesor" @keyup.enter="buscar_profesor()">
                                        <a @click.prevent="buscar_profesor()" class="input-group-addon btn btn-primary" type="button">
                                            Buscar
                                        </a>
                                    </input>
                                </div>
                                <dd class="project-people" v-if="!show_input_teacher">    
                                    <h3>
                                        @{{ profesor_asignado }}
                                    </h3>
                                </dd>
                            </div>
                            <div class="col-lg-1">
                                <br>
                                <button class="btn btn-sm " @click.prevent="edit_prof = !edit_prof"><i class="fa " :class="[ edit_prof ? 'fa-times' : 'fa-edit' ]"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
                @endrole
                <div class="ibox-content text-center">
                    <div class="row">
                        <div class="col-xs-4">
                            <small class="stats-label">
                               <i class="fa fa-calendar"></i> Primera clase
                            </small>
                            <h4>
                                {{ date("d-m-Y", strtotime($data->fecha_inicio)) }}
                            </h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">
                                <i class="fa fa-calendar"></i> última clase
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
                <div class="ibox-content text-center">
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
                <div class="ibox-content text-center">
                    <div class="row">
                        <div class="col-xs-7">
                            <small class="stats-label">
                               <i class="fa fa-home"></i> Salón &nbsp;&nbsp;&nbsp; / &nbsp;&nbsp;&nbsp;<i class="fa fa-group"></i> Capacidad
                            </small>
                            <h4>
                                {!! str_replace(',', '<br>', $data->salon) !!}
                            </h4>
                        </div>
                        <div class="col-xs-5">
                            <small class="stats-label">
                               <i class="fa fa-map-marker"></i> Sede
                            </small>
                            <h4>
                                {{ $data->sede }}
                            </h4>
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="progress progress-striped active m-b-sm">
                                <div class='progress-bar' :style="'width:'+ porcentaje + '%'" style="background-color: #1c84c6"></div>
                            </div>
                            <small>
                                Se han dictado
                                <strong>
                                    @{{ estado_clase.completadas }}
                                </strong>
                                clases de @{{ estado_clase.total }} en total.
                            </small>
                        </div>
                    </div>
                </div>
            </div>   
        </div>
        <div class="col-lg-4">
            <div class="row">
                <div class="col-lg-6">
                    <a href="#" @click="asistenciaUrl" class="btn btn-block btn-success"><i class="fa fa-list"></i> Listado de asistencia</a>
                </div>
                <div class="col-lg-6" v-if="show_input_student">
                    <a href="#" @click="verSidebar=1;open_sidebar=true" class="btn btn-block btn-primary"><i class="fa fa-user-plus"></i> Agregar estudiantes</a>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Listado de clases</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content no-padding">
                            <ul class="list-group">
                                <li class="list-group-item" v-for="clase in clases">
                                    <a class="btn btn-sm right-sidebar-toggle pull-right" :class="clase.estado=='Terminado' ? 'btn-primary' : 'btn-success'" @click="verSidebar=2;verClase(clase)"> 
                                        <i v-if="clase.estado == 'Terminado'" class="fa fa-eye" data-toggle="tooltip" title="Ver clase"></i>
                                        <i v-else class="fa fa-list" data-toggle="tooltip" title="Asistencia"></i>
                                    </a>
                                    <h3>@{{ formato_fecha(clase.start) }}</h3>
                                    <p>Salón: @{{ clase.salon }}</p>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            {{-- <div class="ibox">
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
                                        <a class="btn right-sidebar-toggle" :class="clase.estado=='Terminado' ? 'btn-primary' : 'btn-success'" @click="verSidebar=2;verClase(clase)"> 
                                            @{{ (clase.estado == 'Terminado') ? 'Ver' : 'Asistencia' }}
                                        </a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div> --}}

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
                    <div id="calendar"></div>
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
