$(function() {
    $('#tbl-finanzas').DataTable();
    
    $('#data_1 .input-group.date').datepicker({
        language: 'es',
        todayBtn: "linked",
        calendarWeeks: true,
        autoclose: true,
    });
});

var objVue = new Vue({
    el: '#perfil',
    data:{
        modulo_actual: '',
        modulos: [],
        asistencia: []
    },
    created(){
        this.get_modulos(estudiante_id);
    },
    methods:{
        get_modulos: function(estudiante_id){
            axios.get('modulosByEstudiente/' + estudiante_id).then(response => { 
                this.modulos = response.data;
            });
        },
        get_asistencia: function(modulo_id, modulo_nombre){
            this.modulo_actual = modulo_nombre;
            axios.get('asistencia/'+estudiante_id+'/'+modulo_id).then(response => { 
                this.asistencia = response.data;
            });
        }
    }
    
});

/*SELECT
DATE_FORMAT(a.`start`, '%Y-%m-%d') AS fecha,
IFNULL(
		(
			SELECT
				a.id
			FROM
				clases_estudiante_asistencia AS a
			LEFT OUTER JOIN clases_detalle AS b ON a.clases_detalle_id = b.id
			LEFT OUTER JOIN clases AS c ON b.clases_id = c.id
			WHERE
				a.estudiante_id = 754
			AND c.modulo_id = 2
			AND b.`start` = a.`start`
		),
		0
	) AS asistencia
FROM
clases_detalle AS a
INNER JOIN clases AS b ON a.clases_id = b.id
INNER JOIN clases_estudiante AS c ON c.clases_id = b.id
WHERE
b.modulo_id = 2 AND
c.estudiante_id = 754*/