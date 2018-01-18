$(function() {
    $('#tbl-finanzas').DataTable();
    
    $('#data_1 .input-group.date').datepicker({
        language: 'es',
        todayBtn: "linked",
        calendarWeeks: true,
        autoclose: true,
    });
});