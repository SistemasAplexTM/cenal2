$(document).ready(function () {
    $('#tbl-user').DataTable({
        processing: true,
        serverSide: true,
        ajax: 'user/all',
        columns: [
            { data: "identification_card", name: 'identification_card'},
            { data: "nombre", name: 'nombre'},
            { data: "email", name: 'email'},
            { data: "rol", name: 'rol'},
            { data: "sede", name: 'sede'},
            {
                "render": function (data, type, full, meta) {
                    var activo = '';
                    if (full.activo == 0) {
                        // estado = '<label class="checkbox-inline i-checks check-link estudiante_asistencia"><input type="checkbox" checked onclick="change_state_user(0,'+full.id+')" value="" ></label>';
                        estado = '<input type="checkbox" checked="" onclick="change_state_user(0,'+full.id+')">';
                        // estado = '<div class="switch"><div class="onoffswitch"><input type="checkbox" checked onclick="change_state_user(0,'+full.id+')" class="onoffswitch-checkbox" id="example2"><label class="onoffswitch-label" for="example1"><span class="onoffswitch-inner"></span><span class="onoffswitch-switch"></span></label></div></div>';
                    }else{
                        estado = '<input type="checkbox" onclick="change_state_user(1,'+full.id+')">';
                        // estado = '<div class="switch"><div class="onoffswitch"><input type="checkbox" onclick="change_state_user(1,'+full.id+')" class="onoffswitch-checkbox" id="example2"><label class="onoffswitch-label" for="example1"><span class="onoffswitch-inner"></span><span class="onoffswitch-switch"></span></label></div></div>'
                    }
                    return estado;
                }
            },
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var params = [
                        full.id, 
                        "'" + full.name + "'",
                        "'" + full.last_name + "'",
                        "'" + full.address + "'",
                        "'" + full.phone + "'",
                        "'" + full.cellphone + "'",
                        "'" + full.email + "'"
                    ];
                    var btn_delete = " <a onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_edit =  "<a onclick=\"edit(" + params + ")\" class='btn btn-outline btn-success btn-xs' data-toggle='tooltip' data-placement='top' title='Editar'><i class='fa fa-edit'></i></a> ";
                    return btn_edit + btn_delete;
                }
            }
        ]
    });
    initSelect2();

});
function initSelect2(){
    $('#roles').select2({
        tags: true,
        tokenSeparators: [','],
        ajax: {
            url: 'user/getRolesForSelect2',
            dataType: 'json',
            delay: 250,
            data: function(params) {
                return {
                    term: params.term
                }
            },
            processResults: function (data, page) {
                return {
                    results: data
                };
            }
        }
    });
}

function edit(id, name, last_name, address, phone, cellphone, email){
    var data ={
        id:id,
        name: name,
        last_name: last_name,
        address: address,
        phone: phone,
        cellphone: cellphone,
        email: email
    };
    objVue.edit(data);
}

function change_state_user(action, user){
    objVue.change_state_user(action, user);
}


var objVue = new Vue({
    el: '#crud_profesor',
    data:{
        name:'',
        last_name: '',
        address: '',
        phone: '',
        cellphone: '',
        email: '',
        user_id: '',
        identification_card: '',
        roles: {},
        editar: 0,
        formErrors: {}
    },
    methods:{
        resetForm: function(){
            this.identification_card = '';
            this.name = '';
            this.last_name = '',
            this.address = '',
            this.phone = '',
            this.cellphone = '',
            this.email = '',
            this.roles = {},
            $('#roles').val(null).trigger('change');
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
            axios.post('user',{
                'identification_card': me.identification_card,
                'name': me.name,
                'last_name': me.last_name,
                'address': me.address,
                'phone': me.phone,
                'cellphone': me.cellphone,
                'email': me.email,
                'sede': $('#sede').val(),
                'roles': $('#roles').val()
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
                recargarTabla('tbl-user');
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
                axios.get('user/delete/' + data.id + '/' + data.logical).then(response => {
                    toastr.success("<div><p>Registro eliminado exitosamente.</p><button type='button' onclick='deshacerEliminar(" + data.id + ")' id='okBtn' class='btn btn-xs btn-danger pull-right'><i class='fa fa-reply'></i> Restaurar</button></div>");
                    toastr.options.closeButton = true;
                });
            }else{
                axios.delete('user/' + data.id).then(response => {
                    toastr.success('Registro eliminado correctamente.');
                    toastr.options.closeButton = true;
                });
            }
            recargarTabla('tbl-user');
        },
        deshacerDelete: function(data){
            axios.get('user/restaurar/' + data.id).then(response => {
                toastr.success('Registro restaurado.');
                recargarTabla('tbl-user');
            });
        },
        update: function update() {
            var urlUpdate = 'user/' + this.id;
            var me = this;
            axios.put(urlUpdate, {
                'identification_card': me.identification_card,
                'name': me.name,
                'last_name': me.last_name,
                'address': me.address,
                'phone': me.phone,
                'cellphone': me.cellphone,
                'email': me.email,
                'roles': me.roles
            }).then(function (response) {
                me.resetForm();
                recargarTabla('tbl-user');
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
        getDataUser: function(){
            var user = this.user_id;
            if (user == '') {
                user = null
            }
            axios.get('user/getDataUser/' + user).then(response => {
                if (response.data.data == false) {
                    this.name = '';    
                    this.email = '';    
                }else{
                    this.name = response.data.data[0].name;
                    this.email = response.data.data[0].email;
                }
            });
        },
        change_state_user: function(action, user){
            axios.put('user/change_state', {
                user: user,
                action: action
            }).then(response => {
                
            });
        },
        edit: function(data){
            this.id = data['id'];
            this.name = data['name'];
            this.identification_card = data['identification_card'];
            this.last_name = data['last_name'],
            this.address = data['address'],
            this.phone = data['phone'],
            this.cellphone = data['cellphone'],
            this.email = data['email'],
            this.editar = 1;
            this.formErrors = {};
        },
        cancel: function(){
            this.resetForm();
        },
    }
    
});