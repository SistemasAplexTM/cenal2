const objVue = new Vue({
    el: '#asistencia',
    data:{
        clases: {},
        asistencia: {},
        estudiantes_inscritos: {}
    },
    created(){
        this.get_clases();
        this.get_estudiantes_inscritos();
        this.getAllAsistencia(421);
    },
    methods:{
        getAllAsistencia: function(){
            axios.get('allAsistencia').then(response => {
                if (response.data.length > 0) {
                    this.asistencia = response.data;   
                }
            });
        },
        get_estudiantes_inscritos: function(){
            axios.get('estudiantes_inscritos').then(response => {
                this.estudiantes_inscritos = response.data;   
            });
        },
        get_clases: function(){
            axios.get('./').then(response => {
                this.clases = response.data; 
            });
        },
        verificar_asistencia: function(clase_detalle_id, estudiante_id){
            var result = false;
            var asistencia = this.asistencia;
            asistencia.forEach( function(valor, indice, array) {
                if (valor.estudiante_id == estudiante_id && valor.clases_detalle_id == clase_detalle_id) {
                    result = true;
                }
            });
            return result;
        },
        formato_fecha: function(fecha){
            return formato_fecha(fecha);
        }
    }
    
});