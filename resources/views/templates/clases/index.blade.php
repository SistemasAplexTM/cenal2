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
                                        <h1>{{ $data->nombre }}</h1>
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
                                <div class="feed-element">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="table-responsive">
                                                <table class="table table-bordered">
                                                    <thead>
                                                        <tr>
                                                            <th class="text-center" colspan="7">Días de clase</th>
                                                        </tr>
                                                        <tr>
                                                            <th>Lunes</th>
                                                            <th>Martes</th>
                                                            <th>Miércoles</th>
                                                            <th>Jueves</th>
                                                            <th>Viernes</th>
                                                            <th>Sábado</th>
                                                            <th>Domingo</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <div class="checkbox checkbox-success checkbox-inline">
                                                                    <input type="checkbox" id="1" value="1" checked="" readonly="" disabled="">
                                                                    <label for="inlineCheckbox2"></label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="checkbox checkbox-success checkbox-inline">
                                                                    <input v-model="semana" type="checkbox" id="2" value="2" checked="" disabled="">
                                                                    <label for="2"></label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="checkbox checkbox-success checkbox-inline">
                                                                    <input v-model="semana" type="checkbox" id="3" value="3" checked="" disabled="">
                                                                    <label for="3"></label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="checkbox checkbox-success checkbox-inline">
                                                                    <input v-model="semana" type="checkbox" id="4" value="4" checked="" disabled="">
                                                                    <label for="4"></label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="checkbox checkbox-success checkbox-inline">
                                                                    <input v-model="semana" type="checkbox" id="5" value="5" checked="" disabled="">
                                                                    <label for="5"></label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="checkbox checkbox-success checkbox-inline">
                                                                    <input v-model="semana" type="checkbox" id="6" value="6" checked="" disabled="">
                                                                    <label for="6"></label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="checkbox checkbox-success checkbox-inline">
                                                                    <input v-model="semana" type="checkbox" id="7" value="7" checked="" disabled="">
                                                                    <label for="7"></label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
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
                                   <span class="badge badge-info" data-toggle='tooltip' title='Clases'>@{{ modulo.duracion }}</span>
                                   <i class="fa fa-check" v-if="terminados.includes(modulo.id)"></i>
                                   {{-- <i class="fa fa-times" v-else></i> --}}
                                    @{{ modulo.nombre }}
                              </li>
                            </ul>
                            {{-- <div class="feed-activity-list">
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
                            </div> --}}
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
                                    <td colspan="2" class="active">
                                        <div class="form-group">
                                            <label for="">Salón: </label>
                                            <select v-model="salon" type="date" class="form-control">
                                                <option value="">Seleccione</option>
                                                <option v-for="value in salones" :value="value.id">@{{ value.codigo }}</option>
                                            </select>
                                        </div>
                                    </td>
                                    <th colspan="4" class="active">
                                        Excepto - 
                                        <div class="form-group">
                                            <label for="">Desde: </label>
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <i class="fa fa-calendar"></i>
                                                </span>
                                                <input v-model="desde" type="date" placeholder="dd/mm/aaaa" class="form-control">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="">Hasta: </label>
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <i class="fa fa-calendar"></i>
                                                </span>
                                                <input v-model="hasta" type="date" placeholder="dd/mm/aaaa" class="form-control">
                                            </div>
                                        </div>
                                    </th>
                                </tr>
                                <tr>
                                    <th colspan="6" class="text-center active">
                                        <button @click.prevent="programar_sgte_modulo()" class="btn btn-primary" data-toggle="tooltip" title="Programar siguiente módulo">
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