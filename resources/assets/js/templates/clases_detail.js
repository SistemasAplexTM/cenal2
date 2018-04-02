$(document).ready(function () {
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
        }
      });

    $('#agregar').on('click', function () {
        var $btn = $(this).button('loading');
        // business logic...
        // $btn.button('reset');
    });

    objVue.get_estudiantes_inscritos();
    objVue.get_profesor_asignado();
});

var objVue = new Vue({
    el: '#clases',
    data:{
        ver_listado: false,
        cambiar_salon: false,
        repeatInscrito: false,
        btnTerminarClase: true,
        verSidebar: 0,
        clases_detalle_id:'',
        repeatInscritoMessage: 'Agregar',
        salon:'',
        salon_id:'',
        sede_id: '',
        programa:'',
        capacidad:'',
        ubicacion:'',
        duracion:'',
        jornada:'',
        sede:'',
        dato_profesor: '',
        profesor_asignado: '',
        dato_estudiante: '',
        hora_inicio_jornada: '',
        hora_fin_jornada: '',
        estado: '',
        dato_buscar: '',
        cargando_programa: 0,
        editar_salon: 0,
        programas: {},
        salones: {},
        clases: {},
        estudiantes: {},
        estudiantes_asistencia: [],
        estudiantes_inscritos: {},
        profesores: {},
        formErrors: {}
    },
    created(){
        this.get_clases();
    },
    methods:{
        resetForm: function(){
            this.capacidad = '';
            this.dato_estudiante = '';
            this.hora_fin_jornada = '';
            this.hora_inicio_jornada = '';
            this.estudiantes = {};
            this.profesores = [];
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
        buscar_estudiante: function(){
            if (!$("#right-sidebar").hasClass('sidebar-open')) {
                $("#right-sidebar").addClass('sidebar-open');
            }
            var dato = this.dato_estudiante;
            this.repeatInscrito = false;
            this.repeatInscritoMessage = 'Agregar';
            axios.get('../buscar_estudiante/' + dato).then(response => {
                this.estudiantes = response.data; 
                this.verSidebar = 1; 
            });
        },
        get_clases: function(){
            axios.get('./').then(response => {
                this.clases = response.data; 
            });
        },
        agregar_estudiante: function(id){
            axios.get('agregar_estudiante/' + id).then(response => {
                this.verSidebar = 1; 
                this.dato_estudiante = '';
                if (response.data.code == 600) {
                    this.repeatInscrito = true;
                    this.repeatInscritoMessage = 'El estudiante ya está inscrito';
                    // swal({
                    //     type: 'error',
                    //     // title: 'Espera...',
                    //     text: "El estudiante ya está inscrito a esta clase!"
                    // });
                }
                if (response.data.code == 601) {
                    swal({
                        type: 'error',
                        // title: 'Espera...',
                        text: "El salón está lleno!"
                    });
                }
                if (response.data.code == 200) {
                    this.verSidebar = 0; 
                    this.repeatInscrito = false;
                    this.repeatInscritoMessage = 'Agregar';
                    this.get_estudiantes_inscritos();
                }
            });
        },
        buscar_profesor: function(){
            if (!$("#right-sidebar").hasClass('sidebar-open')) {
                $("#right-sidebar").addClass('sidebar-open');
            }
            var dato = this.dato_profesor;
            this.verSidebar = 3;
            this.profesores = '';
            if (dato.length > 0) {
                axios.get('buscar_profesor/' + dato).then(response => {
                    this.profesores = response.data;  
                });
            }
        },
        asignar_profesor: function(id){
            axios.get('asignar_profesor/' + id).then(response => {
                $("#right-sidebar").removeClass('sidebar-open');
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
                this.estudiantes_asistencia = [];
                for (var i = response.data.length - 1; i >= 0; i--) {
                    this.estudiantes_asistencia.push(response.data[i].estudiante_id);
                }
                // if (response.data.length > 0) {
                    // var id_est_list = [];
                    // $(".estudiante_list").each(function(){
                    //     id_est_list.push($(this).children('label').children('div').children('input').val());
                    // });
                    // $(response.data).each(function(key, value){
                    //     if(id_est_list.includes(value.estudiante_id.toString())){
                    //         $('#input-asistencia'+value.estudiante_id).iCheck('check');
                    //         $('#input-asistencia'+value.estudiante_id).iCheck('disable');
                    //     }else{
                    //         $('#input-asistencia'+value.estudiante_id).iCheck('uncheck');
                    //     }
                    // });
                // }
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
        getSalonesBySede: function(sede){
            axios.get('../../salon/getBySede/' + sede).then(response => {
                if (response.data.length > 0) {
                    this.salones = response.data;   
                }
            });
        },
        set_estudiante_asistencia: function(){
            var l = $('#guardar_asistencia').ladda();
                l.ladda( 'start' );
            axios.post('set_estudiante_asistencia', {
                'estudiantes_id': this.estudiantes_asistencia,
                'clases_detalle_id': this.clases_detalle_id
            }).then(response => {
                if (response.data.code == 200) {
                    l.ladda('stop');
                    $('#calendar').fullCalendar( 'refetchEvents' );
                    this.verSidebar = 0;
                    this.get_clases();
                }
            });
        },
        changeSalon: function(){
            axios.post('../../changeSalon', {
                'clases_detalle_id': this.clases_detalle_id,
                'salon_id':  + this.salon_id
            }).then(response => {
                if (response.data.code == 200) {
                    this.salon = response.data.salon;
                    this.editar_salon = 0;
                    $('#calendar').fullCalendar( 'refetchEvents' );
                    this.get_clases();
                }
                if (response.data.code == 300) {
                     // $(".asistencia").removeClass('todo-completed');
                }
            });
        },
        verClase: function(param){
            if (!$("#right-sidebar").hasClass('sidebar-open')) {
                $("#right-sidebar").addClass('sidebar-open');
            }
            this.ver_listado = false;
            this.cambiar_salon = true;
            this.estado = param.estado;
            this.clases_detalle_id = param.id;
            this.salon = param.salon;
            this.getSalonesBySede(param.sede_id);
            if (roles.includes('Profesor')) {
                if (param.estado == 'Terminado') {
                    this.btnTerminarClase = true;
                    $(".estudiante_list").each(function(){
                        $(this).children('label').children('div').children('input').iCheck('disable');
                        $(this).children('label').children('div').children('input').iCheck('uncheck');
                    });
                }else{
                    this.btnTerminarClase = false;
                    $(".estudiante_list").each(function(){
                        $(this).children('label').children('div').children('input').iCheck('enable');
                        $(this).children('label').children('div').children('input').iCheck('uncheck');
                    });
                }
                $("#clase_detalle").val(param.id);
                this.get_estudiantes_asistencia(param.id);
                this.ver_listado = true;
                this.cambiar_salon = false;
            }
            // $('#mdl_clase').modal('show');
        }
    }
    
});