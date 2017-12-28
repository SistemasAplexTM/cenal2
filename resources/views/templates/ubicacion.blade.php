@extends('layouts.app')
@section('title', 'Ubicación')
@section('content')
<div class="container" id="crud_ubicacion">
	<h1 class="center">Ubicación</h1>
	<form action="">
		<div class="form-group" :class="{'has-error': formErrors.nombre}">
			<div class="input-group">
		      <input type="text" class="form-control" id="ubicacion" v-model="nombre" placeholder="Nombre de la ubicación..."  @click="deleteError('nombre')">
		      <div class="btn btn-primary input-group-addon" @click.prevent="create" v-if="editar==0">Agregar</div>
		      <div class="btn btn-primary input-group-addon" @click.prevent="update" v-if="editar==1">Actualizar</div>
		      <div class="btn btn-default input-group-addon"  @click.prevent="cancel" v-if="editar==1">Cancelar</div>
		    </div>
	      	<small class="help-block result-nombre" v-show="formErrors.nombre"></small>
		</div>
	</form>
	<table class="table table-stripped" id="tbl-ubicacion">
		<thead>
			<tr>
				<th>Item</th>
				<th>Nombre</th>
				<th>Acciones</th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/ubicacion.js') }}"></script>
@endpush