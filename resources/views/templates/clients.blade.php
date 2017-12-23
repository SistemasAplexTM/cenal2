@extends('layouts.app')
@section('title', 'Clientes')
@section('content')
<div class="container" id="clients">
	<div class="row">
		<passport-personal-access-tokens></passport-personal-access-tokens>
		{{-- <div class="col-md-4">
			<form action="{{ url('oauth/personal-access-tokens') }}" method="POST">
				{{ csrf_field() }}
				<div class="row">
					<div class="col-md-12">
						<div class="form-group">
		                    <label for="">Nombre</label>
		                    <div class="input-group">
		                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
		                        <input name="name" type="text" class="form-control">
		                    </div>
		                </div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<input type="submit" class="btn btn-primary" name="send" value="Crear">
					</div>
				</div>

			</form>
		</div>
		<div class="col-md-8">
			<table class="table table-striped" id="tbl-clients">
				<thead>
					<tr>
						<th>Nombre</th>
						<th>Token</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="client in clients">
						<td>@{{ client.name }}</td>
						<td>@{{ client.accessToken }}</td>
						<td>
							<a href="#" class="btn btn-default btn-sm"><i class="fa fa-copy"></i></a>
							<a href="#" class="btn btn-default btn-sm"><i class="fa fa-trash"></i></a>
						</td>
					</tr>
				</tbody>
			</table>
		</div> --}}
	</div>
</div>
@stop
@push('scripts')
<script src="{{ asset('js/clients.js') }}"></script>
@endpush
