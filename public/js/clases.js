$(document).ready(function () {
    $('#tbl-clases').DataTable();
    // $('#tbl-festivos').DataTable({
    //     processing: true,
    //     serverSide: true,
    //     ajax: 'festivos/all',
    //     columns: [
    //         { data: "año", name: 'año'},
    //         { data: "dia_festivo", name: 'dia_festivo'},
    //         {
    //             sortable: false,
    //             "render": function (data, type, full, meta) {
    //                 var params = [
    //                     full.id,
    //                     full.año,
    //                     full.dia_festivo
    //                 ];
    //                 var btn_delete = " <a onclick=\"eliminar(" + full.id + ","+true+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' data-placement='top' title='Eliminar'><i class='fa fa-trash'></i></a> ";
    //                 var btn_edit =  "<a onclick=\"edit(" + params + ")\" class='btn btn-outline btn-success btn-xs' data-toggle='tooltip' data-placement='top' title='Editar'><i class='fa fa-edit'></i></a> ";
    //                 return btn_edit + btn_delete;
    //             }
    //         }
    //     ]
    // });

});

var objVue = new Vue({
    el: '#clases',
    data:{
        salon:'',
        capacidad:'',
        ubicacion:'',
        duracion:'',
        jornada:'',
        formErrors: {}
    },
    methods:{
        resetForm: function(){
            this.capacidad = '';
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
        setCapacidad: function(){
            this.capacidad = $("#salon").find(':selected').data("capacidad")
        },
        setDuracion: function(){
            this.duracion = $("#modulo").find(':selected').data("capacidad")
        }
    }
    
});