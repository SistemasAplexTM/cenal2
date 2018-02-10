@extends('layouts.app')
@section('title', 'Clases')
@section('content')
<div class="container" id="clases">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox">
                <div class="ibox-title">
                    <h5><i class="fa fa-calendar"></i> Clases</h5>
                    <div class="ibox-tools">
                        <a href="{{ route('clases.create') }}" class="btn btn-primary btn-sm"><i class="fa fa-calendar-plus-o"></i> Nueva clase</a>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="project-list">
                        <table class="table table-hover" id="tbl-clases">
                            <thead>
                                <tr>
                                    <th>Estado</th>
                                    <th>Módulo</th>
                                    <th>Salón</th>
                                    <th>Jornada</th>
                                    <th>Progreso</th>
                                    <th>Profesor</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                {{-- <tr>
                                    <td class="project-status">
                                        <span class="label label-primary">En curso</span>
                                    </td>
                                    <td class="project-title">
                                        <a href="{{ url('clases/1') }}">Múdolo Office</a>
                                        <br/>
                                        <small>Inició 01 enero 2018 - Termina 01 junio 2018</small>
                                    </td>
                                    <td>
                                        <p>Salón SI_01</p>
                                        <small>Estudiantes 10 / 15</small>
                                    </td>
                                    <td>
                                        <p>Diurno 7-10</p>
                                    </td>
                                    <td class="project-completion">
                                            <small>Conpletado: 48%</small>
                                            <div class="progress progress-mini">
                                                <div style="width: 48%;" class="progress-bar"></div>
                                            </div>
                                    </td>
                                    <td class="project-title">
                                        <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"> Ricardo Florez</a>
                                    </td>
                                    <td class="project-actions">
                                        <a href="#" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> Detalles </a>
                                        <a href="#" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Editar </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="project-status">
                                        <span class="label label-primary">En curso</span>
                                    </td>
                                    <td class="project-title">
                                        <a href="{{ url('clases/1') }}">Múdolo cultura física</a>
                                        <br/>
                                        <small>Inició 20 enero 2018 - Termina 31 mayo 2018</small>
                                    </td>
                                    <td>
                                        <p>Salón FI_01</p>
                                        <small>Estudiantes 10 / 15</small>
                                    </td>
                                    <td>
                                        <p>Diurno 7-10</p>
                                    </td>
                                    <td class="project-completion">
                                            <small>Conpletado: 20%</small>
                                            <div class="progress progress-mini">
                                                <div style="width: 20%;" class="progress-bar"></div>
                                            </div>
                                    </td>
                                    <td class="project-title">
                                        <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"> Julio Castañeda</a>
                                    </td>
                                    <td class="project-actions">
                                        <a href="#" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> Detalles </a>
                                        <a href="#" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Editar </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="project-status">
                                        <span class="label label-primary">En curso</span>
                                    </td>
                                    <td class="project-title">
                                        <a href="{{ url('clases/1') }}">Múdolo Office</a>
                                        <br/>
                                        <small>Inició 01 enero 2018 - Termina 01 junio 2018</small>
                                    </td>
                                    <td>
                                        <p>Salón SI_05</p>
                                        <small>Estudiantes 10 / 15</small>
                                    </td>
                                    <td>
                                        <p>Diurno 7-10</p>
                                    </td>
                                    <td class="project-completion">
                                            <small>Conpletado: 67%</small>
                                            <div class="progress progress-mini">
                                                <div style="width: 67%;" class="progress-bar"></div>
                                            </div>
                                    </td>
                                    <td class="project-title">
                                        <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"> Ricardo FLorez</a>
                                    </td>
                                    <td class="project-actions">
                                        <a href="#" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> Detalles </a>
                                        <a href="#" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Editar </a>
                                    </td>
                                </tr> --}}
                            </tbody>
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