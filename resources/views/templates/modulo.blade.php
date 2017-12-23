@extends('layouts.app')
@section('title', 'Módulos')
@section('content')
<div class="container" id="crud_modulo">
	<h1 class="center">Módulos</h1>
	<form action="">
		<div class="form-group">
			<div class="input-group">
		      <input type="text" class="form-control" id="modulo" v-model="nombre" placeholder="Nombre de módulo...">
		      <div class="btn btn-primary input-group-addon" @click.prevent="store">Agregar</div>
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