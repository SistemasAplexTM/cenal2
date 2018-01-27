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