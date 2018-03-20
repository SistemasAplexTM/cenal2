@extends('layouts.app')
@section('title', 'Clases')
@section('content')
<div class="container-fluid" id="clases">
    <div class="row animated fadeInDown">
        <div class="col-lg-4">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    {!! "
                    <span class='label label-".$data->clase_estado." pull-right'>
                        ".$data->estado."
                    </span>
                    " !!}
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
                        <div class="col-xs-8">
                            <small class="stats-label">
                               <i class="fa fa-home"></i> Salón &nbsp;&nbsp;&nbsp; / &nbsp;&nbsp;&nbsp;<i class="fa fa-group"></i> Capacidad
                            </small>
                            <h4>
                                {!! str_replace(',', '<br>', $data->salon) !!}
                            </h4>
                        </div>
                        <div class="col-xs-4">
                            <small class="stats-label">
                               <i class="fa fa-group"></i> Cupos usados
                            </small>
                            <h4>
                                {{ $data->cupos_usados }}
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
            </div>
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="feed-activity-list">
                        @role('Administrador')
                        <div class="feed-element">
                            <div class="form-group">
                                <div class="col-lg-12">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <i class="fa fa-user-plus">
                                            </i>
                                        </span>
                                        <input class="form-control" id="burcar_estudiante" name="burcar_estudiante" placeholder="Agregar estudiante" type="text" v-model="dato_estudiante">
                                            <a @click.prevent="buscar_estudiante()" class="input-group-addon btn btn-primary" type="button">
                                                Buscar
                                            </a>
                                        </input>
                                    </div>
                                </div>
                            </div>
                        </div>
                        @endrole
                        <div class="feed-element text-center">
                            <h5>
                                Estudiantes inscritos - @{{ estudiantes_inscritos.length }}
                            </h5>
                            <a class="btn btn-sm btn-block btn-success right-sidebar-toggle">
                                <i class="fa fa-list"></i> Ver estudiantes
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
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
                    <div id="calendar">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div aria-hidden="true" class="modal inmodal" id="mdl_agregar_estudiante" role="dialog" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content animated bounceInRight">
                <div class="modal-header">
                    <button class="close" data-dismiss="modal" type="button">
                        <span aria-hidden="true">
                            ×
                        </span>
                        <span class="sr-only">
                            Close
                        </span>
                    </button>
                    <h4 class="modal-title">
                        Inscribir estudiante
                    </h4>
                    <small class="font-bold">
                        Seleccion un estudiante para inscribirlo a todas las clases del Módulo {{ $data->modulo }}.
                    </small>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <div class="input-group">
                          <input type="text" class="form-control" id="dato_buscar" v-model="dato_buscar" placeholder="Buscar estudiante..." @keyup="buscar_estudiante_modal()">
                          <span class="input-group-addon"><i class="fa fa-search"></i></span>
                        </div>
                    </div>
                    <table class="table table-hover table-bordered" id="tbl_add_student">
                        <tr>
                            <th>
                                Consecutivo
                            </th>
                            <th>
                                Nombre
                            </th>
                            <th>
                                Apellidos
                            </th>
                            <th>
                                @{{ dato_buscar }}
                            </th>
                        </tr>
                        <tr v-for="result in estudiantes_result" v-if="dato_buscar.length>0">
                            <td>
                                @{{ result.consecutivo }}
                            </td>
                            <td>
                                @{{ result.nombres }}
                            </td>
                            <td>
                                @{{ result.primer_apellido + ' ' + result.segundo_apellido }}
                            </td>
                            <td>
                                <button @click.prevent="agregar_estudiante(result.id)" class="btn btn-xs btn-primary" data-loading-text="Agregando..." id="agregar" type="button">
                                    <i class="fa fa-add">
                                    </i>
                                    Agregar
                                </button>
                            </td>
                        </tr>
                        <tr v-for="value in estudiantes" v-if="dato_buscar.length<=0">
                            <td>
                                @{{ value.consecutivo }}
                            </td>
                            <td>
                                @{{ value.nombres }}
                            </td>
                            <td>
                                @{{ value.primer_apellido + ' ' + value.segundo_apellido }}
                            </td>
                            <td>
                                <button @click.prevent="agregar_estudiante(value.id)" class="btn btn-xs btn-primary" data-loading-text="Agregando..." id="agregar" type="button">
                                    <i class="fa fa-add">
                                    </i>
                                    Agregar
                                </button>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer ">
                    <button class="btn btn-white " data-dismiss="modal" type="button">
                        Cerrar
                    </button>
                    {{--
                    <button class="btn btn-primary " type="button">
                        Aceptar
                    </button>
                    --}}
                </div>
            </div>
        </div>
    </div>
    <div aria-hidden="true" class="modal inmodal" id="mdl_asignar_profesor" role="dialog" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content animated bounceInRight">
                <div class="modal-header">
                    <button class="close" data-dismiss="modal" type="button">
                        <span aria-hidden="true">
                            ×
                        </span>
                        <span class="sr-only">
                            Close
                        </span>
                    </button>
                    <h4 class="modal-title">
                        Asignar profesor
                    </h4>
                    <small class="font-bold">
                        Seleccion un profesor para asignarlo a todas las clases del Módulo {{ $data->modulo }}.
                    </small>
                </div>
                <div class="modal-body">
                    <div class="alert alert-success text-center" v-if="profesores.length <= 0">
                       <i class="fa fa-exclamation-circle"></i> No hay resutados
                    </div>
                    <table class="table table-hover table-bordered" v-if="profesores.length > 0">
                        <tr>
                            <th>Nombres</th>
                            <th>Apellidos</th>
                            <th>Correo</th>
                            <th></th>
                        </tr>
                        <tr v-for="profesor in profesores">
                            <td>
                                @{{ profesor.name }}
                            </td>
                            <td>
                                @{{ profesor.last_name }}
                            </td>
                            <td>
                                @{{ profesor.email }}
                            </td>
                            <td>
                                <button @click.prevent="asignar_profesor(profesor.id)" class="btn btn-xs btn-primary" data-loading-text="Agregando..." id="asignar" type="button">
                                    <i class="fa fa-add">
                                    </i>
                                    Asignar
                                </button>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer ">
                    <button class="btn btn-white " data-dismiss="modal" type="button">
                        Cerrar
                    </button>
                    {{--
                    <button class="btn btn-primary " type="button">
                        Aceptar
                    </button>
                    --}}
                </div>
            </div>
        </div>
    </div>
    <!-- Modal -->
    <div aria-labelledby="myModalLabel" class="modal fade" id="mdl_clase" role="dialog" tabindex="-1" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button aria-label="Close" class="close" data-dismiss="modal" type="button">
                        <span aria-hidden="true">
                            ×
                        </span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        Clase {{ $data->modulo }}
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="ibox float-e-margins">
                        <div class="ibox-content">
                            <div class="row">
                                <div class="col-md-6">
                                    <p>
                                        <i class="fa fa-calendar"></i> Clase: <strong>{{ $data->modulo }}</strong>
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <span>
                                        <i class="fa fa-home"></i> Salón: <strong>@{{ salon }}</strong>
                                        <div class="btn-group pull-right" v-if="cambiar_salon==true">
                                            <a href="#" data-toggle="dropdown" class="dropdown-toggle" aria-expanded="true" title="Opciones"><i class="fa fa-ellipsis-h"></i></a>
                                            <ul class="dropdown-menu">
                                                <li><a href="#"><i class="fa fa-map-marker"></i> Ubicación</a></li>
                                                <li><a href="#"><i class="fa fa-group"></i> Capacidad</a></li>
                                                <li v-if="estado!='Terminado'"  class="divider"></li>
                                                <li v-if="estado!='Terminado'" ><a href="#" @click.prevent="editar_salon=1"><i class="fa fa-edit"></i> Cambiar salón</a></li>
                                            </ul>
                                        </div>
                                        <span class="input-group" v-if="editar_salon==1">
                                            <select name="salon_id" id="salon_id" v-model="salon_id" class="form-control" >
                                                <option v-for="salon in salones" v-bind:value="salon.id">
                                                    @{{ salon.codigo }}
                                                </option>
                                            </select>
                                            <span class="input-group-addon">
                                                <a href="#" @click.prevent="changeSalon()">
                                                    <i class="fa fa-save"></i>
                                                </a>
                                            </span>
                                            <span class="input-group-addon">
                                                <a href="#" @click.prevent="editar_salon=0">
                                                    <i class="fa fa-close"></i>
                                                </a>
                                            </span>
                                        </span>
                                    </span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <p>
                                        <i class="fa fa-clock-o"></i> Hora de inicio: <strong>{{ date("H:i", strtotime($data->inicio_jornada)) }}</strong>
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <p>
                                        <i class="fa fa-clock-o"></i> Hora de fin: <strong>{{ date("H:i", strtotime($data->fin_jornada)) }}</strong>
                                    </p>
                                </div>
                            </div>
                        </div>
                        @role('Profesor')
                        <div class="ibox-content">
                            <h3>Listado de asistencia</h3>
                            <form action="">
                                <ul class="todo-list m-t small-list">
                                    @foreach($estudiantes_inscritos AS $estudiante)
                                    <li class="estudiante_list">
                                        <input type="text" hidden="" id="clase_detalle">
                                        <label class="checkbox-inline i-checks check-link estudiante_asistencia">
                                            <input name="asistencia[]" id="input-asistencia{{ $estudiante->id }}" type="checkbox" value="{{ $estudiante->id }}" >  
                                            <span class="m-l-xs asistencia">{{ $estudiante->codigo }} - {{ $estudiante->nombre }}</span>
                                        </label>
                                    </li>
                                    @endforeach
                                </ul>
                            </form>
                        </div>
                        @endrole
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" data-dismiss="modal" type="button">
                        Cerrar
                    </button>
                    <button id="guardar_asistencia" class="ladda-button btn btn-primary" data-style="slide-down" type="button" @click.prevent="set_estudiante_asistencia()">
                        Guardar
                    </button>
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
