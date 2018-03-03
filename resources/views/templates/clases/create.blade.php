@extends('layouts.app')
@section('title', 'Programar módulo')
@section('content')
<div class="container" id="clases">
    <div class="row">
        <div class="ibox">
            <div class="ibox-title">
                <h5><i class="fa fa-calendar-plus-o"></i> Programar módulo</h5>
            </div>
            <div class="ibox-content">
                <form action="{{ url('clases') }}" method="POST">
                    {{ csrf_field() }}
                    <div class="row">
                        <div class="col-lg-9">
                            <div class="row">
                                <div class="col-lg-4 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <label for="sede_id" class="control-label gcore-label-top">Sede:</label>
                                            <select name="sede_id" v-model="sede"  id="sede_id" class="form-control" required="" @change="setProgramas()">
                                                <option value="">Seleccione</option>
                                                @foreach($sedes as $sede)
                                                <option value="{{ $sede->id }}">{{ $sede->nombre }}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <span v-show="canrgando_programa==1">CARGANDO...</span>
                                            <div class="input-group date">
                                                <label for="programa">Programa:</label>
                                                <select name="programa" id="programa" v-model="programa" class="form-control" required="">
                                                    <option value="">Seleccione</option>
                                                    <option v-for="programa in programas" v-bind:value="programa.id">
                                                        @{{ programa.programa }}
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-3">
                                    <div class="form-group">
                                        <!-- <div class="col-sm-12"> -->
                                            <label for="modulo_id" class="control-label gcore-label-top">Módulo:</label>
                                            <select name="modulo_id" id="modulo_id" class="form-control" @click="deleteError('modulo')" required="">
                                                <option data-duracion="" value="">Seleccione</option>
                                                @foreach($modulos as $modulo)
                                                <option data-duracion="{{ $modulo->duracion }}" value="{{ $modulo->id }}">{{ $modulo->nombre }}</option>
                                                @endforeach
                                            </select>
                                            <small id="msn1" class="help-block result-modulo" v-show="formErrors.modulo"></small>
                                        <!-- </div> -->
                                    </div>
                                </div>
                                <div class="col-lg-1 b-r">
                                    <div class="form-group">
                                        <!-- <div class="col-sm-12"> -->
                                            <label for="modulo_id" class="control-label gcore-label-top">Clases:</label>
                                            <input type="" name="" class="form-control" value="15" readonly="">
                                            <small id="msn1" class="help-block result-modulo" v-show="formErrors.modulo"></small>
                                        <!-- </div> -->
                                    </div>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-lg-4 b-r">
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
                                <div class="col-lg-4">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="jornada_id">Jornada:</label> 
                                                <select name="jornada_id" id="jornada_id" class="form-control" @change="setInicioJornada()" @click="deleteError('modulo')" required="">
                                                    <option value="">Seleccione</option>
                                                    @foreach($jornadas as $jornada)
                                                    <option  data-hora_inicio="{{ $jornada->hora_inicio }}" data-hora_fin="{{ $jornada->hora_fin }}"  value="{{ $jornada->id }}">{{ $jornada->jornada }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-2">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="hora_inicio_jornada">Hora inicio:</label> 
                                                <input  name="hora_inicio_jornada" id="hora_inicio_jornada" type="text" class="form-control" v-model="hora_inicio_jornada" readonly="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-2 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="hora_fin_jornada">Hora fin:</label> 
                                                <input  name="hora_fin_jornada" id="hora_fin_jornada" type="text" class="form-control" v-model="hora_fin_jornada" readonly="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4 b-r">
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
                                <div class="col-lg-5 b-r">
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
                                {{-- <i class="fa fa-calendar big-icon"></i> --}}
                                <div class="form-group text-center">
                                    
                                    <div class="custom-radios">
                                    <div>
                                      <input type="radio" id="color-1" name="color" value="#2f8d99" checked>
                                      <label for="color-1">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>
                                    
                                    <div>
                                      <input type="radio" id="color-2" name="color" value="#42a5f5">
                                      <label for="color-2">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>
                                    
                                    <div>
                                      <input type="radio" id="color-3" name="color" value="#00c5dc">
                                      <label for="color-3">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>

                                    <div>
                                      <input type="radio" id="color-4" name="color" value="#feb38d">
                                      <label for="color-4">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>
                                    <div>
                                      <input  type="radio" id="color-5" name="color" value="#EE6E73">
                                      <label for="color-5">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>
                                    <div>
                                      <input type="radio" id="color-6" name="color" value="#6B79C4">
                                      <label for="color-6">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>
                                    <div>
                                      <input type="radio" id="color-7" name="color" value="#6B79C4">
                                      <label for="color-7">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>
                                    <div>
                                      <input type="radio" id="color-8" name="color" value="#6B79C4">
                                      <label for="color-8">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>
                                    <div>
                                      <input type="radio" id="color-9" name="color" value="#6B79C4">
                                      <label for="color-9">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>
                                    <div>
                                      <input type="radio" id="color-10" name="color" value="#6B79C4">
                                      <label for="color-10">
                                        <span>
                                          <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                        </span>
                                      </label>
                                    </div>
                                  </div>
                                </div>
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