$(document).ready(function () {
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
                        "'" + full.modulos + "'"
                    ];
                    var btn_delete = " <a onclick=\"eliminar(" + full.id_prog_unicos + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_add_module =  "<a onclick=\"edit(" + params + ")\" class='btn btn-outline btn-success btn-xs' data-toggle='tooltip' data-placement='top' title='Agregar módulo'><i class='fa fa-edit'></i></a>";
                    return btn_add_module + btn_delete;
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
                            '<tr class="group" style="background-color: rgba(121, 171, 252, 0.2)"><td colspan="3">' + group + '</td></tr>'
                            );

                    last = group;
                }
            });
        },
    });
    $('#sedes').select2({
        tags: true,
        tokenSeparators: [','],
        ajax: {
            dataType: 'json',
            url: 'getAllSedesForSelect',
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
            },
        }
    });
    // $('#modulos').select2({
    //     tokenSeparators: [','],
    //     allowClear: true,
    //     ajax: {
    //         dataType: 'json',
    //         url: 'modulo/getAllForSelect',
    //         delay: 250,
    //         cache:false,
    //         data: function(params) {
    //             return {
    //                 term: params.term
    //             }
    //         },
    //         processResults: function (data, page) {
    //           return {
    //             results: data.items
    //           };
    //         },
    //     },
    //     escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
    //     templateResult: formatRepo,
    //     templateSelection: formatRepoSelection
    // });
});

function formatRepo (repo) {
  var markup = "<div class='select2-result-repository clearfix'>" +
    "<div class='select2-result-repository__meta'>" +
    "<div class='select2-result-repository__title'>" + repo.text + "</div>";

    markup += "<div class='select2-result-repository__statistics'>" +
    "<div class='select2-result-repository__forks'><i class='fa fa-clock-o'></i> " + repo.duracion + " <small>(clases)</small></div>" +
    "</div>" +
    "</div></div>";

  return markup;
}

function formatRepoSelection (repo) {
    console.log(repo);
    if (typeof repo.duracion != "undefined") {
        return repo.text + ' (' + repo.duracion + ')';
    }else{
        return repo.text;
    }
}

function edit(id,nombre, sedes, modulos){
    objVue.resetForm();
    var data ={
        id: id,
        nombre: nombre,
        sedes: sedes,
        modulos: modulos
    };
    objVue.edit(data);
}

var objVue = new Vue({
    el: '#crud_programas',
    data:{
        nombre:'',
        sedes: [],
        modulos: [],
        modulos_selected: [],
        editar: 0,
        formErrors: {}
    },
    created(){
        this.getModulos();
    },
    methods:{
        resetForm: function(){
            this.nombre = '';
            this.sedes = {};
            this.modulos_selected = [];
            this.editar = 0;
            $("#sedes").trigger("change");
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
            // me.modulos = $('#modulos').select2('data');
            // console.log(me.modulos);
            axios.post('programas',{
                'nombre' : this.nombre,
                'sedes' : $('#sedes').val(),
                'modulos' : me.modulos_selected
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
                toastr.error("Error al guardar.", {timeOut: 50000});
            });
        },
        delete: function(data){
            if(data.logical === true){
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
        getModulos: function(data){
            var url = 'modulo/getAllForSelect';
            axios.get(url).then(response => {
                this.modulos = response.data;
            });
        },
        update: function update() {
            var urlUpdate = 'programas/' + this.id;
            var me = this;
            axios.put(urlUpdate, {
                'nombre': me.nombre,
                'modulos': me.modulos_selected
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
            this.editar = 1;
            this.formErrors = {};
            /* ASIGNAR VALORES AL SELECT FUNCIONALIDADES */
            jsonModulos = JSON.parse(data['modulos']);
            this.modulos_selected = jsonModulos;
            // if(jsonModulos != null){
            //     $.each(jsonModulos, function(i, item) {
            //         var option = new Option(item.name + ' (' + item.duracion + ')', item.id, true, true);
            //         $('#modulos').append(option).trigger('change');
            //         // $("#modulos").append('<option value="'+item.id+'" selected="selected">'+ item.name+'</option>');
            //     });
            //     // $('#modulos').trigger('change'); // Notify any JS components that the value changed--
            // }
            $("#sedes").trigger("change");
            // $("#modulos").trigger("change");
        },
        add_module: function(data){
            this.id = data['id'];
            this.nombre = data['nombre'];
            this.editar = 2;
            $(".modulos").trigger("change");
            this.formErrors = {};
        },
        cancel: function(){
            this.resetForm();
        }
    }
    
});