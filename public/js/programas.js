$(document).ready(function () {
    $('#sedes').select2({
      tags: true
    });
    $('#tbl-programas').DataTable({
        processing: true,
        serverSide: true,
        ajax: 'programas/all',
        columns: [
            { data: "nombre", name: 'nombre', visible: false},
            { data: "programa", name: 'programa'},
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var params = [
                        full.id_prog_unicos,
                        "'" + full.programa + "'",
                        "'" + full.sede_id + "'",
                        full.capacidad
                    ];
                    var btn_delete = " <a onclick=\"eliminar(" + full.id_prog_unicos + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    // var btn_edit =  "<a onclick=\"edit(" + params + ")\" class='btn btn-outline btn-success btn-xs' data-toggle='tooltip' data-placement='top' title='Editar'><i class='fa fa-edit'></i></a> ";
                    // return btn_edit + btn_delete;
                    return btn_delete;
                }
            }
        ],
        "drawCallback": function (settings) {
            var api = this.api();
            var rows = api.rows({page: 'current'}).nodes();
            var last = null;

            api.column(0, {page: 'current'}).data().each(function (group, i) {
                if (last !== group) {
                    $(rows).eq(i).before(
                            '<tr class="group success"><td colspan="3">' + group + '</td></tr>'
                            );

                    last = group;
                }
            });
        },
    });
});

function edit(id,nombre, sedes){
    objVue.setDataSelect2(id);
    var data ={
        id: id,
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
            $('#sedes').val(null).trigger('change');
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
                // swal({
                //   title: 'Advertencia!',
                //   text: 'Al ser programas únicos, se eliminará de todas las sedes a la que pertenece.',
                //   type: 'error',
                //   confirmButtonText: 'Eliminar',
                //   confirmButtonColor: '#c94242',
                //   showCancelButton: true
                // },
                // function(isConfirm){
                //     if (isConfirm) {
                //        console.log('eliminado');
                //       } else {
                //        console.log('No eliminado');
                //       }
                // });
                swal({
                    title: 'Advertencia!',
                    text: 'Al ser programas únicos, se eliminará de todas las sedes a las que pertenece.',
                    confirmButtonText: 'Eliminar',
                    confirmButtonColor: '#c94242',
                    showCancelButton: true
                }).then(result => {
                  if (result.value) {
                    axios.get('programas/delete/' + data.id + '/' + data.logical).then(response => {
                        recargarTabla('tbl-programas');
                        toastr.success('Registro eliminado correctamente.');
                    });
                  } else {
                    
                  }
                })
                
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
        setDataSelect2: function(id_programa){
            var url = 'programas/getDataSedesByPrograma/' + id_programa;
            axios.get(url).then(response => {
                // $('#sedes').children().reove();
                $(response.data).each(function(index,value){
                    $("#sedes option[value="+ value.sede_id +"]").attr("selected", true);
                });
                $("#sedes").trigger("change");
            });
        }
    }
    
});