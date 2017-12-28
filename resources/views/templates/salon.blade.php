@extends('layouts.app')
@section('title', 'Profesor')
@section('content')
<div class="container" id="crud_salon">
    <div class="row">
        <form class="form-horizontal" role="form" action="" method="post">
            <div class="col-lg-5">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>Registro de salones</h5>
                        <div class="ibox-tools">
                        </div>
                    </div>
                    <div class="ibox-content" id="crudTercero">
                        <!--***** contenido ******-->
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
                                    <div class="form-group" :class="{'has-error': formErrors.codigo}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Código:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" class="form-control validarInputs" type="text" v-model="codigo" @click="deleteError('codigo')">
                                            <small id="msn1" class="help-block result-codigo" v-show="formErrors.codigo"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.capacidad}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Capacidad:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="Cantidad de estudiantes" class="form-control" type="number" v-model="capacidad" @click="deleteError('capacidad')">
                                            <small id="msn1" class="help-block result-capacidad" v-show="formErrors.capacidad"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <div class="col-sm-12 col-sm-offset-0 guardar">
                                        <button id="guardar" class="ladda-button btn btn-warning hvr-float-shadow" data-style="expand-right" @click.prevent="create()" v-if="editar==0"><i class="fa fa-floppy-o" aria-hidden="true"></i> Guardar</button>
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
                    <h5>Salones</h5>
                    <div class="ibox-tools">

                    </div>
                </div>
                <div class="ibox-content">
                    <!--***** contenido ******-->
                    <div class="table-responsive">
                        <table id="tbl-salon" class="table table-striped table-hover table-bordered">
                            <thead>
                                <tr>
                                    {{-- <th>Identificación</th> --}}
                                    <th>Nombre</th>
                                    <th>Código</th>
                                    <th>Capacidad</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                            <tfoot>
                                <tr>
                                    {{-- <th>Identificación</th> --}}
                                    <th>Nombre</th>
                                    <th>Código</th>
                                    <th>Capacidad</th>
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
<script src="{{ asset('js/salon.js') }}"></script>
@endpush