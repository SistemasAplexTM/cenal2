$(document).ready(function () {

    $('#data_1 .input-group.date').datepicker({
        language: 'es',
        todayBtn: "linked",
        calendarWeeks: true,
        autoclose: true,
    });

    $("#jornada").on('change', function(){
        objVue.setHorasJornada();
    });

    $("#salon").on('change', function(){
        objVue.setCapacidad();
    });
});

var objVue = new Vue({
    el: '#clases',
    data:{
        salon:'',
        programa: '',
        capacidad:'',
        ubicacion:'',
        duracion:'',
        jornada:'',
        sede:'',
        modulo_id:null,
        errorSalon:false,
        programas: [],
        modulos: [],
        salones: [],
        semana: [],
        fechasError: [],
        hora_inicio_jornada: '',
        hora_fin_jornada: '',
        fecha_inicio: '',
        cargando: 0,
        cargandoModulos: 0,
        formErrors: {}
    },
    methods:{
        resetForm: function(){
            this.duracion = '';
            this.capacidad = '';
            this.ubicacion = '';
            this.salones = [];
            this.modulos = [];
        },
        /* metodo para eliminar el error de los campos del formulario cuando dan clic sobre el */
        deleteError: function(element){
            let me = this;
            $.each(me.formErrors, function (key, value) {
                if(key !== element){
                   me.formErrors[key] = value; 
               }else{
                me.formErrors[key] = false; 
               }
            });
        },
        setCapacidad: function(){
            this.capacidad = $("#salon_id").find(':selected').data('capacidad');
            this.ubicacion = $("#salon_id").find(':selected').data('ubicacion');
        },
        setDuracion: function(val){
            $("#modulo_id").val('');
            if (val != null) {
                $("#modulo_id").val(val.id);
                this.duracion = val.duracion;
            }
        },
        setProgramas: function(){
            this.resetForm();
            if (this.sede.length > 0) {
                this.cargando = 1;
                axios.get('../programas/getAllProgramasBySede/' + this.sede).then(response => {
                    this.programas = response.data;
                    this.cargando = 0;
                });
            }else{
                this.programas = [];
            }
        },
        setModulos: function(val){
            this.duracion = '';
            if (val != null) {
                this.cargandoModulos = 1;
                axios.get('../modulo/getByPrograma/' + val.id).then(response => {
                    if(response.data.length > 0){
                        this.modulos = response.data 
                    }else{
                        this.modulos = [];
                    }
                    this.cargandoModulos = 0;
                });
            }else{
                this.modulos = [];
            }
        },
        setSalones: function(){
            if (this.sede.length > 0) {
                this.cargando = 1;
                axios.get('../salon/getBySede/' + this.sede).then(response => {
                    this.salones = response.data;
                    this.cargando = 0;
                });
            }else{
                this.salones = [];
            }
        },
        setInicioJornada: function(){
            var inicio = $("#jornada_id").find(':selected').data("hora_inicio");
            var fin = $("#jornada_id").find(':selected').data("hora_fin");
            this.hora_inicio_jornada = moment(inicio, "HH:mm:ss").format('HH:mm');
            this.hora_fin_jornada = moment(fin, "HH:mm:ss").format('HH:mm');
        },
        save: function(){
            var formData = new FormData($('#create_clase_form')[0]);
            console.log(new FormData($('#create_clase_form')[0]));
            const config = { headers: { 'Content-Type': 'multipart/form-data' } };
            axios.post('validarSalon', formData, config).then(response => {
                this.errorSalon = response.data.errorSalon;
                this.fechasError = response.data.fechas;
                if (!this.errorSalon) {
                    this.$refs.form.submit();
                }
            });
        }
    }
    
});