@extends('layouts.app')
@section('title', 'Módulos')
@section('content')
<div class="container" id="crud_modulo">
	<div class="row">
		<form class="form-horizontal" role="form" action="" method="post">
			<div class="col-lg-5">
				<div class="ibox float-e-margins">
	                <div class="ibox-title">
	                    <h5><i class="fa fa-puzzle-piece"></i> Módulo</h5>
	                    <div class="ibox-tools">

	                    </div>
	                </div>
	                <div class="ibox-content">
	                    <!--***** contenido ******-->
							<div class="row">
	                            <div class="col-lg-12">
	                                <div class="col-lg-12">
	                                    <div class="form-group" :class="{'has-error': formErrors.nombre}">
	                                        <div class="col-sm-4">
	                                            <label for="" class="control-label gcore-label-top">Nombre:</label>
	                                        </div>
	                                        <div class="col-sm-8">
	                                            <input type="text" class="form-control" id="modulo" v-model="nombre" @click="deleteError('nombre')">
	                                            <small id="msn1" class="help-block result-nombre" v-show="formErrors.nombre"></small>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	                        <div class="row">
	                            <div class="col-lg-12">
	                                <div class="col-lg-12">
	                                    <div class="form-group" :class="{'has-error': formErrors.duracion}">
	                                        <div class="col-sm-4">
	                                            <label for="" class="control-label gcore-label-top">Duracion:</label>
	                                        </div>
	                                        <div class="col-sm-8">
	                                            <input type="text" class="form-control" id="modulo" v-model="duracion" @click="deleteError('duracion')">
	                                            <small id="msn1" class="help-block result-duracion" v-show="formErrors.duracion"></small>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	                        <div class="row">
	                            <div class="col-lg-12">
	                                <div class="col-lg-12">
	                                    <div class="form-group">
	                                        <div class="col-sm-12 col-sm-offset-0 guardar">
	                                            <button id="guardar" class="ladda-button btn btn-success hvr-float-shadow" data-style="expand-right" @click.prevent="store" v-if="editar==0"><i class="fa fa-floppy-o" aria-hidden="true"></i> Guardar</button>
	                                            <button type="button" id="editar" class="ladda-button btn btn-info hvr-float-shadow" data-style="expand-right" @click.prevent="update" v-if="editar==1"><i class="fa fa-edit" aria-hidden="true"></i> Editar</button>
	                                            <a type="button" id="cancelar" class="btn btn-white hvr-float-shadow" @click.prevent="cancel"  v-if="editar==1"><i class="fa fa-times fa-fw"></i> Cancelar</a>
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	                </div>
	            </div>
			</div>
		</form>
		<div class="col-lg-7">
			<div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5><i class="fa fa-list"></i> Módulos</h5>
                    <div class="ibox-tools">

                    </div>
                </div>
                <div class="ibox-content">
                    <!--***** contenido ******-->
                    <div class="table-responsive">
                        <table id="tbl-modulos" class="table table-striped table-hover table-bordered">
                            <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Duración <small>(clases)</small></th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tfoot style="display: table-header-group;">
                                <tr>
                                    <th>Nombre</th>
                                    <th>Duración <small>(clases)</small></th>
                                    <th class="none">Acciones</th>
                                </tr>
                            </tfoot>
                            <tbody>
                            </tbody>
                            {{-- <tfoot>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Duración <small>(clases)</small></th>
                                    <th>Acciones</th>
                                </tr>
                            </tfoot> --}}
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