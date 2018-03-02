$(document).ready(function () {
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