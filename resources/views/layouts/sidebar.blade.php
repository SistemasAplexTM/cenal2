<div id="right-sidebar" class="animated sidebar-top">
    <div class="slimScrollDiv" style="position: relative; overflow: hidden; width: auto; height: 100%;">
        <div class="sidebar-container" style="overflow: hidden; width: auto; height: 100%;">
            <div class="sidebar-title">
                <h3><i class="fa fa-group"></i> Estudiantes inscritos</h3>
                <small><i class="fa fa-tim"></i> @{{ estudiantes_inscritos.length }} en total</small><br>
                <small><i class="fa fa-tim"></i> Programa: nombre de programa - @{{ estudiantes_inscritos.length }}</small><br>
                <small><i class="fa fa-tim"></i> Programa: nombre de programa - @{{ estudiantes_inscritos.length }}</small><br>
                <small><i class="fa fa-tim"></i> Programa: nombre de programa - @{{ estudiantes_inscritos.length }}</small>
            </div>
            <div>
                <div class="sidebar-message">
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
            </div>
        </div>
        <div class="slimScrollBar" style="background: rgb(0, 0, 0); width: 7px; position: absolute; top: 0px; opacity: 0.4; display: none; border-radius: 7px; z-index: 99; right: 1px; height: 271.752px;">
            
        </div>
        <div class="slimScrollRail" style="width: 7px; height: 100%; position: absolute; top: 0px; display: none; border-radius: 7px; background: rgb(51, 51, 51); opacity: 0.4; z-index: 90; right: 1px;">
            
        </div>
    </div>
</div>