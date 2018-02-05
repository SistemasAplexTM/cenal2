@extends('layouts.app')
@section('title', 'Clases')
@section('content')
<div class="container" id="clases">
    <div class="row">
        <div class="ibox">
            <div class="ibox-title">
                <h5><i class="fa fa-calendar-plus-o"></i> Clases</h5>
            </div>
            <div class="ibox-content">
                <form action="{{ url('clases') }}" method="POST">
                    {{ csrf_field() }}
                    <div class="row">
                        <div class="col-lg-9">
                            <div class="row">
                                <div class="col-lg-9">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <label for="sede_id" class="control-label gcore-label-top">Sede:</label>
                                            <select name="sede_id" id="sede_id" class="form-control" required="">
                                                <option value="">Seleccione</option>
                                                @foreach($sedes as $sede)
                                                <option value="{{ $sede->id }}">{{ $sede->nombre }}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-3 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div id="data_1">
                                                <div class="input-group date">
                                                    <label for="fecha_inicio">Fecha de inicio:</label> 
                                                    <div class="input-group">
                                                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                                        <input name="fecha_inicio" id="fecha_inicio" type="text" placeholder="dd/mm/aaaa" class="form-control" required="">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-lg-5 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <label for="salon_id" class="control-label gcore-label-top">Salón:</label>
                                            <select name="salon_id" id="salon_id" class="form-control" @change="setCapacidad" required="">
                                                <option data-capacidad="" value="">Seleccione</option>
                                                @foreach($salones as $salon)
                                                <option data-capacidad="{{ $salon->capacidad }}" value="{{ $salon->id }}">{{ $salon->nombre }}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-3">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label>Capacidad: <small>(estudiantes)</small></label> 
                                                <input type="email" class="form-control" v-model="capacidad" readonly="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-4 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label>Ubicación:</label> 
                                                <input type="email" class="form-control" v-model="ubicacion" readonly="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-5 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <label for="modulo_id" class="control-label gcore-label-top">Módulo:</label>
                                            <select name="modulo_id" id="modulo_id" class="form-control" @click="deleteError('modulo')" required="">
                                                <option data-duracion="" value="">Seleccione</option>
                                                @foreach($modulos as $modulo)
                                                <option data-duracion="{{ $modulo->duracion }}" value="{{ $modulo->id }}">{{ $modulo->nombre }}</option>
                                                @endforeach
                                            </select>
                                            <small id="msn1" class="help-block result-modulo" v-show="formErrors.modulo"></small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="jornada_id">Jornada:</label> 
                                                <select name="jornada_id" id="jornada_id" class="form-control" @click="deleteError('modulo')" required="">
                                                    <option value="">Seleccione</option>
                                                    @foreach($jornadas as $jornada)
                                                    <option value="{{ $jornada->id }}">{{ $jornada->jornada }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-3 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="duracion">Duración: <small>(clases)</small></label> 
                                                <input name="duracion" id="duracion" type="number" class="form-control" v-model="duracion" required="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-lg-12 b-r">
                                   <div class="form-group">
                                        <label class="col-sm-2 control-label">Días de clase: </label>
                                        <div class="col-sm-10">
                                            <label class="checkbox-inline i-checks"> <input name="semena[1]" type="checkbox" value="1"> Lunes </label>
                                            <label class="checkbox-inline i-checks"> <input name="semena[2]" type="checkbox" value="2"> Martes </label>
                                            <label class="checkbox-inline i-checks"> <input name="semena[3]" type="checkbox" value="3"> Miércoles </label>
                                            <label class="checkbox-inline i-checks"> <input name="semena[4]" type="checkbox" value="4"> Jueves </label>
                                            <label class="checkbox-inline i-checks"> <input name="semena[5]" type="checkbox" value="5"> Viernes </label>
                                            <label class="checkbox-inline i-checks"> <input name="semena[6]" type="checkbox" value="6"> Sábado </label>
                                            <label class="checkbox-inline i-checks"> <input name="semena[7]" type="checkbox" value="7"> Domingo </label>
                                        </div>
                                    </div> 
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <p class="text-center">
                                <i class="fa fa-calendar big-icon"></i>
                            </p>
                            <div class="form-group">
                                <div class="col-sm-12">
                                <label for="observacion" >Obseración: </label>
                                    <textarea class="form-control" name="observacion" id="observacion" cols="30" rows="6"></textarea> 
                                </div>
                            </div> 
                        </div>
                    </div>
                    <hr>
                    <div class="row text-center">
                        {{-- <div class="col-lg-4"> --}}
                            <div class="form-group">
                                {{-- <div class="col-sm-12"> --}}
                                    <button type="submit" class="ladda-button btn btn-primary hvr-float-shadow" data-style="expand-right"><i class="fa fa-floppy-o" aria-hidden="true"></i> Guardar</button>
                                    <a href="{{ url('clases') }}" class="btn btn-white hvr-float-shadow"><i class="fa fa-times fa-fw"></i> Cancelar</a>
                                {{-- </div> --}}
                            </div>
                        {{-- </div> --}}
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/clases.js') }}"></script>
@endpush