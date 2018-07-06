@extends('layouts.app')
@section('title', 'Módulos')
@section('content')
<div class="container" id="crud_modulo">
	<div class="row">
		<div class="col-lg-6 col-lg-offset-3">
			<div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h3>Módulos</h3>
                </div>
                <div class="ibox-content">
                    <!--***** contenido ******-->
                	<div class="alert alert-danger" role="alert" v-show="JSON.stringify(formErrors)!='{}'">
                		<ul>
                			<li class="result-nombre"></li>
                		</ul>
					</div>
					<p>Haga click en el registro para activar la edición y presione la tecla <strong>Enter</strong> para actualizar.</p>
                <div class="table-responsive">
                    <table id="tbl-modulos" class="table table-striped table-hover table-bordered">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th width="15%">Acciones</th>
                            </tr>
                        </thead>
                        <tfoot class="table-foot">
                            <tr>
                                <th></th>
                                <th class="save"></th>
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
<script src="{{ asset('js/modulo.js') }}"></script>
@endpush