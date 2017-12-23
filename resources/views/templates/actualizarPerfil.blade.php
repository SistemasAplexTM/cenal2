@extends('layouts.app')
@section('title', 'Perfil')
@section('content')
<div class="row animated fadeInRight">
	<form action="{{ url('perfil/update') }}/{{ $data->id }}" method="POST">
         {{ csrf_field() }}
        <div class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <label for="">Nombre</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                        <input name="nombres" type="text" class="form-control" value="{{ $data->nombres }}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Primer apellido</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                        <input name="primer_apellido" type="text" class="form-control" value="{{ $data->primer_apellido }}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Segundo apellido</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                        <input name="segundo_apellido" type="text" class="form-control" value="{{ $data->segundo_apellido }}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Correo</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
                        <input name="correo" type="text" class="form-control" value="{{ $data->correo }}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Fecha de nacimiento</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                        <input name="fecha_nacimiento" type="text" class="form-control" value="{{ $data->fecha_nacimiento }}">
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <label for="">Documento</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-id-card-o"></i></span>
                        <input class="form-control" value="{{ $data->num_documento }}" readonly="">
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Lugar de expedición</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-map-marker"></i></span>
                        <input name="expedicion_documento" type="text" class="form-control" value="{{ $data->expedicion_documento }}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Dirección</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-map-marker"></i></span>
                        <input name="direccion" type="text" class="form-control" value="{{ $data->direccion }}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Celular</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-mobile-phone"></i></span>
                        <input name="tel_movil" type="text" class="form-control" value="{{ $data->tel_movil }}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Teléfono</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-phone"></i></span>
                        <input name="tel_fijo" type="text" class="form-control" value="{{ $data->tel_fijo }}">
                    </div>
                </div>
            </div>
            <div class="col-md-4">
            	<div class="form-group">
                    <label for="">Libreta militar</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-address-card"></i></span>
                        <input name="num_libreta" type="text" class="form-control" value="{{ $data->num_libreta }}">
                    </div>
                </div>
				<div class="form-group">
                    <label for="">Nivel de estudio</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-graduation-cap"></i></span>
                        <select name="nivel_academico_id" class="form-control">
                            @foreach($nivel_academico as $n_a)
                                <option value="{{ $n_a->id }}" {{ $n_a->id == $data->nivel_academico_id ? 'selected' : '' }}>
                                    {{ $n_a->descripcion }}
                                </option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Institución</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-university"></i></span>
                        <input name="institucion" type="text" class="form-control" value="{{ $data->institucion }}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Estado civil</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-blind"></i></span>
                        <select name="estado_civil_id" class="form-control">
                            @foreach($estado_civil as $e_c)
                                <option value="{{ $e_c->id }}" {{ $e_c->id == $data->estado_civil_id ? 'selected' : '' }}>
                                    {{ $e_c->descripcion }}
                                </option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="">Ocupación</label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-briefcase"></i></span>
                        <input name="ocupacion" type="text" class="form-control" value="{{ $data->ocupacion }}">
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
        	<div class="col-md-12">
		    	<a href="{{ url('perfil/index') }}" class="btn btn-default">Cancelar</a>
		    	<button type="submit" class="btn btn-success">Actualizar</button>
        	</div>
        </div>
    </form>
</div>
@endsection
@section('scripsts')
<script src="{{ asset('js/templates/perfil.js') }}"></script>
@endsection