$(document).ready(function(){
  $('#calendar').fullCalendar({
    lang: 'es',
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    navLinks: true, // can click day/week names to navigate views
    editable: true,
    selectable: true,
    selectHelper: true,
    events: {
            url: 'clases/profesor/44',
            error: function() 
            {
                alert("error");
            },
            success: function()
            {
                console.log("successfully loaded");
            }
    },
    dayClick: function(date, jsEvent, view){
      
      
    },
    eventClick: function(event, element) {
      
    }
  });

});