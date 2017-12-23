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

var objVue = new Vue({
    el: '#crud_modulo',
    data:{
        nombre:''
    },
    methods:{
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
        }
    }
    
});