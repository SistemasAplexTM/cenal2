$(document).ready(function () {
    $('#tbl-modulos').DataTable({
        processing: true,
        serverSide: true,
        ajax: 'modulo/all',
        columns: [
            { data: "id", name: 'id' },
            { data: "nombre", name: 'nombre'},
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var params = [
                        full.id, 
                        "'" + full.nombre + "'"
                    ];
                    var btn_delete = " <a onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_edit =  "<a onclick=\"edit(" + params + ")\" class='btn btn-outline btn-success btn-xs' data-toggle='tooltip' data-placement='top' title='Editar'><i class='fa fa-edit'></i></a> ";
                    return btn_edit + btn_delete;
                }
            }
        ]
    });
});

function edit(id,nombre){
    var data ={
        id:id,
        nombre: nombre
    };
    objVue.edit(data);
}


var objVue = new Vue({
    el: '#crud_modulo',
    data:{
        nombre:'',
        editar: 0,
        formErrors: {}
    },
    methods:{
        updateTable: function(){
            recargarTabla('tbl-modulos');
        },
        resetForm: function(){
            this.nombre = '';
            this.editar = 0;
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
        store: function(){
            let me = this;
            axios.post('modulo/store',{
                'nombre': me.nombre
            })
            .then(function (response){
                toastr.success('Registrado con éxito');
                recargarTabla('tbl-modulos');
                this.nombre = '';
            })
            .catch(function(error){
                alert('error al registrar: ' + error);
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
                'nombre' : this.nombre
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
        edit: function(data){
            this.id = data['id'];
            this.nombre = data['nombre'];
            this.editar = 1;
            this.formErrors = {};
        },
        cancel: function(){
            this.id = '';
            this.nombre = '' ;
            this.editar = 0;
            this.formErrors = {};
        },
    }
    
});