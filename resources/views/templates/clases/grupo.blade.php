@extends('layouts.app')
@section('title', 'Grupos')
@section('content')
<div class="container-fluid" id="grupos">
    <div class="row">
        <div class="col-lg-12">
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
    </div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/grupos.js') }}"></script>
@endpush