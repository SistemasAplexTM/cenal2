<div id="right-sidebar" class="animated" :class="{'sidebar-open': open_sidebar}">
    <div class="sidebar-container">
        <div class="sidebar-title">
            <h3>
                <button class="btn" @click="verSidebar=0;open_sidebar=false" title="Ocultar"><i class="fa fa-arrow-right"></i></button>
                 <i class="fa fa-group"></i> Estudiantes inscritos - @{{ estudiantes_inscritos.length }} en total
             </h3>
            {{-- <small><i class="fa fa-tim"></i> Programa: nombre de programa - @{{ estudiantes_inscritos.length }}</small><br>
            <small><i class="fa fa-tim"></i> Programa: nombre de programa - @{{ estudiantes_inscritos.length }}</small><br> --}}
        </div>
        <div>
            <div class="sidebar-message" v-if="verSidebar===0">
                <h3>
                    <span class="label pull-right label-warning">@{{ estudiantes_inscritos.length }}</span>
                    Estudiantes inscritos
                </h3>
                <hr>
                <div v-for="estudiante in estudiantes_inscritos">
                    <h2>
                        <strong>
                            <i class="fa fa-barcode"></i>
                            @{{ estudiante.codigo }}
                        </strong>
                        <br>
                        <small>
                            <span v-if="estudiante.aprobado != null" class="label pull-right label-success" :class="{'label-danger' : estudiante.aprobado}">@{{ (estudiante.aprobado) ? 'Reprobado' : 'Aprobado' }}</span>
                            @{{ estudiante.nombre }}
                        </small>
                    </h2>
                </div>
            </div>

            <div class="sidebar-message" v-if="verSidebar===1">
                <div class="row">
                    <div class="ibox float-e-margins">
                        <div class="ibox-content">
                            <div class="feed-activity-list">
                                <div class="feed-element">
                                    <div class="form-group">
                                        <div class="col-lg-12">
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <i class="fa fa-user-plus">
                                                    </i>
                                                </span>
                                                <input class="form-control" id="burcar_estudiante" name="burcar_estudiante" placeholder="Código del estudiante" type="text" v-model="dato_estudiante" @keyup.enter="buscar_estudiante()">
                                                    <a @click.prevent="buscar_estudiante()" class="input-group-addon btn btn-primary" type="button">
                                                        Buscar
                                                    </a>
                                                </input>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="feed-activity-list">
                                <div class="feed-element">
                                    <br>
                                    <p class="text-center" v-text="busqueda_Estudiante"></p>
                                    <div v-for="estudiante in estudiantes">
                                        <h2>
                                            <template class="pull-right">
                                                {{-- <confirm-button v-on:confirmation-success="retirar_estudiante(estudiante.id)"></confirm-button> --}}
                                                <a v-if="estudiante.cantidad <= 0" data-toggle="tooltip" title="Agregar estudiante" class="btn btn-primary btn-xs pull-right" @click.prevent="agregar_estudiante(estudiante.id)"><i class="fa fa-check"></i></a>
                                            </template>
                                            <strong>
                                                <i class="fa fa-barcode"></i>
                                                @{{ estudiante.codigo }}
                                            </strong>
                                            <br>
                                            <small>@{{ estudiante.nombre }}</small>
                                        </h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="sidebar-message" v-if="verSidebar===2">
                @role('Profesor')
                    @if($data->estado != 'Terminado')
                        <button id="guardar_asistencia" class="ladda-button btn btn-block btn-primary" data-style="slide-down" type="button" @click.prevent="set_estudiante_asistencia()" :disabled="btnTerminarClase == true ? true : false">
                            <i class="fa fa-check"></i> Terminar clase
                        </button>
                    @endif
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
                <div class="" v-for="profesor in profesores" v-if="profesores.length > 0">
                    <div class="media-body">
                        <h2>
                            <button @click.prevent="asignar_profesor(profesor.id)"  class="btn btn-primary btn-xs pull-right" data-loading-text="Agregando..." id="agregar" type="button" >
                                <i class="fa fa-plus">
                                </i>
                                Asignar
                            </button>
                            @{{ profesor.name }} @{{ profesor.last_name }}
                            <br>
                            <small>@{{ profesor.email }}</small>
                        </h2>
                    </div>
                    <hr>
                </div>
            </div>
            <div class="sidebar-message" v-if="verSidebar===4">
                <div class="alert alert-warning" v-if="clases_terminadas > 0">
                    <h3 class="text-center">
                        No ha terminado todas las clases de esté módulo
                        <br>
                        <strong>
                            ¿Está seguro de terminar el módulo?
                        </strong>
                    </h3>
                </div>
                @role('Profesor')    
                    <button id="btn-terminar" class="ladda-button btn btn-block btn-danger" data-style="slide-down" type="button" @click.prevent="terminar_modulo()">
                        <i class="fa fa-step-forward"></i> Terminar módulo
                    </button>
                @endrole
                <br>
                <div class="ibox float-e-margins">
                    <div class="alert alert-danger" v-if="clases_terminadas > 0">
                        <h3 class="text-center">
                            Debe indicar que estudiantes <strong>NO</strong> aprueban el módulo
                        </h3>
                    </div>
                    @role('Profesor')
                    <div class="ibox-content">
                        <h3>Listado de estudiantes</h3>
                        <form action="">
                            <ul class="todo-list m-t">
                                <li class="estudiante_list" v-for="(estudiante, index) in estudiantes_inscritos">
                                    <label class="checkbox-inline estudiante_asistencia">
                                        <div class="checkbox checkbox-danger">
                                            <input v-model="estudiantes_reprobados" :value="estudiante.id" type="checkbox">
                                            <label for="checkbox3">
                                                <span class="m-l-xs asistencia">
                                                    <strong>@{{ estudiante.codigo }}</strong> - @{{ estudiante.nombre }}
                                                </span>
                                            </label>
                                        </div>
                                    </label>
                                </li>
                            </ul>
                        </form>
                    </div>
                    @endrole
                </div>
            </div>
            <div class="sidebar-message" v-if="verSidebar===5">
                <h3>
                    <span class="label pull-right label-warning">@{{ estudiantes_reprobados.length }}</span>
                    Estudiantes reprobados
                </h3>
                <hr>
                <div class="alert alert-primary text-center" v-show="estudiantes_reprobados.length<=0">No hay datos disponibles</div>
                <div v-for="estudiante in estudiantes_reprobados">
                    <h2>
                        <strong>
                            <i class="fa fa-barcode"></i>
                            @{{ estudiante.codigo }}
                        </strong>
                        <br>
                        <small>@{{ estudiante.nombre }}</small>
                    </h2>
                </div>
            </div>
        </div>
    </div>
</div>