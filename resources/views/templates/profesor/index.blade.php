@extends('layouts.app')
@section('title', 'Clases')
@section('content')
<div class="container-fluid">
	<div class="row">
		<div class="col-lg-4">
            <div class="ibox float-e-margins">
            	<div class="ibox-title">
                    <h5>Datos para el profesor</h5>
                </div>
                <div class="ibox-content">
                    <div class="feed-activity-list">
                        <div class="feed-element">
                        </div>
                        <div class="feed-element" v-for="estudiante in estudiantes_inscritos">
                            <div class="feed-element">
                                <a href="#" class="pull-left">
                                    {{-- <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"> --}}
                                </a>
                                <div class="media-body" v-if="">
                                    <strong>@{{ estudiante.nombre }}</strong><br>
                                    <small class="text-muted"><strong>Asistencia:</strong> @{{ estudiante.cant_asistencias }} / 10</small><br>
                                    <small class="text-muted"><strong>Programa:</strong> @{{ estudiante.programa }}</small>
                                </div>
                            </div>    
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
        	<div class="ibox float-e-margins">
            	<div class="ibox-title">
                    <h5>Clases</h5>
                </div>
				<div class="ibox-content">
				    <div id="calendar"></div>
				</div>
			</div>
        </div>
	</div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/clases_profesor.js') }}"></script>
@endpush