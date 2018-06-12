$(document).ready(function () {

    $('#data_1 .input-group.date').datepicker({
        language: 'es',
        todayBtn: "linked",
        calendarWeeks: true,
        autoclose: true,
    });

    // $("#jornada").on('change', function(){
    //     objVue.setInicioJornada();
    // });

    $("#salon").on('change', function(){
        objVue.setCapacidad();
    });
});

var objVue = new Vue({
    el: '#clases',
    data:{
        grupo:'',
        salon:'',
        color:'',
        programa: '',
        capacidad:'',
        ubicacion:'',
        duracion:'',
        jornada:'',
        hora_inicio_jornada: '',
        hora_fin_jornada: '',
        fecha_inicio: '',
        sede: user.sede_id,
        modulo:null,
        errorSalon:false,
        programas: [],
        modulos: [],
        salones: [],
        semana: [],
        fechasError: [],
        cargando: 0,
        cargandoModulos: 0,
        formErrors: {},
        list:[
                {name:"John"}, 
                {name:"Joao"}, 
                {name:"Jean"} 
            ]
    },
    created(){
        this.setProgramas();
        this.setSalones();
    },
    methods:{
        resetForm: function(){
            this.errorSalon = false;
            this.fechasError = [];
            this.grupo = '',
            this.salon = null,
            this.color = '',
            this.programa =  null,
            this.capacidad = '',
            this.ubicacion = '',
            this.duracion = '',
            this.jornada = '',
            this.hora_inicio_jornada = '',
            this.hora_fin_jornada = '',
            this.fecha_inicio = $("#fecha_inicio").val(''),
            this.modulo = null,
            this.modulos = [],
            this.semana = [],
            this.fechasError = [],
            this.$validator.reset();
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
        setCapacidad: function(val){
            this.capacidad = '';
            this.ubicacion = '';
            if (val) {
                this.salon = val.id;
                this.capacidad = val.capacidad;
                this.ubicacion = val.ubicacion;
            }
        },
        // setDuracion: function(val){
        //     $("#modulo_id").val('');
        //     if (val != null) {
        //         $("#modulo_id").val(val.id);
        //         this.duracion = val.duracion;
        //     }
        // },
        setProgramas: function(){
            this.resetForm();
            // if (this.sede.length > 0) {
                this.cargando = 1;
                axios.get('../programas/getAllProgramasBySede/' + this.sede).then(response => {
                    this.programas = response.data;
                    this.cargando = 0;
                });
            // }else{
            //     this.programas = [];
            // }
        },
        setModulos: function(val){
            // alert(val);
            this.duracion = '';
            if (val != null) {
                this.cargandoModulos = 1;
                axios.get('../modulo/getByPrograma/' + val.id + '/' + this.jornada).then(response => {
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
            // if (this.sede.length > 0) {
                this.cargando = 1;
                axios.get('../salon/getBySede/' + this.sede).then(response => {
                    this.salones = response.data;
                    this.cargando = 0;
                });
            // }else{
                // this.salones = [];
            // }
        },
        setInicioJornada: function(){
            this.setModulos();
            var inicio = $("#jornada").find(':selected').data("hora_inicio");
            var fin = $("#jornada").find(':selected').data("hora_fin");
            this.hora_inicio_jornada = moment(inicio, "HH:mm:ss").format('HH:mm');
            this.hora_fin_jornada = moment(fin, "HH:mm:ss").format('HH:mm');
        },
        save: function(){
            this.$validator.validateAll().then((result) => {
                if (result) {
                    let me = this;
                    axios.post('../clases', {
                        'grupo': this.grupo,
                        'salon': this.salon,
                        'color': this.color,
                        'jornada_id': this.jornada_id,
                        'duracion': this.duracion,
                        'jornada': this.jornada,
                        'sede': this.sede,
                        'modulos': this.modulos,
                        'salones': this.salones,
                        'semana': this.semana,
                        'hora_inicio_jornada': this.hora_inicio_jornada,
                        'hora_fin_jornada': this.hora_fin_jornada,
                        'fecha_inicio': $("#fecha_inicio").val(),
                    }).then(response => {
                        if (response.data.code == 200) {
                            toastr.success('Registrado con éxito');
                            this.resetForm();
                            location.reload();
                        }else{
                            this.errorSalon = response.data.errorSalon;
                            this.fechasError = response.data.fechas;
                        }
                    })
                    .catch(function(error){
                        alert('Error al consultar: ' + error);
                    });
                }
            }).catch(function(error) {
                notifyMesagge('bg-red', 'Error: ' + error);
            });
        }
    }
    
});