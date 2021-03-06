$(document).ready(function () {
    $('#tbl-festivos').DataTable({
        processing: true,
        serverSide: true,
        ajax: 'festivos/all',
        columns: [
            { data: "año", name: 'año'},
            { data: "dia_festivo", name: 'dia_festivo'},
            {
                sortable: false,
                "render": function (data, type, full, meta) {
                    var params = [
                        full.id,
                        full.año,
                        full.dia_festivo
                    ];
                    var btn_delete = " <a onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
                    var btn_edit =  "<a onclick=\"edit(" + params + ")\" class='btn btn-outline btn-success btn-xs' data-toggle='tooltip' data-placement='top' title='Editar'><i class='fa fa-edit'></i></a> ";
                    return btn_edit + btn_delete;
                }
            }
        ]
    });
    $('#dia_festivo').datepicker({
        language: 'es',
        todayBtn: "linked",
        calendarWeeks: true,
        autoclose: true,
    });
});

function edit(id,año, dia_festivo){
    var data ={
        id:id,
        año: año,
        dia_festivo: dia_festivo
    };
    objVue.edit(data);
}


var objVue = new Vue({
    el: '#crud_festivos',
    data:{
        año:'',
        dia_festivo:'',
        editar: 0,
        formErrors: {}
    },
    methods:{
        resetForm: function(){
            this.año = '';
            this.dia_festivo = '';
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
            axios.post('festivos',{
                'año': me.año,
                'dia_festivo': me.dia_festivo
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
                recargarTabla('tbl-festivos');
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
                axios.get('festivos/delete/' + data.id + '/' + data.logical).then(response => {
                    recargarTabla('tbl-festivos');
                    toastr.success("<div><p>Registro eliminado exitosamente.</p><button type='button' onclick='deshacerEliminar(" + data.id + ")' id='okBtn' class='btn btn-xs btn-danger pull-right'><i class='fa fa-reply'></i> Restaurar</button></div>");
                    toastr.options.closeButton = true;
                });
            }else{
                axios.delete('festivos/' + data.id).then(response => {
                    recargarTabla('tbl-festivos');
                    toastr.success('Registro eliminado correctamente.');
                    toastr.options.closeButton = true;
                });
            }
        },
        deshacerDelete: function(data){
            var urlRestaurar = 'festivos/restaurar/' + data.id;
            axios.get(urlRestaurar).then(response => {
                toastr.success('Registro restaurado.');
                recargarTabla('tbl-festivos');
            });
        },
        update: function update() {
            var urlUpdate = 'festivos/' + this.id;
            var me = this;
            axios.put(urlUpdate, {
                'año': me.año,
                'dia_festivo': me.dia_festivo
            }).then(function (response) {
                if (response.data['code'] == 200) {
                    toastr.success('Registro actualizado correctamente');
                    toastr.options.closeButton = true;
                } else {
                    toastr.warning(response.data['error']);
                    toastr.options.closeButton = true;
                }
                me.resetForm();
                recargarTabla('tbl-salon');
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
            this.año = data['año'];
            this.dia_festivo = data['dia_festivo'];
            this.editar = 1;
            this.formErrors = {};
        },
        cancel: function(){
            this.resetForm();
        },
    }
    
});