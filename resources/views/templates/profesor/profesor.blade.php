@extends('layouts.app')
@section('title', 'Profesor')
@section('content')
<div class="container" id="crud_profesor">
    <div class="row">
        <form id="formTerceros" enctype="multipart/form-data" class="form-horizontal" role="form" action="" method="post">
            <div class="col-lg-5">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>Registro de profesores</h5>
                        <div class="ibox-tools">
                        </div>
                    </div>
                    <div class="ibox-content" id="crudTercero">
                        <!--***** contenido ******-->
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.user_id}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Usuario:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <select name="user_id" id="user_id" class="form-control" v-model="user_id" @change="getDataUser" @click="deleteError('user_id')">
                                                <option value="">Ninguno</option>
                                                @foreach($user as $value)
                                                    <option value="{{ $value->id }}">{{ $value->name }}</option>
                                                @endforeach
                                            </select>
                                            <small id="msn1" class="help-block result-user_id" v-show="formErrors.user_id"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.nombre}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Nombre:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control" type="text" v-model="nombre" @click="deleteError('nombre')"/>
                                            <small id="msn1" class="help-block result-nombre" v-show="formErrors.nombre"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.apellidos}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Apellidos:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="text" v-model="apellidos" @click="deleteError('apellidos')">
                                            <small id="msn1" class="help-block result-apellidos" v-show="formErrors.apellidos"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.correo}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Correo:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="email" v-model="correo" @click="deleteError('correo')">
                                            <small id="msn1" class="help-block result-correo" v-show="formErrors.correo"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.direccion}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Dirección:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="text" v-model="direccion" @click="deleteError('direccion')">
                                            <small id="msn1" class="help-block result-direccion" v-show="formErrors.direccion"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.telefono}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Teléfono:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="text" v-model="telefono" @click="deleteError('telefono')">
                                            <small id="msn1" class="help-block result-telefono" v-show="formErrors.telefono"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.celular}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Celular:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="text" v-model="celular" @click="deleteError('celular')">
                                            <small id="msn1" class="help-block result-celular" v-show="formErrors.celular"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
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
        </form>
        <div class="col-lg-7">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5>Profesores</h5>
                    <div class="ibox-tools">

                    </div>
                </div>
                <div class="ibox-content">
                    <!--***** contenido ******-->
                    <div class="table-responsive">
                        <table id="tbl-profesor" class="table table-striped table-hover table-bordered">
                            <thead>
                                <tr>
                                    {{-- <th>Identificación</th> --}}
                                    <th>Nombre</th>
                                    <th>Correo</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                            <tfoot>
                                <tr>
                                    {{-- <th>Identificación</th> --}}
                                    <th>Nombre</th>
                                    <th>Correo</th>
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
<script src="{{ asset('js/profesor.js') }}"></script>
@endpush