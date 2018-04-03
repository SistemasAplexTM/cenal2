<div id="right-sidebar" class="animated">
    <div class="sidebar-container">
        <div class="sidebar-title">
            <h3><i class="fa fa-group"></i> Estudiantes inscritos - @{{ estudiantes_inscritos.length }} en total</h3>
            {{-- <small><i class="fa fa-tim"></i> Programa: nombre de programa - @{{ estudiantes_inscritos.length }}</small><br>
            <small><i class="fa fa-tim"></i> Programa: nombre de programa - @{{ estudiantes_inscritos.length }}</small><br> --}}
        </div>
        <div>
            <div class="sidebar-message" v-if="verSidebar===0">
                <div class="feed-element" v-for="estudiante in estudiantes_inscritos">
                    <a class="pull-left" href="#">
                        <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                        </img>
                    </a>
                    <div class="media-body ">
                        <strong>
                            @{{ estudiante.codigo }} - @{{ estudiante.nombre }}
                        </strong>
                        <br>
                        <small class="text-muted">
                            <strong>
                                Programa:
                            </strong>
                                @{{ estudiante.programa }}
                        </small>
                        </br>
                    </div>
                </div>
            </div>
            <div class="sidebar-message" v-if="verSidebar===1">
                <div class="alert alert-primary text-center" v-show="estudiantes.length<=0">No hay datos disponibles</div>
                <div class="feed-element" v-for="value in estudiantes">
                    <a class="pull-left" href="#">
                        <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                        </img>
                    </a>
                    <div class="media-body ">
                        <button @click.prevent="agregar_estudiante(value.id)"  class="btn btn-primary btn-xs pull-right" v-bind:class="{ 'btn-danger' : repeatInscrito }" v-bind:disabled="repeatInscrito" data-loading-text="Agregando..." id="agregar" type="button" >
                            <i class="fa fa-plus" v-bind:class="{ 'fa-exclamation' : repeatInscrito }" >
                            </i>
                            @{{ repeatInscritoMessage }}
                        </button>
                        <strong>
                            @{{ value.codigo }} - @{{ value.nombre }}
                        </strong>
                        <br>
                        <p class="text-muted">
                                Documento:
                            <strong>
                                @{{ value.num_documento }}
                            </strong>
                        </p>
                    </div>
                </div>
                <div class="feed-element" v-if="repeatInscrito">
                    <div class="media-body">
                        <div class="alert alert-danger">
                            <a class="btn btn-primary pull-right" :href="'../'+repeatObj.id+'/edit'" >
                                <i class="fa fa-eye">
                                </i>
                                ver
                            </a>
                            <strong>
                                El estudiante ya se encuentra inscrito
                            </strong>
                            <p class="text-muted">
                                    Sede:
                                <strong>
                                    @{{ repeatObj.sede }}
                                </strong>
                                <br>
                                    Jornada:
                                <strong>
                                    @{{ repeatObj.jornada }}
                                </strong>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="sidebar-message" v-if="verSidebar===2">
                @role('Profesor')    
                    <button id="guardar_asistencia" class="ladda-button btn btn-block btn-primary" data-style="slide-down" type="button" @click.prevent="set_estudiante_asistencia()" :disabled="btnTerminarClase == true ? true : false">
                        <i class="fa fa-check"></i> Terminar clase
                    </button>
                @endrole
                <br>
                <div class="ibox float-e-margins">
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-md-6">
                                <p>
                                    <i class="fa fa-calendar"></i> Clase: <strong>{{ $data->modulo }}</strong>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <span>
                                    <i class="fa fa-home"></i> Salón: <strong>@{{ salon }}</strong>
                                    <div class="btn-group pull-right" v-if="cambiar_salon==true">
                                        <a href="#" data-toggle="dropdown" class="dropdown-toggle" aria-expanded="true" title="Opciones"><i class="fa fa-ellipsis-h"></i></a>
                                        <ul class="dropdown-menu">
                                            {{-- <li><a href="#"><i class="fa fa-map-marker"></i> Ubicación</a></li>
                                            <li><a href="#"><i class="fa fa-group"></i> Capacidad</a></li>
                                            <li v-if="estado!='Terminado'"  class="divider"></li> --}}
                                            <li v-if="estado!='Terminado'" ><a href="#" @click.prevent="editar_salon=1"><i class="fa fa-edit"></i> Cambiar salón</a></li>
                                        </ul>
                                    </div>
                                    <span class="input-group" v-if="editar_salon==1">
                                        <select name="salon_id" id="salon_id" v-model="salon_id" class="form-control" >
                                            <option v-for="salon in salones" v-bind:value="salon.id">
                                                @{{ salon.codigo }}
                                            </option>
                                        </select>
                                        <span class="input-group-addon">
                                            <a href="#" @click.prevent="changeSalon()">
                                                <i class="fa fa-save"></i>
                                            </a>
                                        </span>
                                        <span class="input-group-addon">
                                            <a href="#" @click.prevent="editar_salon=0">
                                                <i class="fa fa-close"></i>
                                            </a>
                                        </span>
                                    </span>
                                </span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p>
                                    <i class="fa fa-clock-o"></i> Hora de inicio: <strong>{{ date("H:i", strtotime($data->inicio_jornada)) }}</strong>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p>
                                    <i class="fa fa-clock-o"></i> Hora de fin: <strong>{{ date("H:i", strtotime($data->fin_jornada)) }}</strong>
                                </p>
                            </div>
                        </div>
                    </div>
                    @role('Profesor')
                    <div class="ibox-content">
                        <h3>Listado de asistencia</h3>
                        <form action="">
                            <ul class="todo-list m-t">
                                <li class="estudiante_list" v-for="estudiante in estudiantes_inscritos">
                                    <label class="checkbox-inline estudiante_asistencia">
                                        <div class="checkbox checkbox-danger">
                                            <input v-model="estudiantes_asistencia" :value="estudiante.id" :disabled="btnTerminarClase == true ? true : false" type="checkbox">
                                            <label for="checkbox3">
                                                <span class="m-l-xs asistencia">
                                                    <strong>@{{ estudiante.codigo }}</strong> - @{{ estudiante.nombre }}
                                                </span>
                                            </label>
                                        </div>
                                        {{-- <input v-model="estudiantes_asistencia" :value="estudiante.id" :disabled="btnTerminarClase == true ? true : false" checked="" type="checkbox"> --}}  
                                    </label>
                                </li>
                            </ul>
                        </form>
                    </div>
                    @endrole
                </div>
            </div>
            <div class="sidebar-message" v-if="verSidebar===3">
                <div class="alert alert-primary text-center" v-show="profesores.length<=0">No hay datos disponibles</div>
                <div class="feed-element" v-for="profesor in profesores" v-if="profesores.length > 0">
                    <a class="pull-left" href="#">
                        <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                        </img>
                    </a>
                    <div class="media-body ">
                        <button @click.prevent="asignar_profesor(profesor.id)"  class="btn btn-primary btn-xs pull-right" data-loading-text="Agregando..." id="agregar" type="button" >
                            <i class="fa fa-plus">
                            </i>
                            Asignar
                        </button>
                        <strong>
                            @{{ profesor.name }} - @{{ profesor.last_name }}
                        </strong>
                        <br>
                        <p class="text-muted">
                            <strong>
                                @{{ profesor.email }}
                            </strong>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>