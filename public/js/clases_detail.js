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
        open_sidebar: false,
        ver_listado: false,
        cambiar_salon: false,
        btnTerminarClase: true,
        edit_prof: false,
        verSidebar: 0,
        clases_detalle_id:'',
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
        clases_terminadas: '',
        cargando_programa: 0,
        editar_salon: 0,
        salones: {},
        clases: {},
        estudiantes: {},
        estudiantes_reprobados: [],
        estudiantes_asistencia: [],
        estudiantes_inscritos: {},
        estudiantes_reprobados: {},
        profesores: {}
    },
    computed: {
        // a computed getter
        show_input_teacher: function () {
          // `this` points to the vm instance
          result = false;
          if (this.profesor_asignado.length <= 0) {
            result = true;
          }if (this.edit_prof) {
            result = true;
          }
          return result;
        }
    },
    created(){
        this.get_clases();
        this.get_clases_terminadas();
        this.get_estudiantes_reprobados();
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
        get_estudiantes_inscritos: function(){
            this.dato_estudiante = '';
            this.view = 'inscritos';
            axios.get('estudiantes_inscritos').then(response => {
                this.estudiantes_inscritos = response.data;   
            });
        },
        get_estudiantes_reprobados: function(){
            this.view = 'reptobados';
            axios.get('estudiantes_reprobados').then(response => {
                this.estudiantes_reprobados = response.data;
            });
        },
        get_clases_terminadas: function(){
            axios.get('get_clases_terminadas').then(response => {
                this.clases_terminadas = response.data.cant.cant;   
            });
        },
        get_clases: function(){
            axios.get('./').then(response => {
                this.clases = response.data; 
            });
        },
        buscar_profesor: function(){
            this.open_sidebar = true;
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
                'clases_detalle_id': this.clases_detalle_id,
                'clases_id': clase_id
            }).then(response => {
                if (response.data.code == 200) {
                    l.ladda('stop');
                    $('#calendar').fullCalendar( 'refetchEvents' );
                    this.verSidebar = 0;
                    this.get_clases();
                }
            });
        },
        terminar_modulo: function(){
            var l = $('#btn-terminar').ladda();
                l.ladda( 'start' );
            axios.post('terminar_modulo', {
                'estudiantes_id': this.estudiantes_reprobados,
                'clases_id': clase_id
            }).then(response => {
                if (response.data.code == 200) {
                    l.ladda('stop');
                    this.verSidebar = 0;
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
            this.open_sidebar = true;
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
        },
        asistenciaUrl: function(){
            location.href = "asistencia";
        },
        formato_fecha: function(fecha){
            return formato_fecha(fecha);
        }
    }
    
});