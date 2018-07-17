@extends('layouts.app')
@section('title', 'Programar módulo')
@section('content')
<div class="container-fluid" id="clases">
    <div class="row" v-show="texto_error">
        <div class="col-lg-12">
            <div class="alert alert-danger">
                Ocurrió un error al registrar, verifique que todos los campos estén llenos.
                <br>
                <strong>
                    <span v-text="texto_error"></span>
                </strong>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="ibox">
            <div class="ibox-title">
                <h5><i class="fa fa-calendar-plus-o"></i> Programar grupo</h5>
            </div>
            <div class="ibox-content">
                <form action="{{ url('clases') }}" method="POST" id="create_clase_form" enctype="multipart/form-data" ref="form">
                    {{ csrf_field() }}
                    <div class="row">
                        <div class="col-lg-2" v-if="errorSalon">
                            <div class="well">
                                    El salón no está disponible en las siguientes fechas:
                                    <div class="checkbox checkbox-primary">
                                        <input v-model="omitirSalon" id="checkbox2" type="checkbox" checked="">
                                        <label for="checkbox2">
                                            Omitir errores
                                        </label>
                                    </div>
                                <br>
                                {{-- <button class="btn btn-default btn-block" @click.prevent="errorSalon=false;fechasError=[];omitirSalon=true">Omitir</button> --}}
                                <ul class="list-group">
                                  {{-- <li class="list-group-item" v-for="fecha in fechasError">@{{ fecha.start }}</li> --}}
                                  <li class="list-group-item" v-for="(value, index) in fechasError" v-if="index <= limit" :style="(index == limit) ? 'cursor: pointer;' : ''">
                                    <strong v-if="index == limit" @click.prevent="limit=fechasError.length">
                                        @{{ fechasError.length - limit + ' fechas más' }}
                                    </strong>
                                    <p v-else>
                                        @{{ value.start }}
                                    </p>
                                    <strong v-if="limit == fechasError.length && index == fechasError.length - 1" @click.prevent="limit=5" :style="(limit == fechasError.length && index == fechasError.length - 1) ? 'cursor: pointer;' : ''">
                                        @{{ 'Mostrar menos' }}
                                    </strong>
                                </li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-lg-9" :class="{'col-lg-7' : errorSalon}">
                            <div class="row">
                                <div class="col-lg-4 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group" :class="{'has-error': errors.has('grupo') }">
                                                <label for="grupo">Grupo:</label> 
                                                    <input v-model="grupo" v-validate="'required'" name="grupo" id="grupo" type="text" placeholder="Nombre del grupo..." class="form-control" required="">
                                                <small v-show="errors.has('grupo')" class="text-danger">@{{ errors.first('grupo') }}</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group" :class="{'has-error': errors.has('jornada') }">
                                                <label for="jornada">Jornada:</label> 
                                                <select v-validate="'required'" v-model="jornada" name="jornada" id="jornada" class="form-control" @change="setInicioJornada()" @click="deleteError('modulo')" required="">
                                                    <option value="">Seleccione</option>
                                                    @foreach($jornadas as $jornada)
                                                    <option  data-hora_inicio="{{ $jornada->hora_inicio }}" data-hora_fin="{{ $jornada->hora_fin }}"  value="{{ $jornada->id }}">{{ $jornada->jornada }}</option>
                                                    @endforeach
                                                </select>
                                                <small v-show="errors.has('jornada')" class="text-danger">@{{ errors.first('jornada') }}</small>    
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-2">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="hora_inicio_jornada">Hora inicio:</label> 
                                                <input v-model="hora_inicio_jornada" name="hora_inicio_jornada" id="hora_inicio_jornada" type="text" class="form-control"  readonly="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-2 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="hora_fin_jornada">Hora fin:</label> 
                                                <input v-model="hora_fin_jornada" name="hora_fin_jornada" id="hora_fin_jornada" type="text" class="form-control"  readonly="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            {{-- <div class="row">                                
                                <div class="col-lg-3 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <label for="sede_id" class="control-label gcore-label-top">Sede:</label>
                                            <select name="sede_id" v-model="sede"  id="sede_id" class="form-control" required="" @change="setProgramas();setSalones()">
                                                <option value="">Seleccione</option>
                                                @foreach($sedes as $sede)
                                                <option {{ old('sede_id') == $sede->id ? 'selected' : '' }} value="{{ $sede->id }}">{{ $sede->nombre }}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <br v-show="cargando==1">
                                            <div class="sk-spinner sk-spinner-fading-circle text-center" v-show="cargando==1">
                                                <div class="sk-circle1 sk-circle"></div>
                                                <div class="sk-circle2 sk-circle"></div>
                                                <div class="sk-circle3 sk-circle"></div>
                                                <div class="sk-circle4 sk-circle"></div>
                                                <div class="sk-circle5 sk-circle"></div>
                                                <div class="sk-circle6 sk-circle"></div>
                                                <div class="sk-circle7 sk-circle"></div>
                                                <div class="sk-circle8 sk-circle"></div>
                                                <div class="sk-circle9 sk-circle"></div>
                                                <div class="sk-circle10 sk-circle"></div>
                                                <div class="sk-circle11 sk-circle"></div>
                                                <div class="sk-circle12 sk-circle"></div>
                                            </div>
                                            <div v-show="cargando==0">
                                                <label for="programa">Programa:</label>
                                                <v-select label="programa" :options="programas" :on-change="setModulos">
                                                    <span slot="no-options">
                                                      No hay datos
                                                    </span>
                                                </v-select>     
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-3">
                                    <div class="form-group">
                                        <br v-show="cargandoModulos==1">
                                        <div class="sk-spinner sk-spinner-fading-circle text-center" v-show="cargandoModulos==1">
                                            <div class="sk-circle1 sk-circle"></div>
                                            <div class="sk-circle2 sk-circle"></div>
                                            <div class="sk-circle3 sk-circle"></div>
                                            <div class="sk-circle4 sk-circle"></div>
                                            <div class="sk-circle5 sk-circle"></div>
                                            <div class="sk-circle6 sk-circle"></div>
                                            <div class="sk-circle7 sk-circle"></div>
                                            <div class="sk-circle8 sk-circle"></div>
                                            <div class="sk-circle9 sk-circle"></div>
                                            <div class="sk-circle10 sk-circle"></div>
                                            <div class="sk-circle11 sk-circle"></div>
                                            <div class="sk-circle12 sk-circle"></div>
                                        </div>
                                        <div class="input-group" v-show="cargandoModulos==0">
                                            <label for="modulo_id" class="control-label gcore-label-top">Módulo:  @{{ modulo_id }}</label>
                                            <v-select v-model="modulo_id" label="name" :options="modulos" :on-change="setDuracion">
                                                <span slot="no-options">
                                                  No hay datos
                                                </span>
                                            </v-select>
                                            <input type="hidden" id="modulo_id" name="modulo_id" />
                                        </div>
                                        <small id="msn1" class="help-block result-modulo" v-show="formErrors.modulo"></small>
                                    </div>
                                </div>
                                <div class="col-lg-1 b-r">
                                    <div class="form-group">
                                            <label for="duracion" class="control-label gcore-label-top">Clases:</label>
                                            <input type="" name="duracion" class="form-control" v-model="duracion" readonly="">
                                    </div>
                                </div>
                            </div> --}}
                            <hr>
                            <div class="row">
                                <div class="col-lg-4 b-r">
                                    <div class="form-group" :class="{'has-error': errors.has('fecha_inicio') }">
                                        <div class="col-sm-12">
                                            <div id="data_1">
                                                <div class="input-group date">
                                                    <label for="fecha_inicio">Fecha de inicio:</label> 
                                                    <div class="input-group">
                                                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                                        <input v-validate="'required'" name="fecha_inicio" id="fecha_inicio" type="text" placeholder="dd/mm/aaaa" class="form-control">
                                                    </div>
                                                    <small v-show="errors.has('fecha_inicio')" class="text-danger">@{{ errors.first('fecha_inicio') }}</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <div class="form-group" :class="{'has-error': errors.has('programa') }">
                                        <div class="col-sm-12">
                                            <div>
                                                <label for="programa">Programa: <span class="text-danger">@{{ (jornada.length == 0) ? 'Debe seleccionar una jornada'  : ''}}</span></label>
                                                <v-select name="programa" label="nombre" :options="programas" :on-change="setModulos" :disabled="jornada.length == 0">
                                                    <span slot="no-options">
                                                      No hay datos
                                                    </span>
                                                </v-select>
                                                <small v-show="errors.has('programa')" class="text-danger">@{{ errors.first('programa') }}</small>    
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <br>
                            <div class="row">
                                <div class="col-lg-4 b-r">
                                    <div class="form-group">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="salon_id" class="control-label gcore-label-top">Salón:</label>
                                                <v-select :class="{'danger': errors.has('salon') }" name="salon" id="salon" label="codigo" :options="salones" :on-change="setCapacidad">
                                                    <span slot="no-options">
                                                      No hay datos
                                                    </span>
                                                </v-select> 
                                                <small v-show="errors.has('salon')" class="text-danger">@{{ errors.first('salon') }}</small> 
                                                {{-- <select name="salon_id" id="salon_id" v-model="salon" class="form-control" required="" @click="deleteError('salon')" @change="setCapacidad()" required="">
                                                    <option value="">Seleccione</option>
                                                    <option v-for="salon in salones" v-bind:value="salon.id" :data-capacidad="salon.capacidad" :data-ubicacion="salon.ubicacion">
                                                        @{{ salon.codigo }}
                                                    </option>
                                                </select> --}}
                                            </div>
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
                                            <div class="checkbox checkbox-success checkbox-inline">
                                                <input v-model="semana" type="checkbox" id="1" value="1">
                                                <label for="1"> Lunes </label>
                                            </div>
                                            <div class="checkbox checkbox-success checkbox-inline">
                                                <input v-model="semana" type="checkbox" id="2" value="2">
                                                <label for="2"> Martes </label>
                                            </div>
                                            <div class="checkbox checkbox-success checkbox-inline">
                                                <input v-model="semana" type="checkbox" id="3" value="3">
                                                <label for="3"> Miércoles </label>
                                            </div>
                                            <div class="checkbox checkbox-success checkbox-inline">
                                                <input v-model="semana" type="checkbox" id="4" value="4">
                                                <label for="4"> Jueves </label>
                                            </div>
                                            <div class="checkbox checkbox-success checkbox-inline">
                                                <input v-model="semana" type="checkbox" id="5" value="5">
                                                <label for="5"> Viernes </label>
                                            </div>
                                            <div class="checkbox checkbox-success checkbox-inline">
                                                <input v-model="semana" type="checkbox" id="6" value="6">
                                                <label for="6"> Sábado </label>
                                            </div>
                                            <div class="checkbox checkbox-success checkbox-inline">
                                                <input v-model="semana" type="checkbox" id="7" value="7">
                                                <label for="7"> Domingo </label>
                                            </div>
                                        </div>
                                    </div> 
                                </div>
                            </div>
                            {{-- <hr>
                            <div class="row">
                                <div class="col-lg-12 b-r">
                                   <div class="form-group">
                                        <div class="col-sm-12">
                                        <label for="observacion" >Obseración: </label>
                                            <textarea class="form-control" name="observacion" id="observacion" cols="30" rows="2"></textarea> 
                                        </div>
                                    </div>  
                                </div>
                            </div> --}}
                        </div>
                        <div class="col-lg-3">
                            <div class="row">
                                <div class="col-lg-12">
                                    <li class="list-group-item active">Módulos</li>
                                    <li class="list-group-item" v-if="modulos.length<=0">
                                        <div class="alert alert-success" >
                                            <i class="fa fa-exclamation"></i> No hay módulos disponibles
                                        </div>
                                    </li>
                                    <draggable :list="modulos" class="list-group">
                                        <li v-for="modulo in modulos" class="list-group-item">
                                            <i class="fa fa-arrows"></i>
                                            <small class="label label-success pull-right"><i class="fa fa-clock-o"></i> @{{ modulo.duracion }} clases</small>
                                            <span class="m-l-xs">@{{ modulo.nombre }}</span>
                                        </li>
                                    </draggable> 
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row text-center">
                        {{-- <div class="col-lg-4"> --}}
                            <div class="form-group">
                                {{-- <div class="col-sm-12"> --}}
                                    <button @click.prevent="save" type="button" class="ladda-button btn btn-primary hvr-float-shadow" data-style="expand-right"><i class="fa fa-floppy-o" aria-hidden="true"></i> Guardar</button>
                                    <a href="{{ url('grupos') }}" class="btn btn-white hvr-float-shadow"><i class="fa fa-times fa-fw"></i> Cancelar</a>
                                {{-- </div> --}}
                            </div>
                        {{-- </div> --}}
                    </div>
                </form>
            </div>
        </div>
    </div>
<div class="modal inmodal fade" id="mdl-modulos" tabindex="-1" role="dialog"  aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h3>Módulos del programa</h3>
            </div>
            <div class="modal-body">
                <div class="alert alert-success" v-if="modulos.length<=0">
                    No hay módulos disponibles
                </div>
                <draggable :list="modulos" class="list-group">
                    <li v-for="modulo in modulos" class="list-group-item">
                        <i class="fa fa-arrows"></i>
                        <small class="label label-success pull-right"><i class="fa fa-clock-o"></i> @{{ modulo.duracion }} clases</small>
                        <span class="m-l-xs">@{{ modulo.name }}</span>
                    </li>
                </draggable>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                {{-- <button type="button" class="btn btn-primary">Aceptar</button> --}}
            </div>
        </div>
    </div>
</div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/clases_create.js') }}"></script>
@endpush