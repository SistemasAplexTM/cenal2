@extends('layouts.app')
@section('title', 'Módulos')
@section('content')
<div class="container" id="crud_modulo">
	<h1 class="center">Módulos</h1>
	<form action="">
		<div class="form-group" :class="{'has-error': formErrors.nombre}">
			<div class="input-group">
		      <input type="text" class="form-control" id="modulo" v-model="nombre" placeholder="Nombre de módulo...">
		      <div class="btn btn-primary input-group-addon" @click.prevent="store" v-if="editar==0">Agregar</div>
		      <div class="btn btn-primary input-group-addon" @click.prevent="update" v-if="editar==1">Actualizar</div>
		      <div class="btn btn-default input-group-addon"  @click.prevent="cancel" v-if="editar==1">Cancelar</div>
		      <small class="help-block result-nombre" v-show="formErrors.nombre"></small>
		    </div>
		</div>
	</form>
	<table class="table table-stripped" id="tbl-modulos">
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
<script src="{{ asset('js/modulo.js') }}"></script>
@endpush