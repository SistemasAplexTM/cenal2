@extends('layouts.app')
@section('title', 'Programas')
@section('content')
<div class="container" id="crud_programas">
    <div class="row">
        <form class="form-horizontal" role="form" action="" method="post">
            <div class="col-lg-5">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>Registro de programas</h5>
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
                                            <label for="nombre" class="control-label gcore-label-top">Nombre:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <input value="" placeholder="" id="nombre" class="form-control" type="text" v-model="nombre" @click="deleteError('nombre')"/>
                                            <small id="msn1" class="help-block result-nombre" v-show="formErrors.nombre"></small>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row" v-show="editar==0">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.sedes}" @click="deleteError('sedes')">
                                        <div class="col-sm-4">
                                            <label @click="deleteError('sedes')" for="sedes" class="control-label gcore-label-top">Sedes:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <select name="sedes[]" id="sedes" data-placeholder="Seleccione..." multiple="multiple" class="form-control" @click="deleteError('sedes')" @focus="deleteError('sedes')">
                                            </select>
                                            <small id="msn1" class="help-block result-sedes" v-show="formErrors.sedes"></small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="col-lg-12">
                                    <div class="form-group" :class="{'has-error': formErrors.modulos}">
                                        <div class="col-sm-4">
                                            <label for="" class="control-label gcore-label-top">Módulos:</label>
                                        </div>
                                        <div class="col-sm-8">
                                            <v-select multiple :options="modulos.items" label="name" v-model="modulos_selected">
                                                <template slot="option" slot-scope="option">
                                                    @{{ option.name }} <br> 
                                                    <span class="fa fa-clock-o"></span>
                                                    @{{ option.duracion }} (Clases)
                                                </template>
                                                <template slot="selected-option" scope="option">
                                                  <div class="selected d-center">
                                                    @{{ option.name }} (@{{ option.duracion }})
                                                  </div>
                                                </template>
                                              </v-select>
                                            {{-- <select name="modulos[]" id="modulos" data-placeholder="Seleccione..." multiple="multiple" class="form-control js-example-basic-multiple" @click="deleteError('modulos')"></select> --}}
                                            <small id="msn1" class="help-block result-modulos" v-show="formErrors.modulos"></small>
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
                                            <button type="button" id="editar" class="ladda-button btn btn-primary hvr-float-shadow" data-style="expand-right" @click.prevent="store_module()" v-if="editar==2"><i class="fa fa-plus" aria-hidden="true"></i> Agregar</button>
                                            <a type="button" id="cancelar" class="btn btn-white hvr-float-shadow" @click.prevent="cancel()"  v-if="editar==1||editar==2"><i class="fa fa-times fa-fw"></i> Cancelar</a>
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
                    <h5>Programas</h5>
                    <div class="ibox-tools">

                    </div>
                </div>
                <div class="ibox-content">
                    <!--***** contenido ******-->
                    <div class="table-responsive">
                        <table id="tbl-programas" class="table table-striped table-hover table-bordered">
                            <thead>
                                <tr>
                                    <th>Sede</th>
                                    <th>Programa</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                            <tfoot>
                                <tr>
                                    <th>Sede</th>
                                    <th>Programa</th>
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
<script src="{{ asset('js/programas.js') }}"></script>
@endpush