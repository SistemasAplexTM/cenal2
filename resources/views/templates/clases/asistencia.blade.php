@extends('layouts.app')
@section('title', 'Asistencia')
@section('content')
<div class="container-fluid" id="asistencia">
    <div class="ibox">
        <div class="ibox-content">
            <div class="row">
                <div class="col-lg-12 text-center">
                    {{-- <a href="{{ url()->previous() }}" class="btn btn-default pull-left"><i class="fa fa-arrow-left"></i> Volver</a> --}}
                    <i class="fa fa-calendar-check-o fa-5x pull-right" style="opacity: 0.1; z-index: -1"></i>
                    <h1>Módulo {{ $data->modulo }}</h1>
                    {!! "<span class='label label-".$data->clase_estado."'>".$data->estado."</span>" !!}
                </div>
            </div>
        </div>
    </div>

    <div class="ibox">
        <div class="ibox-title">
            <h5> Asistencia</h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    {{-- <button class="btn btn-success btn-xs pull-right"><i class="fa fa-file-pdf-o"></i> Exportar</button> --}}
                </a>
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-lg-12">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Estudiante</th>
                                <th v-for="clase in clases">@{{ formato_fecha(clase.start) }}</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(estudiante, cont) in estudiantes_inscritos">
                                <td>
                                   <h3>
                                        <i class="fa fa-barcode"></i>
                                        <strong>
                                       @{{ estudiante.codigo }}
                                            
                                        </strong>
                                       <br>
                                       <p>
                                            @{{ estudiante.nombre }}
                                       </p>
                                   </h3>
                                </td>
                                <th v-for="(clase, index) in clases">
                                    <template v-if="clase.estado == 'Terminado'">
                                        <div class="checkbox checkbox-danger" v-if="verificar_asistencia(clase.id,estudiante.id)">
                                            <input id="checkbox1" type="checkbox" checked="">
                                            <label for="checkbox1">
                                            </label>
                                        </div>
                                        <div class="checkbox checkbox-success" v-else>
                                            <input id="checkbox1" type="checkbox" checked="">
                                            <label for="checkbox1">
                                            </label>
                                        </div>
                                    </template>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/asistencia.js') }}"></script>
@endpush