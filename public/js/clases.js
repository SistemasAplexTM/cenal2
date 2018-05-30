$(document).ready(function () {

    $('#data_1 .input-group.date').datepicker({
        language: 'es',
        todayBtn: "linked",
        calendarWeeks: true,
        autoclose: true,
    });

    var table = $('#tbl-clases').DataTable({
        processing: true,
        serverSide: true,
        ajax: './all',
        columns: [
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var btn_edit =  "<a href='../" + full.id + "/edit' class='btn btn-warning btn-sm'><i class='fa fa-folder'></i> Detalles </a> ";
                    return btn_edit ;
                }
            },
            {
                searchable: true,
                className: 'project-title',
                "render": function (data, type, full, meta) {
                    var inicio = moment(full.fecha_inicio).format('DD-MM-YYYY')
                    var fin = moment(full.fecha_fin).format('DD-MM-YYYY')
                    return  "<a href='../" + full.id + "/edit'>Múdolo "+full.modulo+"</a><br/><small>Inicio: "+inicio+" - Fin: "+fin+"</small>";
                }
            },
            {
                className: 'project-title',
                sortable: false,
                "render": function (data, type, full, meta) {
                    return full.salon;
                }
            },
            { 
                "render": function (data, type, full, meta) {
                    return "<span class='label label-"+full.clase_estado+"'>"+ full.estado+"</span>";                    
                }
            },
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var porcentaje = full.completadas/full.total*100;
                    var btn_progreso =  "<small>Conpletadas: "+full.completadas+" de "+full.total+"</small><div class='progress progress-mini'><div style='width: "+porcentaje+"%;background-color: #1c84c6' class='progress-bar'></div></div>";
                    return btn_progreso;
                }
            },
            {
                "render": function (data, type, full, meta) {
                    if (roles.includes('Administrador') || roles.includes('Coordinador')) {
                        if (full.profesor_id == 'null' || full.profesor_id == null || full.profesor_id == 'NULL' ) {
                            return "Sin asignar";
                        }else{
                            return full.profesor;                        
                        }
                    }
                    if (roles.includes('Profesor')) {
                        return '';
                    }
                }
            }
        ]
    });

});

var objVue = new Vue({
    el: '#clases',
    data:{
        salon:'',
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
        programas: {},
        hora_inicio_jornada: '',
        hora_fin_jornada: '',
        cargando_programa: 0,
        estudiantes: {},
        profesores: {},
        formErrors: {}
    },
    created(){
        this.get_estudiantes_inscritos();
    },
    methods:{
        get_profesor_asignado: function(){
            axios.get('profesor_asignado').then(response => {
                if (response.data[0].profesor.length > 0) {
                    this.profesor_asignado = response.data[0].profesor;   
                }
            });
        },
        get_estudiantes_inscritos: function(){
            axios.get('../../estudiantes_inscritos/' + grupo_id).then(response => {
                this.estudiantes_inscritos = response.data;   
            });
        },
        programar_sgte_modulo: function(){
            axios.get('../../programar_modulo/' + grupo_id).then(response => {
                if (response.data['code'] == 200) {
                    toastr.success('Registrado con éxito');
                    toastr.options.closeButton = true;
                    recargarTabla('tbl-clases');
                }else if(response.data['code'] == 300){
                    toastr.warning('No hay más módulos');
                }
                else{
                    toastr.error('Error al registrar');
                    alert(response.data);
                }
            });
        }
    }
    
});