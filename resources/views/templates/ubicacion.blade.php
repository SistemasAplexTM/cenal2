@extends('layouts.app')
@section('title', 'Ubicación')
@section('content')
<div class="container">
	<div class="row">
        <form class="form-horizontal" role="form" action="" method="post">
            <div class="col-lg-5">
            	<div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5><i class="fa fa-home"></i> Registro de ubicación</h5>
                    </div>
                    <div class="ibox-content" id="crud_ubicacion">
						<div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.nombre}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Nombre:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input name="nombre" v-model="nombre" class="form-control" @click="deleteError('nombre')">
                                            <small id="msn1" class="help-block result-nombre" v-show="formErrors.nombre"></small>
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
                                            <button id="guardar" class="ladda-button btn btn-success hvr-float-shadow" data-style="expand-right" @click.prevent="create()" v-if="editar==0"><i class="fa fa-floppy-o" aria-hidden="true"></i> Guardar</button>
                                            <button type="button" id="editar" class="ladda-button btn btn-info hvr-float-shadow" data-style="expand-right" @click.prevent="update()" v-if="editar==1"><i class="fa fa-edit" aria-hidden="true"></i> Editar</button>
                                            <a type="button" id="cancelar" class="btn btn-white hvr-float-shadow" @click.prevent="cancel()"  v-if="editar==1"><i class="fa fa-times fa-fw"></i> Cancelar</a>
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
                    <h5><i class="fa fa-list"></i> Ubicaciones</h5>
                    <div class="ibox-tools">

                    </div>
                </div>
                <div class="ibox-content">
                	<table class="table table-striped table-hover table-bordered" id="tbl-ubicacion">
						<thead>
							<tr>
								<th>Nombre</th>
								<th>Acciones</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
                </div>
            </div>
        </div>
	</div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/ubicacion.js') }}"></script>
@endpush