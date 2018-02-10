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
                "render": function (data, type, full, meta) {
                    return "<span class='label label-"+full.clase_estado+"'>"+ full.estado+"</span>";                    
                }
            },
            {
                className: 'project-title',
                "render": function (data, type, full, meta) {
                    var inicio = moment(full.fecha_inicio).format('DD-MM-YYYY')
                    var fin = moment(full.fecha_fin).format('DD-MM-YYYY')
                    return  "<a href='clases/" + full.id + "/edit'>Múdolo "+full.modulo+"</a><br/><small>Inicio: "+inicio+" - Fin: "+fin+"</small>";
                }
            },
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
                sortable: false,
                "render": function (data, type, full, meta) {
                    if (full.profesor == 'null') {
                        return  "<a href=''><img alt='image' class='img-circle' src=''> "+full.profesor+"</a>";                        
                    }else{
                        return  "<a href=''>Sin asignar</a>";                        
                    }
                }
            },
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    //var btn_delete = " <a onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_edit =  "<a href='#' class='btn btn-white btn-sm'><i class='fa fa-folder'></i> Detalles </a> ";
                    return btn_edit ;
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
          
        }
      });

    $('#agregar').on('click', function () {
        var $btn = $(this).button('loading');
        // business logic...
        // $btn.button('reset');
    })
});

var objVue = new Vue({
    el: '#clases',
    data:{
        salon:'',
        capacidad:'',
        ubicacion:'',
        duracion:'',
        jornada:'',
        dato_estudiante: '',
        estudiantes: {},
        formErrors: {}
    },
    methods:{
        resetForm: function(){
            this.capacidad = '';
            this.dato_estudiante = '';
            this.estudiantes = {};
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
            this.capacidad = $("#salon").find(':selected').data("capacidad")
        },
        setDuracion: function(){
            this.duracion = $("#modulo").find(':selected').data("capacidad")
        },
        buscar_estudiante: function(){
            var dato = this.dato_estudiante;
            axios.get('../buscar_estudiante/' + dato).then(response => {
                this.estudiantes = response.data;   
                $('#mdl_agregar_estudiante').modal('show');
            });
        }
    }
    
});