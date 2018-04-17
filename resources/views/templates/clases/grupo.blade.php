@extends('layouts.app')
@section('title', 'Grupos')
@section('content')
<div class="container-fluid" id="grupos">
    <div class="row">
        <div class="col-lg-8">
            <div class="ibox">
                <div class="ibox-title">
                    <h5><i class="fa fa-calendar"></i> Módulos programados</h5>
                    <div class="ibox-tools">
                        @role('Coordinador')
                        <a href="{{ route('clases.create') }}" class="btn btn-success btn-sm"><i class="fa fa-calendar-plus-o"></i> Programar grupo</a>
                        @endrole
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="project-list">
                        <table class="table table-hover" id="tbl-grupos">
                            <thead>
                                <tr>
                                    <th>Acciones</th>
                                    <th>Grupo</th>
                                    <th>Inicio</th>
                                    <th>Estado</th>
                                    <th>Sede</th>
                                    <th><i title="Estudiantes inscritos" class="fa fa-group"></i></th>
                                    <th>Jornada</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th>Acciones</th>
                                    <th>Grupo</th>
                                    <th>Inicio</th>
                                    <th>Estado</th>
                                    <th>Sede</th>
                                    <th><i title="Estudiantes inscritos" class="fa fa-group"></i></th>
                                    <th>Jornada</th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="ibox">
                <div class="ibox-title" v-if="estudiantes_inscritos.length > 0">
                    Estudiantes inscritos - @{{ estudiantes_inscritos.length }}
                </div>
                <div class="ibox-title" v-else>
                    Inscribir estudiante
                </div>
                <div class="ibox-content">
                    <div class="feed-activity-list">
                        <div class="feed-element text-center">
                            <h4>@{{ grupo.nombre }}</h4>
                        </div>
                    </div>
                    <div class="feed-activity-list">
                        @role('Administrador')
                        <div class="feed-element">
                            <div class="form-group">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <i class="fa fa-user-plus">
                                        </i>
                                    </span>
                                    <input class="form-control" id="buscar_estudiante" name="buscar_estudiante" placeholder="Agregar estudiante - Código o Documento" type="text" v-model="dato_estudiante">
                                        <a @click.prevent="buscar_estudiante()" class="input-group-addon btn btn-primary" type="button">
                                            Buscar
                                        </a>
                                    </input>
                                </div>
                            </div>
                        </div>
                        @endrole
                    </div>
                    <ul class="todo-list m-t" v-show="view=='buscar'">
                        <div class="alert alert-primary text-center" v-show="estudiantes.length<=0">No hay resultados para la busqueda <br><br><button class="btn btn-xs" @click.prevent="view='inscritos';dato_estudiante=''">Aceptar</button></div>
                        {{-- <transition name="fade" :duration="8000"> --}}
                            <li class="" v-for="estudiante in estudiantes" v-show="estudiantes.length>0">
                                <span class="m-l-xs">
                                    <strong>@{{ estudiante.codigo }}</strong> - @{{ estudiante.nombre }} 
                                    <a v-show="btn_retirar==true" data-toggle="tooltip" title="Cancelar" class="btn btn-default btn-xs pull-right" @click.prevent="btn_confirm=true;btn_retirar=false"><i class="fa fa-times"></i></a>
                                    <a v-show="btn_retirar==true" data-toggle="tooltip" title="Confirmar retiro" class="btn btn-success btn-xs pull-right" @click.prevent="retirar_estudiante(estudiante.id)"><i class="fa fa-check"></i></a>
                                    <a v-show="estudiante.grupo_id == grupo.id&&btn_confirm==true" data-toggle="tooltip" title="Retirar estudiante" class="btn btn-danger btn-xs pull-right" @click.prevent="btn_confirm=false;btn_retirar=true"><i class="fa fa-times"></i></a>
                                    <a v-show="estudiante.grupo_id != grupo.id" data-toggle="tooltip" title="Agregar estudiante" class="btn btn-primary btn-xs pull-right" @click.prevent="agregar_estudiante(grupo.id,estudiante.id)"><i class="fa fa-check"></i></a>
                                    @{{ grupo_exist.id }}
                                    <br>
                                    <small v-if="Object.keys(grupo_exist).length !== 0">El estudiante ya pertenece al grupo @{{ grupo_exist.nombre }} 
                                        <a data-toggle="tooltip" title="Guardar" class="btn btn-default btn-xs" @click.prevent="setGrupo(grupo_exist.id, grupo_exist.nombre, estudiante.id)">Ver</a>
                                    </small>
                                </span>
                            </li>
                        {{-- </transition> --}}
                    </ul>
                    <ul class="todo-list m-t" v-show="view=='inscritos'">
                        <div class="alert alert-primary text-center" v-show="estudiantes_inscritos.length<=0">No hay estudiantes inscritos en este grupo
                            <br><br>
                            @role('Administrador')
                            <a data-toggle="tooltip" title="Guardar" class="btn btn-xs btn-default" @click.prevent="resaltarBuscar">Inscribir</a>
                        </div>
                            @endrole
                        <li :class="[isActiveStudent == estudiante.id ? 'active-student' : '']" v-for="estudiante in estudiantes_inscritos" v-show="estudiantes_inscritos.length>0">
                            <span class="m-l-xs">
                                <a v-show="btn_confirm==true" data-toggle="tooltip" title="Retirar estudiante" class="btn btn-danger btn-xs pull-right" @click.prevent="btn_confirm=false;btn_retirar=true"><i class="fa fa-times"></i></a>
                                <a v-show="btn_retirar==true" data-toggle="tooltip" title="Cancelar" class="btn btn-default btn-xs pull-right" @click.prevent="btn_confirm=true;btn_retirar=false"><i class="fa fa-times"></i></a>
                                <a v-show="btn_retirar==true" data-toggle="tooltip" title="Confirmar retiro" class="btn btn-success btn-xs pull-right" @click.prevent="retirar_estudiante(estudiante.id)"><i class="fa fa-check"></i></a>
                                <strong>@{{ estudiante.codigo }}</strong> - @{{ estudiante.nombre }}
                            </span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/grupos.js') }}"></script>
@endpush