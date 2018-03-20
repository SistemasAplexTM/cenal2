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
            objVue.ver_listado = false;
            objVue.cambiar_salon = true;
            objVue.estado = event.estado;
            objVue.clases_detalle_id = event.id;
            objVue.salon = event.salon;
            objVue.getSalonesBySede(event.sede_id);
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
                objVue.ver_listado = true;
                objVue.cambiar_salon = false;
            }
            $('#mdl_clase').modal('show');
        }
      });

    $('#agregar').on('click', function () {
        var $btn = $(this).button('loading');
        // business logic...
        // $btn.button('reset');
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
        ver_listado: false,
        cambiar_salon: false,
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
        estudiantes_inscritos: {},
        estudiantes_result: {},
        programas: {},
        salones: {},
        hora_inicio_jornada: '',
        hora_fin_jornada: '',
        estado: '',
        dato_buscar: '',
        cargando_programa: 0,
        editar_salon: 0,
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
        buscar_estudiante: function(){
            var dato = this.dato_estudiante;
            axios.get('../buscar_estudiante/' + dato).then(response => {
                this.estudiantes = response.data; 
                $('#mdl_agregar_estudiante').modal('show');
                // $('#tbl_add_student').DataTable(); 
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
                $("#mdl_clase").modal('hide');
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
                }
                if (response.data.code == 300) {
                     // $(".asistencia").removeClass('todo-completed');
                }
            });
        },
        buscar_estudiante_modal: function(){
            this.estudiantes_result = {};
            let result = this.estudiantes.filter(student => student.consecutivo.toLowerCase().match(this.dato_buscar) );
            this.estudiantes_result = result;
        }
    }
    
});