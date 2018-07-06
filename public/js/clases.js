$(document).ready(function () {

    $('#data_1 .input-group.date').datepicker({
        language: 'es',
        todayBtn: "linked",
        calendarWeeks: true,
        autoclose: true,
    });
    datos();
});

function datos(ciclo){
    var url_all = './all';
    if (ciclo) {
        url_all = './all/' + ciclo;
    }
    $("#tbl-clases").dataTable().fnDestroy();
    var table = $('#tbl-clases').DataTable({
        processing: true,
        serverSide: true,
        ajax:  url_all,
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
                    return  "<a href='../" + full.id + "/edit'><h2>Múdolo "+full.modulo+"<br/><small>Inicio: "+inicio+" - Fin: "+fin+"</small></h2></a>";
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
                    var btn_progreso =  "<small>Completadas: "+full.completadas+" de "+full.total+"</small><div class='progress progress-mini'><div style='width: "+porcentaje+"%;background-color: #1c84c6' class='progress-bar'></div></div>";
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
}

var objVue = new Vue({
    el: '#clases',
    data:{
        omitirErrores: false,
        omitirErroresT: false,
        salones: [],
        ciclos: [],
        ciclo: '',
        ciclo_actual: '',
        salon:'',
        desde:'',
        hasta:'',
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
        modulos: {},
        terminados: {},
        programas: {},
        hora_inicio_jornada: '',
        hora_fin_jornada: '',
        cargando_programa: 0,
        limit: 5,
        estudiantes: {},
        profesores: {},
        semana: [],
        fechasError: {},
        formErrors: {}
    },
    created(){
        this.get_modulos();
        this.getSalonesBySede();
        this.get_ciclos();
    },
    methods:{
        get_profesor_asignado: function(){
            axios.get('profesor_asignado').then(response => {
                if (response.data[0].profesor.length > 0) {
                    this.profesor_asignado = response.data[0].profesor;   
                }
            });
        },
        programar_sgte_modulo: function(ciclo){ 
            axios.post('../../programar_modulo/' + grupo_id, {
                'ciclo': ciclo,
                'desde': this.desde,
                'hasta': this.hasta,
                'salon': this.salon,
                'omitirErrores': this.omitirErrores,
                'omitirErroresT': this.omitirErroresT
            }).then(response => {
                if (response.data['code'] == 200) {
                    toastr.success('Registrado con éxito');
                    toastr.options.closeButton = true;
                    recargarTabla('tbl-clases');
                    this.salon = '';
                    this.omitirErrores = false;
                    this.omitirErroresT = false;
                    this.get_modulos();
                    this.get_ciclos();
                }else if(response.data['code'] == 300){
                    swal({
                      title: 'Ops!',
                      text: "Ya se han completado todos los módulos para este programa, ¿Desea crear el siguiente ciclo?",
                      type: 'warning',
                      showCancelButton: true,
                      confirmButtonColor: '#3085d6',
                      cancelButtonColor: '#d33',
                      confirmButtonText: 'Sí'
                    }).then((result) => {
                      if (result.value) {
                        this.programar_sgte_modulo(true);
                      }
                    })
                }else if(response.data['code'] == 600){
                    this.fechasError = response.data.fechas;
                    $('#mdl-error-salon').modal('show');
                }else if(response.data['code'] == 700){
                    swal({
                      title: 'Ops!',
                      text: response.data['exception'],
                      type: 'warning',
                      showCancelButton: true,
                      confirmButtonColor: '#3085d6',
                      cancelButtonColor: '#d33',
                      confirmButtonText: 'Aceptar',
                      cancelButtonText: 'Omitir advertencia'
                    }).then((result) => {
                      if (!result.value) {
                        this.omitirErroresT = true;
                        this.programar_sgte_modulo();
                      }
                    });
                }
                else{
                    toastr.error('Error al registrar');
                }
            });
        },
        get_modulos: function(){
            axios.get('./getModulos').then(response => {
                if (response.data['code'] == 200) {
                    this.modulos = response.data['data'];
                    this.terminados = response.data['terminados'];
                    this.semana = response.data['dias_clase'];
                }
            });
        },
        get_ciclos: function(){
            axios.get('./ciclos').then(response => {
                if (response.data['code'] == 200) {
                    this.ciclos = response.data['data'];
                    this.ciclo = {ciclo: response.data['actual']};
                    this.ciclo_actual = response.data['actual'];
                }
            });
        },
        getSalonesBySede: function(){
            axios.get('../../salon/getBySede/' + user.sede_id).then(response => {
                if (response.data.length > 0) {
                    this.salones = response.data;   
                }
            });
        },
        getByCiclo: function(){
            datos(this.ciclo.ciclo);
        }
    }
    
});