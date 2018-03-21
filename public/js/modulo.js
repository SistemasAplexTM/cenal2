$(document).ready(function () {
    $('#tbl-modulos tfoot th ').each( function (key, value) {
        var title = $(this).text();
        $(this).html( '<div id="form-group'+key+'"><input class="form-control input-sm input-search" id="input'+key+'" type="text" placeholder="Buscar '+title+'" /></div>' );
        $('.none').html('<button class="btn btn-success btn-xs" onclick="saveData()"><i class="fa fa-save" ></i></button>');
    });
    var table = $('#tbl-modulos').DataTable({
        keys: true,
        processing: true,
        serverSide: true,
        ajax: 'modulo/all',
        columns: [
            { data: "nombre", name: 'nombre'},
            { data: "duracion", name: 'duracion'},
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var btn_delete = " <a id='btn_delete_"+full.id+"' onclick=\"confirm("+full.id+")\" class='btn btn-outline btn-danger btn-xs' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_confirm = " <a id='btn_confirm_"+full.id+"' onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs hide' title='Confirmar'><i class='fa fa-check'></i></a> ";
                    var btn_cancel = " <a id='btn_cancel_"+full.id+"' onclick=\"cancel(" + full.id + ")\" class='btn btn-outline btn-primary btn-xs hide' title='Confirmar'><i class='fa fa-times'></i></a> ";

                    return  btn_delete + btn_confirm + btn_cancel;
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
});

function saveData(){
    var nombre = $("#input0").val();
    var duracion = $("#input1").val();
    objVue.store(nombre, duracion);
}

function confirm(id){
    $("#btn_delete_" + id).removeClass('show');
    $("#btn_confirm_" + id).removeClass('hide');
    $("#btn_cancel_" + id).removeClass('hide');
    $("#btn_delete_" + id).addClass('hide');
    $("#btn_confirm_" + id).addClass('show');
    $("#btn_cancel_" + id).addClass('show');
}

function cancel(id){
    $("#btn_delete_" + id).addClass('show');
    $("#btn_confirm_" + id).addClass('hide');
    $("#btn_cancel_" + id).addClass('hide');
    $("#btn_delete_" + id).removeClass('hide');
    $("#btn_confirm_" + id).removeClass('show');
    $("#btn_cancel_" + id).removeClass('show');
}


var objVue = new Vue({
    el: '#crud_modulo',
    data:{
        nombre:'',
        duracion:'',
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
                'duracion': duracion
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
                axios.delete('modulo/' + data.id).then(response => {
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
        update: function update() {
            var urlUpdate = 'modulo/' + this.id;
            var me = this;
            axios.put(urlUpdate, {
                'nombre' : this.nombre,
                'duracion' : this.duracion
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
                me.resetForm();
                me.updateTable();
            }).catch(function (error) {
                me.listErrors = '';
                if (error.response.status === 422) {
                    me.formErrors = error.response.data;
                }
                toastr.error("Porfavor completa los campos obligatorios.", {timeOut: 50000});
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
        },
        edit: function(data){
            this.id = data['id'];
            this.nombre = data['nombre'];
            this.duracion = data['duracion'];
            this.editar = 1;
            this.formErrors = {};
        },
        cancel: function(){
            this.resetForm();
        }
    }
    
});