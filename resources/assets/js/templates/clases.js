$(document).ready(function () {

    $('#data_1 .input-group.date').datepicker({
        language: 'es',
        todayBtn: "linked",
        calendarWeeks: true,
        autoclose: true,
    });

    $('#tbl-clases').DataTable({
        processing: true,
        serverSide: true,
        ajax: 'clases/all',
        columns: [
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    //var btn_delete = " <a onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_edit =  "<a href='clases/" + full.id + "/edit' class='btn btn-white btn-sm'><i class='fa fa-folder'></i> Detalles </a> ";
                    return btn_edit ;
                }
            },
            {
                searchable: true,
                className: 'project-title',
                "render": function (data, type, full, meta) {
                    var inicio = moment(full.fecha_inicio).format('DD-MM-YYYY')
                    var fin = moment(full.fecha_fin).format('DD-MM-YYYY')
                    return  "<a href='clases/" + full.id + "/edit'>Múdolo "+full.modulo+"</a><br/><small>Inicio: "+inicio+" - Fin: "+fin+"</small>";
                }
            },
            { 
                "render": function (data, type, full, meta) {
                    return "<span class='label label-"+full.clase_estado+"'>"+ full.estado+"</span>";                    
                }
            },
            { data: "sede", name: 'sede'},
            {
                className: 'project-title',
                sortable: false,
                "render": function (data, type, full, meta) {
                    return  "<a>"+ full.salon +"</a><br><small>Estudiantes "+full.cant_estudiantes+" / "+full.capacidad+"</small>";
                }
            },
            { data: "jornada", name: 'jornada'},
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var porcentaje = full.completadas/full.total*100;
                    var btn_progreso =  "<small>Conpletadas: "+full.completadas+" de "+full.total+"</small><div class='progress progress-mini'><div style='width: "+porcentaje+"%;' class='progress-bar'></div></div>";
                    return btn_progreso;
                }
            },
            {
                "render": function (data, type, full, meta) {
                    if (roles.includes('Administrador') || roles.includes('Coordinador')) {
                        if (full.profesor_id == 'null' || full.profesor_id == null || full.profesor_id == 'NULL' ) {
                            return  "<a href=''>Sin asignar</a>";
                        }else{
                            return  "<a href=''><img alt='image' width='60px' class='img-circle' src='"+full.profesor_img+"'> "+full.profesor+"</a>";                        
                        }
                    }
                    if (roles.includes('Profesor')) {
                        return 'Próxima fecha';
                    }
                }
            }
        ]
    });

    $('#calendar').fullCalendar({
        lang: 'es',
        header: {
          left: 'prev,next today',
          center: 'title',
          right: 'month,agendaWeek,agendaDay'
        },
        navLinks: true, // can click day/week names to navigate views
        editable: true,
        selectable: true,
        selectHelper: true,
        events: './',
        dayClick: function(date, jsEvent, view){
          
          
        },
        eventClick: function(event, element) {
            if (roles.includes('Profesor')) {
                if (event.estado == 'Terminado') {
                    $("#guardar_asistencia").attr('disabled', true);
                    $(".estudiante_list").each(function(){
                        $(this).children('label').children('div').children('input').iCheck('disable');
                        $(this).children('label').children('div').children('input').iCheck('uncheck');
                    });
                }else{
                    $(".estudiante_list").each(function(){
                        $(this).children('label').children('div').children('input').iCheck('enable');
                        $(this).children('label').children('div').children('input').iCheck('uncheck');
                    });
                    $("#guardar_asistencia").attr('disabled', false);
                }
                $("#clase_detalle").val(event.id);
                objVue.get_estudiantes_asistencia(event.id);
                $('#mdl_clase').modal('show');
            }
        }
      });

    $('#agregar').on('click', function () {
        var $btn = $(this).button('loading');
        // business logic...
        // $btn.button('reset');
    })

    $("#jornada").on('change', function(){
        objVue.setHorasJornada();
    });

    $("#salon").on('change', function(){
        objVue.setCapacidad();
    });

    // $(".estudiante_asistencia").on('click', function(){
    //     $(".estudiante_asistencia").children('span').addClass('todo-completed');
    // });

    objVue.get_estudiantes_inscritos();
    objVue.get_profesor_asignado();
});

var objVue = new Vue({
    el: '#clases',
    data:{
        salon:'',
        capacidad:'',
        ubicacion:'',
        duracion:'',
        jornada:'',
        dato_profesor: '',
        profesor_asignado: '',
        dato_estudiante: '',
        estudiantes_inscritos: {},
        hora_inicio_jornada: '',
        hora_fin_jornada: '',
        estudiantes: {},
        profesores: {},
        formErrors: {}
    },
    methods:{
        resetForm: function(){
            this.capacidad = '';
            this.dato_estudiante = '';
            this.hora_fin_jornada = '';
            this.hora_inicio_jornada = '';
            this.estudiantes = {};
            this.profesores = {};
        },
        /* metodo para eliminar el error de los campos del formulario cuando dan clic sobre el */
        deleteError: function(element){
            let me = this;
            $.each(me.formErrors, function (key, value) {
                if(key !== element){
                   me.formErrors[key] = value; 
               }else{
                me.formErrors[key] = false; 
               }
            });
        },
        setCapacidad: function(){
            this.capacidad = $("#salon").find(':selected').attr('data-capacidad');
        },
        setInicioJornada: function(){
            var inicio = $("#jornada_id").find(':selected').data("hora_inicio");
            var fin = $("#jornada_id").find(':selected').data("hora_fin");
            this.hora_inicio_jornada = moment(inicio, "HH:mm:ss").format('HH:mm');
            this.hora_fin_jornada = moment(fin, "HH:mm:ss").format('HH:mm');
        },
        buscar_estudiante: function(){
            var dato = this.dato_estudiante;
            axios.get('../buscar_estudiante/' + dato).then(response => {
                this.estudiantes = response.data;   
                $('#mdl_agregar_estudiante').modal('show');
            });
        },
        agregar_estudiante: function(id){
            axios.get('agregar_estudiante/' + id).then(response => {
                $('#mdl_agregar_estudiante').modal('hide');
                this.dato_estudiante = '';
                if (response.data.code == 600) {
                    swal({
                        type: 'error',
                        // title: 'Espera...',
                        text: "El estudiante ya está inscrito a esta clase!"
                    });
                }
                if (response.data.code == 601) {
                    swal({
                        type: 'error',
                        // title: 'Espera...',
                        text: "El salón está lleno!"
                    });
                }
                if (response.data.code == 200) {
                    this.get_estudiantes_inscritos();
                }
            });
        },
        buscar_profesor: function(){
            var dato = this.dato_profesor;
            axios.get('buscar_profesor/' + dato).then(response => {
                this.profesores = response.data;   
                $('#mdl_asignar_profesor').modal('show');
            });
        },
        asignar_profesor: function(id){
            axios.get('asignar_profesor/' + id).then(response => {
                $('#mdl_asignar_profesor').modal('hide');
                this.dato_profesor = '';
                if (response.data.code == 600) {
                    swal({
                        type: 'error',
                        title: 'Error...',
                    });
                }
                if (response.data.code == 200) {
                    this.get_profesor_asignado();
                }
            });
        },
        get_estudiantes_asistencia: function(clases_detalle_id){
            axios.get('getAll_estudiantes_asistencia/' + clases_detalle_id).then(response => {
                if (response.data.length > 0) {
                    var id_est_list = [];
                    $(".estudiante_list").each(function(){
                        id_est_list.push($(this).children('label').children('div').children('input').val());
                    });
                    $(response.data).each(function(key, value){
                        if(id_est_list.includes(value.estudiante_id.toString())){
                            $('#input-asistencia'+value.estudiante_id).iCheck('check');
                            $('#input-asistencia'+value.estudiante_id).iCheck('disable');
                        }else{
                            $('#input-asistencia'+value.estudiante_id).iCheck('uncheck');
                        }
                    });
                }
            });
        },
        get_estudiantes_inscritos: function(){
            axios.get('estudiantes_inscritos').then(response => {
                this.estudiantes_inscritos = response.data;   
            });
        },
        get_profesor_asignado: function(){
            axios.get('profesor_asignado').then(response => {
                if (response.data[0].profesor.length > 0) {
                    this.profesor_asignado = response.data[0].profesor;   
                }
            });
        },
        set_estudiante_asistencia: function(){
            var l = $('#guardar_asistencia').ladda();
                l.ladda( 'start' );
            // l.click(function(){
            //     // Start loading
            //     // Timeout example
            //     // Do something in backend and then stop ladda
            //     setTimeout(function(){
            //     },12000)
            // });
            var estudiantes = [];
            $("input[type=checkbox]:checked").each(function(){
                //cada elemento seleccionado
                estudiantes.push($(this).val());
            });
            axios.post('set_estudiante_asistencia', {
                'estudiantes_id': estudiantes,
                'clases_detalle_id':  + $("#clase_detalle").val()
            }).then(response => {
                if (response.data.code == 200) {
                    l.ladda('stop');
                    $('#calendar').fullCalendar( 'refetchEvents' );
                }
                if (response.data.code == 300) {
                     // $(".asistencia").removeClass('todo-completed');
                }
                $("#mdl_clase").modal('hide');
            });
        }
    }
    
});