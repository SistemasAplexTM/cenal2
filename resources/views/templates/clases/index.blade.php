@extends('layouts.app')
@section('title', 'Módulos programados')
@section('content')
<div class="container-fluid" id="clases">
    <div class="row">
        <div class="col-lg-12">
            <h3>NOMBRE DEL GRUPO</h3> 
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
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
                                    <th>Estado</th>
                                    {{-- @role('Administrador') --}}
                                    <th>Sede</th>
                                    <th><i title="Estudiantes inscritos" class="fa fa-group"></i></th>
                                    {{-- @endrole --}}
                                    <th><small>Salón/Capacidad</small></th>
                                    <th>Jornada</th>
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
                                    <th>Acciones</th>
                                    <th>Módulo</th>
                                    <th>Estado</th>
                                    {{-- @role('Administrador') --}}
                                    <th>Sede</th>
                                    <th><i title="Estudiantes inscritos" class="fa fa-group"></i></th>
                                    {{-- @endrole --}}
                                    <th><small>Salón/Capacidad</small></th>
                                    <th>Jornada</th>
                                    <th>Progreso</th>
                                    @role('Profesor')
                                    <th></th>
                                    @else
                                    <th>Profesor</th>
                                    @endrole
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="mdl-agregar-estudiante" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Agregar estudiante a la clase</h4>
      </div>
      <div class="modal-body">
        <div class="ibox">
            <div class="ibox-title">
                <h5><i class="fa fa-calendar-plus-o"></i> Clases</h5>
            </div>
            <div class="ibox-content">
                <h3>Módulo Office</h3>
                <small>Inicio: 01 enero 2018 - fin: 05 junio 2018</small>
            </di>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary">Agregar</button>
      </div>
    </div>
  </div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/clases.js') }}"></script>
@endpush