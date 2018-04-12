$(function () {
    $('body').tooltip({
        selector: 'a[rel="tooltip"], [data-toggle="tooltip"]'
    });
});
$(document).ready(function(){
   getTable('a'); 
});
function getTable(on_delete) {
    $("#tbl-modulos").dataTable().fnDestroy();
    if (on_delete === 'a') {
        $('#tbl-modulos tfoot th ').each( function (key, value) {
            $(this).show();
            $(this).html( '<input class="form-control input-sm input-search" id="input'+key+'" type="text" placeholder="Buscar o  Registrar" />' );
            $('.none').html('<button class="btn btn-success btn-xs" data-toggle="tooltip" title="Guardar" onclick="saveData()"><i class="fa fa-save" ></i></button>');
        });
    }else{
        $('#tbl-modulos tfoot th').each( function (key, value) {
            $(this).hide();
        });
    }
    var table = $('#tbl-modulos').DataTable({
        keys: true,
        processing: true,
        serverSide: true,
        ajax: 'modulo/all/' + on_delete,
        columns: [
            { data: "nombre", name: 'nombre'},
            { data: "duracion", name: 'duracion'},
            {
                "render": function (data, type, full, meta) {
                    return "<div width='10px' style='background-color: "+ full.color+"'></div>";
                }
            },
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    return imp_btn(on_delete, full.id);
                }
            }
        ],
        'columnDefs': [
            {
                'targets': [0,1],
                'createdCell':  function (td, cellData, rowData, row, col) {
                   $(td).attr('contenteditable', true); 
                }
            }
          ]
    });
    table.on('key', function ( e, datatable, key, cell, originalEvent ) {
        if (key == 13) {
            cell.data( $(cell.node()).html() ).draw();
            var rowData = datatable.row( cell.index().row ).data();
            objVue.updateCell(rowData);
        }
    });
    table.columns().every( function () {
        var that = this;
        $( 'input', this.footer() ).on( 'keyup change', function () {
            if ( that.search() !== this.value ) {
                that.search( this.value ).draw();
            }
        } );
    });
}

function saveData(){
    var nombre = $("#input0").val();
    var duracion = $("#input1").val();
    objVue.store(nombre, duracion);
}


var objVue = new Vue({
    el: '#crud_modulo',
    data:{
        nombre:'',
        duracion:'',
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
            this.duracion = '';
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
                duracion = me.duracion;
            }
            axios.post('modulo/store',{
                'nombre': nombre,
                'duracion': duracion,
                'color': color
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
        },
        updateCell: function updateCell(rowData) {
            var urlUpdate = 'modulo/updateCell';
            var me = this;
            axios.put(urlUpdate, {
                'obj' : rowData
            }).then(function (response) {
                if (response.data['code'] == 200) {
                    toastr.success('Registro actualizado correctamente');
                    toastr.options.closeButton = true;
                    me.editar = 0;
                } else {
                    toastr.warning(response.data['error']);
                    toastr.options.closeButton = true;
                    console.log(response.data);
                }
                me.updateTable();
            }).catch(function (error) {
                me.listErrors = '';
                if (error.response.status === 422) {
                    me.formErrors = error.response.data;
                }
                toastr.error("Porfavor completa los campos obligatorios.", {timeOut: 50000});
            });
        }
    }
});