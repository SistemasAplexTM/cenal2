@extends('layouts.app')
@section('title', 'Módulos')
@section('content')
<div class="container" id="crud_modulo">
	<div class="row">
		<div class="col-lg-6 col-lg-offset-3">
			<div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5><i class="fa fa-puzzle-piece"></i> Módulos</h5>
                    <div class="ibox-tools">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="true">
                            <i class="fa fa-ellipsis-h"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-user">
                            <li><a href="#" onclick="getTable('a')"><i class="fa fa-list"></i> Ver</a>
                            <li><a href="#" onclick="getTable('b')"><i class="fa fa-trash"></i> Ver eliminados</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="ibox-content">
                    <!--***** contenido ******-->
                	<div class="alert alert-danger" role="alert" v-show="JSON.stringify(formErrors)!='{}'">
                		<ul>
                			<li class="result-nombre"></li>
                			<li class="result-duracion"></li>
                		</ul>
					</div>
					<p>Haga click en el registro para activar la edición y presione la tecla <strong>Enter</strong> para actualizar.</p>
                    <div class="table-responsive">
                        <table id="tbl-modulos" class="table table-striped table-hover table-bordered">
                            <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Duración <small>(clases)</small></th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tfoot class="table-foot">
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th class="none"></th>
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