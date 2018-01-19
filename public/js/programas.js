$(document).ready(function () {
    $('#sedes').select2();
    $('#tbl-programas').DataTable({
        processing: true,
        serverSide: true,
        ajax: 'programas/all',
        columns: [
            { data: "nombre", name: 'nombre'},
            { data: "sedes", name: 'sedes'},
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var params = [
                        full.id,
                        "'" + full.nombre + "'",
                        "'" + full.codigo + "'",
                        full.capacidad
                    ];
                    var btn_delete = " <a onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_edit =  "<a onclick=\"edit(" + params + ")\" class='btn btn-outline btn-success btn-xs' data-toggle='tooltip' data-placement='top' title='Editar'><i class='fa fa-edit'></i></a> ";
                    return btn_edit + btn_delete;
                }
            }
        ]
    });
});

function edit(id,nombre, sedes){
    var data ={
        id:id,
        nombre: nombre,
        sedes: sedes
    };
    objVue.edit(data);
}


var objVue = new Vue({
    el: '#crud_programas',
    data:{
        nombre:'',
        sedes: [],
        editar: 0,
        formErrors: {}
    },
    methods:{
        resetForm: function(){
            this.nombre = '';
            this.sedes = [];
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
        create: function(){
            let me = this;
            axios.post('programas',{
                'nombre': me.nombre,
                'sedes': $('#sedes').val()
            })
            .then(function (response){
                if (response.data['code'] == 200) {
                    toastr.success('Registrado con éxito');
                    toastr.options.closeButton = true;
                } else {
                    toastr.warning(response.data['error']);
                    toastr.options.closeButton = true;
                }
                me.resetForm();
                recargarTabla('tbl-programas');
            })
            .catch(function(error){
                if (error.response.status === 422) {
                    me.formErrors = error.response.data.errors;
                }
                $.each(me.formErrors, function (key, value) {
                    $('.result-' + key).html(value);
                });
                toastr.error("Porfavor completa los campos obligatorios.", {timeOut: 50000});
            });
        },
        delete: function(data){
            if(data.logical === true){
                axios.get('programas/delete/' + data.id + '/' + data.logical).then(response => {
                    recargarTabla('tbl-programas');
                    toastr.success("<div><p>Registro eliminado exitosamente.</p><button type='button' onclick='deshacerEliminar(" + data.id + ")' id='okBtn' class='btn btn-xs btn-danger pull-right'><i class='fa fa-reply'></i> Restaurar</button></div>");
                    toastr.options.closeButton = true;
                });
            }else{
                axios.delete('programas/' + data.id).then(response => {
                    recargarTabla('tbl-programas');
                    toastr.success('Registro eliminado correctamente.');
                    toastr.options.closeButton = true;
                });
            }
        },
        deshacerDelete: function(data){
            var urlRestaurar = 'programas/restaurar/' + data.id;
            axios.get(urlRestaurar).then(response => {
                toastr.success('Registro restaurado.');
                recargarTabla('tbl-programas');
            });
        },
        update: function update() {
            var urlUpdate = 'programas/' + this.id;
            var me = this;
            axios.put(urlUpdate, {
                'nombre': me.nombre,
                'sedes': me.sedes
            }).then(function (response) {
                if (response.data['code'] == 200) {
                    toastr.success('Registro actualizado correctamente');
                    toastr.options.closeButton = true;
                } else {
                    toastr.warning(response.data['error']);
                    toastr.options.closeButton = true;
                }
                me.resetForm();
                recargarTabla('tbl-programas');
            }).catch(function (error) {
                if (error.response.status === 422) {
                    me.formErrors = error.response.data.errors;
                }
                $.each(me.formErrors, function (key, value) {
                    $('.result-' + key).html(value);
                });
                toastr.error("Porfavor completa los campos obligatorios.", {timeOut: 50000});
            });
        },
        edit: function(data){
            this.id = data['id'];
            this.nombre = data['nombre'];
            this.sedes = data['sedes'];
            this.editar = 1;
            this.formErrors = {};
        },
        cancel: function(){
            this.resetForm();
        },
    }
    
});