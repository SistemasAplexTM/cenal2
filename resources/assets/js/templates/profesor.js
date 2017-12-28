$(document).ready(function () {
    $('#tbl-profesor').DataTable({
        processing: true,
        serverSide: true,
        ajax: 'profesor/all',
        columns: [
            { data: "nombre", name: 'nombre'},
            { data: "apellidos", name: 'apellidos'},
            // { data: "direccion", name: 'direccion'},
            // { data: "telefono", name: 'telefono'},
            // { data: "celular", name: 'celular'},
            // { data: "correo", name: 'correo'},
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var params = [
                        full.id, 
                        "'" + full.nombre + "'",
                        "'" + full.apellidos + "'",
                        "'" + full.direccion + "'",
                        "'" + full.telefono + "'",
                        "'" + full.celular + "'",
                        "'" + full.correo + "'",
                        full.user_id, 
                    ];
                    var btn_delete = " <a onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_edit =  "<a onclick=\"edit(" + params + ")\" class='btn btn-outline btn-success btn-xs' data-toggle='tooltip' data-placement='top' title='Editar'><i class='fa fa-edit'></i></a> ";
                    return btn_edit + btn_delete;
                }
            }
        ]
    });
});

function edit(id, nombre, apellidos, direccion, telefono, celular, correo, user_id){
    var data ={
        id:id,
        nombre: nombre,
        apellidos: apellidos,
        direccion: direccion,
        telefono: telefono,
        celular: celular,
        correo: correo,
        user_id: user_id
    };
    objVue.edit(data);
}


var objVue = new Vue({
    el: '#crud_profesor',
    data:{
        nombre:'',
        apellidos: '',
        direccion: '',
        telefono: '',
        celular: '',
        correo: '',
        user_id: '',
        editar: 0,
        formErrors: {}
    },
    methods:{
        resetForm: function(){
            this.nombre = '';
            this.apellidos = '',
            this.direccion = '',
            this.telefono = '',
            this.celular = '',
            this.correo = '',
            this.user_id = '',
            this.editar = 0;
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
        create: function(){
            let me = this;
            axios.post('profesor',{
                'nombre': me.nombre,
                'apellidos': me.apellidos,
                'direccion': me.direccion,
                'telefono': me.telefono,
                'celular': me.celular,
                'correo': me.correo,
                'user_id': me.user_id
            })
            .then(function (response){
                 if (response.data['code'] == 200) {
                    toastr.success('Registrado con éxito');
                    toastr.options.closeButton = true;
                } else {
                    toastr.warning(response.data['error']);
                    toastr.options.closeButton = true;
                }
                mer.resetForm();
                recargarTabla('tbl-profesor');
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
                axios.get('profesor/delete/' + data.id + '/' + data.logical).then(response => {
                    toastr.success("<div><p>Registro eliminado exitosamente.</p><button type='button' onclick='deshacerEliminar(" + data.id + ")' id='okBtn' class='btn btn-xs btn-danger pull-right'><i class='fa fa-reply'></i> Restaurar</button></div>");
                    toastr.options.closeButton = true;
                });
            }else{
                axios.delete('profesor/' + data.id).then(response => {
                    toastr.success('Registro eliminado correctamente.');
                    toastr.options.closeButton = true;
                });
            }
            recargarTabla('tbl-profesor');
        },
        deshacerDelete: function(data){
            axios.get('profesor/restaurar/' + data.id).then(response => {
                toastr.success('Registro restaurado.');
                recargarTabla('tbl-profesor');
            });
        },
        update: function update() {
            var urlUpdate = 'profesor/' + this.id;
            var me = this;
            axios.put(urlUpdate, {
                'nombre': me.nombre,
                'apellidos': me.apellidos,
                'direccion': me.direccion,
                'telefono': me.telefono,
                'celular': me.celular,
                'correo': me.correo,
                'user_id': me.user_id
            }).then(function (response) {
                me.resetForm();
                recargarTabla('tbl-profesor');
                if (response.data['code'] == 200) {
                    toastr.success('Registro actualizado correctamente');
                    toastr.options.closeButton = true;
                } else {
                    toastr.warning(response.data['error']);
                    toastr.options.closeButton = true;
                }
            }).catch(function (error) {
                me.listErrors = '';
                if (error.response.status === 422) {
                    me.formErrors = error.response.data.errors;
                }
                toastr.error("Porfavor completa los campos obligatorios.", {timeOut: 50000});
            });
        },
        edit: function(data){
            this.id = data['id'];
            this.nombre = data['nombre'];
            this.apellidos = data['apellidos'],
            this.direccion = data['direccion'],
            this.telefono = data['telefono'],
            this.celular = data['celular'],
            this.correo = data['correo'],
            this.user_id = data['user_id'],
            this.editar = 1;
            this.formErrors = {};
        },
        cancel: function(){
            this.resetForm();
        },
    }
    
});