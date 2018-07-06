$(document).ready(function(){
    $.fn.editable.defaults.mode = 'inline';
    $.fn.editable.defaults.params = function (params) {
        params._token = $('meta[name="csrf-token"]').attr('content');
        return params;
    };
    getTable(); 
});
function getTable() {
    $('#tbl-modulos tfoot th').each( function (key, value) {
        $(this).show();
        $(this).html( '<input class="form-control input-sm input-search" id="input'+key+'" type="text" placeholder="Registrar" />' );
        $('.save').html('<button class="btn btn-success btn-xs" data-toggle="tooltip" title="Guardar" onclick="saveData()"><i class="fa fa-save" ></i></button>');
    });
    var table = $('#tbl-modulos').DataTable({
        processing: true,
        serverSide: true,
        ajax: 'modulo/all',
        columns: [
            { 
                "render": function (data, type, full, meta) {
                    return '<a data-name="nombre" data-pk="'+full.id+'" class="td_edit" data-type="text" data-placement="right" data-title="Nombre">'+full.nombre+'</a>';
                }
            },
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    return imp_btn(full.id);
                }
            }
        ],
        "drawCallback": function () {
            $(".td_edit").editable({
                ajaxOptions: {
                    type: 'post',
                    dataType: 'json'
                },
                url: "modulo/updateCell",
                validate:function(value){
                    if($.trim(value) == ''){
                        return 'Este campo es obligatorio!';
                    }
                }
            });
        }
    });
}

function saveData(){
    var nombre = $("#input0").val();
    objVue.store(nombre);
}


var objVue = new Vue({
    el: '#crud_modulo',
    data:{
        nombre:'',
        color:'',
        editar: 0,
        formErrors: {}
    },
    methods:{
        updateTable: function(){
            recargarTabla('tbl-modulos');
        },
        resetForm: function(){
            this.nombre = '';
            this.color = '';
            this.editar = 0;
            $(".input-search").val('');
            this.formErrors = {};
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
        store: function(nombre, duracion){
            let me = this;
            if (nombre == null && duracion == null) {
                nombre = me.nombre;
            }
            axios.post('modulo/store',{
                'nombre': nombre
            })
            .then(function (response){
                toastr.success('Registrado con éxito');
                me.resetForm();
                recargarTabla('tbl-modulos');
            })
            .catch(function(error){
                if (error.response.status === 422) {
                    me.formErrors = error.response.data.errors;
                }
                $.each(me.formErrors, function (key, value) {
                    $('.result-' + key).html(value);
                });
                toastr.error("Error al registrar.", {timeOut: 50000});
            });
        },
        delete: function(data){
            this.formErrors = {};
            if(data.logical === true){
                axios.get('modulo/delete/' + data.id + '/' + data.logical).then(response => {
                    this.updateTable();
                    toastr.success("<div><p>Registro eliminado exitosamente.</p><button type='button' onclick='deshacerEliminar(" + data.id + ")' id='okBtn' class='btn btn-xs btn-danger pull-right'><i class='fa fa-reply'></i> Restaurar</button></div>");
                    toastr.options.closeButton = true;
                });
            }else{
                axios.get('modulo/delete/' + data.id + '/' + data.logical).then(response => {
                    this.updateTable();
                    toastr.success('Registro eliminado correctamente.');
                    toastr.options.closeButton = true;
                });
            }
        },
        deshacerDelete: function(data){
            var urlRestaurar = 'modulo/restaurar/' + data.id;
            axios.get(urlRestaurar).then(response => {
                toastr.success('Registro restaurado.');
                this.updateTable();
            });
        }
    }
});