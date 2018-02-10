$(document).ready(function(){
  $('#calendar').fullCalendar({
    locale: 'es',
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    navLinks: true, // can click day/week names to navigate views
    editable: true,
    selectable: true,
    selectHelper: true,
    events: 'clases/all',
    dayClick: function(date, jsEvent, view){
      
      
    },
    eventClick: function(event, element) {
      
    }
  });

});