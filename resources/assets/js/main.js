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

 /*-- Función para recargar datatables --*/
function recargarTabla(tabla){
    $('#' + tabla).dataTable()._fnAjaxUpdate();
};

/* initialize the calendar
 -----------------------------------------------------------------*/
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();

$('#calendar').fullCalendar({
    header: {
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
    },
    events: [
        {
            title: 'Clase 01',
            start: new Date(y, m, 1)
        },
        {
            title: 'Clase 02',
            start: new Date(y, m, d-5),
            end: new Date(y, m, d-2)
        },
        {
            id: 999,
            title: 'Clase 03',
            start: new Date(y, m, d-3, 16, 0),
            allDay: false
        },
        {
            id: 999,
            title: 'Clase 04',
            start: new Date(y, m, d+4, 16, 0),
            allDay: false
        },
        {
            title: 'Clase 05',
            start: new Date(y, m, d, 10, 30),
            allDay: false
        },
        {
            title: 'Clase 06',
            start: new Date(y, m, d, 12, 0),
            end: new Date(y, m, d, 14, 0),
            allDay: false
        },
        {
            title: 'Clase 07',
            start: new Date(y, m, d+1, 19, 0),
            end: new Date(y, m, d+1, 22, 30),
            allDay: false
        },
        {
            title: 'Click for Google',
            start: new Date(y, m, 28),
            end: new Date(y, m, 29),
            url: 'http://google.com/'
        }
    ]
});