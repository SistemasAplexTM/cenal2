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
                    var btn_edit =  "<a data-toggle='tooltip' data-placement='rigth' title='Click para ver módulos programados' href='clases/" + full.id +"/grupo' class='btn btn-warning btn-sm'><i class='fa fa-folder'></i> Detalles </a> ";
                    return btn_edit;
                }
            },
            {
                searchable: true,
                className: 'project-title',
                "render": function (data, type, full, meta) {
                    // return  "<h2><a data-toggle='tooltip' title='Click para ver y agregar estudiantes' onclick='setGrupo("+full.id+", \""+full.nombre+"\")'> "+full.nombre+"</a></h2>";
                    return  "<h2>" + full.nombre + "</h2>";
                }
            },
            { 
                "render": function (data, type, full, meta) {
                    return "<span class='label label-"+full.clase_estado+"'>"+ full.estado+"</span>";                    
                }
            },
            { data: "sede", name: 'sede'},
            { data: "jornada", name: 'jornada'}
        ],
        "fnCreatedRow": function( nRow, aData, iDataIndex ) {
            $(nRow).attr('id', aData['id']);
        }
    });
});

function setGrupo(id, grupo){
    objVue.setGrupo(id, grupo);
}

var objVue = new Vue({
    el: '#grupos',
    data:{
        dato_estudiante: '',
        estudiantes_inscritos: {},
        view: '',
        show: true,
        grupo: '',
        isActiveStudent: false,
        grupo_exist: {},
        estudiantes: {}
    },
    methods:{
        buscar_estudiante: function(){
            this.btn_confirm = true;
            this.btn_retirar = false;
            if (this.dato_estudiante.length <= 0) {
                return false;
            }
            if (this.grupo.length <= 0) {
                alert('Debe seleccionar un grupo para asignar un estudiante');
                return false;
            }
            var dato = this.dato_estudiante;
            this.view = 'buscar';
            axios.get('buscar_estudiante/' + dato).then(response => {
                this.estudiantes = response.data;
            });
        },
        agregar_estudiante: function(grupo_id, id){
            axios.get('grupo/'+grupo_id+'/agregar_estudiante/' + id).then(response => {
                this.dato_estudiante = '';
                this.grupo_exist = {};
                if (response.data.code == 600) {
                    alert('Repetido');
                    return;
                }
                if (response.data.code == 601) {
                    this.grupo_exist = response.data.data[0];
                }
                if (response.data.code == 200) {
                    this.get_estudiantes_inscritos(grupo_id);
                    this.updateTable();
                    this.estudiantes = {};
                }
            });
        },
        retirar_estudiante: function(id){
            axios.get('retirar_estudiante/' + id).then(response => {
                if (response.data.code == 200) {
                    this.updateTable();
                    this.get_estudiantes_inscritos();
                    this.estudiantes = {};
                    this.btn_confirm = true;
                    this.btn_retirar = false;
                }
            });
        },
        get_estudiantes_inscritos: function(){
            this.dato_estudiante = '';
            this.view = 'inscritos';
            axios.get('estudiantes_inscritos/' + this.grupo.id).then(response => {
                this.estudiantes_inscritos = response.data;   
            });
        },
        resaltarBuscar: function(){
            $('#buscar_estudiante').focus();
            $('#buscar_estudiante').effect("highlight", {color:"#aadeff"}, 2000);
        },
        setGrupo: function(id, grupo, estudiante_id){
            this.dato_estudiante = '';
            this.estudiantes = {};
            this.grupo = {id: id, nombre: grupo};
            this.get_estudiantes_inscritos(id);
            $('tr').removeClass('active');
            $('#' + id).addClass('active');
            if (estudiante_id != 'undefinde') {
                this.isActiveStudent = estudiante_id;
            }
        },
        updateTable: function(){
            recargarTabla('tbl-grupos');
        },
    }
    
});