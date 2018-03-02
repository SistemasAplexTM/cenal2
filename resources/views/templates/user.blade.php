@extends('layouts.app')
@section('title', 'Usuarios')
@section('content')
<div class="container-fluid" id="crud_profesor">
    <div class="row">
        <form id="formTerceros" enctype="multipart/form-data" class="form-horizontal" role="form" action="" method="post">
            <div class="col-lg-4">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>Registro de usuarios</h5>
                        <div class="ibox-tools">
                        </div>
                    </div>
                    <div class="ibox-content" id="crudTercero">
                        <!--***** contenido ******-->
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.identification_card}">
                                        <div class="col-sm-4">
                                            <label for="identification_card" class="control-label gcore-label-top">Documento:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control" type="text" v-model="identification_card" @click="deleteError('identification_card')"/>
                                            <small id="msn1" class="help-block result-identification_card" v-show="formErrors.identification_card"></small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.name}">
                                        <div class="col-sm-4">
                                            <label for="name" class="control-label gcore-label-top">Nombre:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control" type="text" v-model="name" @click="deleteError('name')"/>
                                            <small id="msn1" class="help-block result-name" v-show="formErrors.name"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.last_name}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Apellidos:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="text" v-model="last_name" @click="deleteError('last_name')">
                                            <small id="msn1" class="help-block result-last_name" v-show="formErrors.last_name"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.email}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Correo:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="email" v-model="email" @click="deleteError('email')">
                                            <small id="msn1" class="help-block result-email" v-show="formErrors.email"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.address}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Dirección:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="text" v-model="address" @click="deleteError('address')">
                                            <small id="msn1" class="help-block result-address" v-show="formErrors.address"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.phone}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Teléfono:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="text" v-model="phone" @click="deleteError('phone')">
                                            <small id="msn1" class="help-block result-phone" v-show="formErrors.phone"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.cellphone}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Celular:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="text" v-model="cellphone" @click="deleteError('cellphone')">
                                            <small id="msn1" class="help-block result-cellphone" v-show="formErrors.cellphone"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Sede:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <select name="sede" id="sede" class="form-control">
                                                <option value="">Seleccione</option>
                                                @foreach($sedes as $sede)
                                                    <option value="{{ $sede->id }}">{{ $sede->nombre }}</option>
                                                @endforeach
                                            </select>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Roles:</label>
                                        </div>
                                        <div class="col-sm-8">
                                        	<select name="roles[]" id="roles" class="form-control" multiple="">
                                        	</select>
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
	                                        <button id="guardar" class="ladda-button btn btn-primary hvr-float-shadow" data-style="expand-right" @click.prevent="create()" v-if="editar==0"><i class="fa fa-floppy-o" aria-hidden="true"></i> Guardar</button>
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
        <div class="col-lg-8">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5>Usuarios</h5>
                    <div class="ibox-tools">

                    </div>
                </div>
                <div class="ibox-content">
                    <!--***** contenido ******-->
                    <div class="table-responsive">
                        <table id="tbl-user" class="table table-striped table-hover table-bordered">
                            <thead>
                                <tr>
                                    <th>Identificación</th>
                                    <th>Nombre</th>
                                    <th>Correo</th>
                                    <th>Tipo</th>
                                    <th>Sede</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                            <tfoot>
                                <tr>
                                    <th>Identificación</th>
                                    <th>Nombre</th>
                                    <th>Correo</th>
                                    <th>Tipo</th>
                                    <th>Sede</th>
                                    <th>Acciones</th>
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
<script src="{{ asset('js/user.js') }}"></script>
@endpush