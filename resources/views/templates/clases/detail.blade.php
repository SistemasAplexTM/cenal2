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
                        <div class="col-xs-4 col-xs-offset-2">
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
                        <div class="col-xs-4">
                            <small class="stats-label">
                               <i class="fa fa-home"></i> Salón
                            </small>
                            <h4>
                                {{ $data->salon }}
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
                        <div class="col-xs-4">
                            <small class="stats-label">
                               <i class="fa fa-group"></i>  Cupos totales
                            </small>
                            <h4>
                                {{ $data->capacidad }}
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
                                    <a href="">
                                        <h3>
                                            <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
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
                                {!! "<div class='progress-bar' style='width: ".$porcentaje."%;'></div>" !!}
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
                                    <p>
                                        2175023
                                    </p>
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
                        <div class="feed-element">
                            <h5 class="text-center">
                                Estudiantes inscritos
                            </h5>
                        </div>
                        <div class="feed-element" v-for="estudiante in estudiantes_inscritos">
                            <a class="pull-left" href="#">
                                <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                                </img>
                            </a>
                            <div class="media-body ">
                                <strong>
                                    @{{ estudiante.codigo }} - @{{ estudiante.nombre }}
                                </strong>
                                <br>
                                    <small class="text-muted">
                                        <strong>
                                            Asistencia:
                                        </strong>
                                        @{{ estudiante.cant_asistencias }} / {{ $data->total }}
                                    </small>
                                    <br>
                                        <small class="text-muted">
                                            <strong>
                                                Programa:
                                            </strong>
                                            @{{ estudiante.programa }}
                                        </small>
                                    </br>
                                </br>
                            </div>
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
                        Inscribir estudiante
                    </h4>
                    <small class="font-bold">
                        Seleccion un estudiante para inscribirlo a todas las clases del Módulo {{ $data->modulo }}.
                    </small>
                </div>
                <div class="modal-body">
                    <table class="table table-hover table-bordered">
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
                            </th>
                        </tr>
                        <tr v-for="value in estudiantes">
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
                            <h2>Listado de asistencia</h2>
                            <small>Indique la asistencia</small>
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
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/clases.js') }}">
</script>
@endpush
