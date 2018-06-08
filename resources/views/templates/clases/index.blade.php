@extends('layouts.app')
@section('title', 'Módulos programados')
@section('content')
<div class="container-fluid" id="clases">
    <div class="row">
        <div class="col-lg-4">
            <div class="row">
                <div class="col-lg-4">
                    <a href="{{ url('grupos') }}" class="btn btn-block btn-default"><i class="fa fa-arrow-left"></i> Volver</a>
                </div>
            </div>
            <br>
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="feed-activity-list">
                                <div class="feed-element">
                                    <div class="media-body text-center">
                                        <h3>{{ $data->nombre }}</h3>
                                    </div>
                                </div>
                            </div>
                            <br>
                            <div class="feed-activity-list">
                                <div class="feed-element">
                                    <div class="row">
                                        <div class="col-lg-6">
                                            <p>Sede: <strong>{{ $data->sede }}</strong></p>
                                        </div>
                                        <div class="col-lg-6">
                                            <p>Jornada: <strong>{{ $data->jornada }}</strong></p>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-6">
                                            <p>Estudiantes inscritos: <strong>{{ $data->cantidad }}</strong></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <br>
                            <ul class="list-group">
                                <li class="list-group-item active">
                                    Módulos
                                </li>
                              <li v-for="modulo in modulos" class="list-group-item">
                                   <span class="badge" data-toggle='tooltip' title='Clases'>@{{ modulo.duracion }}</span>
                                   <i class="fa fa-check" v-if="terminados.includes(modulo.id)"></i>
                                   {{-- <i class="fa fa-times" v-else></i> --}}
                                    @{{ modulo.nombre }}
                              </li>
                            </ul>
                            <div class="feed-activity-list">
                                <div class="feed-element">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <h4 class="text-center">Estudiantes inscritos</h4>
                                            <ul class="todo-list m-t">
                                                <div class="alert alert-primary text-center" v-show="Object.keys(estudiantes_inscritos).length == 0">
                                                    No hay estudiantes inscritos en este grupo
                                                </div>
                                                <li v-for="estudiante in estudiantes_inscritos" v-show="estudiantes_inscritos.length>0">
                                                    <span class="m-l-xs">
                                                        <strong>@{{ estudiante.codigo }}</strong> - @{{ estudiante.nombre }}
                                                    </span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                        
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="ibox">
                <div class="ibox-title">
                    <h5><i class="fa fa-calendar"></i> Módulos programados</h5>
                </div>
                <div class="ibox-content">
                    <div class="project-list">
                        <table class="table table-hover" id="tbl-clases">
                            <thead>
                                <tr>
                                    <th>Acciones</th>
                                    <th>Módulo</th>
                                    <th><small>Salón/Capacidad</small></th>
                                    <th>Estado</th>
                                    <th>Progreso</th>
                                    @role('Profesor')
                                    <th></th>
                                    @else
                                    <th>Profesor</th>
                                    @endrole
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="6" class=" active">
                                        Excepto - 
                                        <div class="form-group">
                                            <label for="">Desde: </label>
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <i class="fa fa-calendar"></i>
                                                </span>
                                                <input type="date" placeholder="dd/mm/aaaa" class="form-control">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="">Hasta: </label>
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <i class="fa fa-calendar"></i>
                                                </span>
                                                <input type="date" placeholder="dd/mm/aaaa" class="form-control">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="">Salón: </label>
                                            <select type="date" class="form-control">
                                                <option value="">Seleccione</option>
                                            </select>
                                        </div>
                                    </th>
                                </tr>
                                <tr>
                                    <th colspan="6" class="text-center active">
                                        <button @click.prevent="programar_sgte_modulo()" class="btn" data-toggle="tooltip" title="Programar siguiente módulo">
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/clases.js') }}"></script>
@endpush