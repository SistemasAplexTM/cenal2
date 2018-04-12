$(document).ready(function () {
    $('#tbl-grupos').DataTable({
        processing: true,
        serverSide: true,
        ajax: 'grupos/all/',
        columns: [
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    //var btn_delete = " <a onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_edit =  "<a href='clases/" + full.id +"/grupo' class='btn btn-warning btn-sm'><i class='fa fa-folder'></i> Detalles </a> ";
                    return btn_edit;
                }
            },
            {
                searchable: true,
                className: 'project-title',
                "render": function (data, type, full, meta) {
                    return  "<h2><a href='clases/" + full.id +"/grupo'> "+full.nombre+"</a></h2>";
                }
            },
            { data: "fecha_inicio", name: 'fecha_inicio'},
            { 
                "render": function (data, type, full, meta) {
                    return "<span class='label label-"+full.clase_estado+"'>"+ full.estado+"</span>";                    
                }
            },
            { data: "sede", name: 'sede'},
            { data: "cantidad", name: 'cantidad'},
            { data: "jornada", name: 'jornada'}
        ]
    });
});

var objVue = new Vue({
    el: '#grupos',
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
    methods:{
        get_profesor_asignado: function(){
            axios.get('profesor_asignado').then(response => {
                if (response.data[0].profesor.length > 0) {
                    this.profesor_asignado = response.data[0].profesor;   
                }
            });
        }
    }
    
});