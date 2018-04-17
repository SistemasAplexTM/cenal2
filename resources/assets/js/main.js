$(document).ready(function () {
    $('.color').colorpicker();
    $('body').tooltip({
        selector: 'a[rel="tooltip"], [data-toggle="tooltip"]'
    });
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green',
        radioClass: 'iradio_square-green',
    });
    // Ladda.bind( '.ladda-button',{ timeout: 2000 });
    // var l = Ladda.bind('.ladda-button-demo');
    // l.click(function(){
    //     // Start loading
    //     l.ladda('start');
    //     // Do something in backend and then stop ladda
    //     // setTimeout() is only for demo purpose
    //     setTimeout(function(){
    //           l.ladda('stop');
    //     },2000);

    // });

});
$.extend( true, $.fn.dataTable.defaults, {
"language": {
    "paginate": {
        "previous": "Anterior",
        "next": "Siguiente",
    },
//            "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json",
    "info": "Registros del _START_ al _END_  de un total de _TOTAL_",
    "search": "Buscar",
    "lengthMenu": "Mostrar _MENU_ Registros",
    "infoEmpty": "Mostrando registros del 0 al 0",
    "emptyTable": "No hay datos disponibles en la tabla",
    "infoFiltered": "(Filtrando para _MAX_ Registros totales)",
    "zeroRecords": "No se encontraron registros coincidentes",
}
});
 $.fn.datepicker.dates['es'] = {
    days: ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"],
    daysShort: ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab"],
    daysMin: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa"],
    months: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio",
        "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
    monthsShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun",
        "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"],
    today: "Hoy",
    clear: "Limpiar",
    format: "yyyy-mm-dd",
    titleFormat: "MM yyyy", /* Leverages same syntax as 'format' */
    weekStart: 0
};

$('.chosen-select').select2();
 /*-- Función para recargar datatables --*/
function recargarTabla(tabla){
    $('#' + tabla).dataTable()._fnAjaxUpdate();
    table =  $('#' + tabla).DataTable();
            table
             .search( '' )
             .columns().search( '' )
             .draw();
};

/*-- Función para pasar el id de jQuery  a vue para eliminarlo --*/
function eliminar(id,logical){
    var data =
    {
        id:id,
        logical:logical
    };
    objVue.delete(data);    
}
/*-- Función para pasar el id de jQuery  a vue para deshacer el eliminado --*/
function deshacerEliminar(id){
    var data =
    {
        id:id
    };
    objVue.deshacerDelete(data);    
}

function imp_btn(on_delete,id){

    var btn_cancel = " <a id='btn_cancel_"+id+"' onclick=\"cancel('_cancel_'," + id + ")\" class='btn btn-outline btn-danger btn-xs hide' data-toggle='tooltip' title='Cancelar'><i class='fa fa-times'></i></a> ";    
    if (on_delete === 'a') {
        var btn_confirm = " <a id='btn_confirm_"+id+"' onclick=\"confirm('_confirm_',"+id+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' title='Eliminar'><i class='fa fa-trash'></i></a>";
        var btn_delete = " <a id='btn_delete_"+id+"' onclick=\"eliminar(" + id + ","+true+")\" class='btn btn-outline btn-primary btn-xs hide' data-toggle='tooltip' title='Confirmar'><i class='fa fa-check'></i></a> ";
        return  btn_delete + btn_confirm + btn_cancel;
    }



    else{
        var btn_confirm = " <a id='btn_confirm_"+id+"' onclick=\"confirm('_confirm_',"+id+")\" class='btn btn-outline btn-danger btn-xs' data-toggle='tooltip' title='Eliminar permanentemente'><i class='fa fa-eraser'></i></a> ";
        var btn_delete = " <a id='btn_delete_"+id+"' onclick=\"eliminar(" + id + ","+false+")\" class='btn btn-outline btn-primary btn-xs hide' data-toggle='tooltip' title='Confirmar'><i class='fa fa-check'></i></a> ";
        var btn_restore = " <a id='btn_restore_"+id+"' onclick=\"deshacerEliminar("+id+")\" class='btn btn-outline btn-primary btn-xs' data-toggle='tooltip' title='Restaurar'><i class='fa fa-refresh'></i></a> ";
        return  btn_restore + btn_delete + btn_confirm + btn_cancel;
    }
}

function confirm(btn, id){
    $("#btn"+ btn + id).removeClass('show');
    $("#btn"+ btn + id).addClass('hide');

    $("#btn_delete_"+ id).removeClass('hide');
    $("#btn_delete_"+ id).addClass('show');

    $("#btn_cancel_"+ id).removeClass('hide');
    $("#btn_cancel_"+ id).addClass('show');
}

function cancel(btn, id){
    $("#btn"+ btn + id).removeClass('show');
    $("#btn"+ btn + id).addClass('hide');

    $("#btn_delete_"+ id).removeClass('show');
    $("#btn_delete_"+ id).addClass('hide');

    $("#btn_confirm_" + id).removeClass('hide');
    $("#btn_confirm_" + id).addClass('show');
}
