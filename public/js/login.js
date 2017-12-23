var objVue = new Vue({
    el: '#login',
    mounted: function () {
    
    },
    data:{
        email: '',
        password: '',
        formErrors: {}
    },
    methods:{
        resetForm: function(){
            // this.email = '';
            this.password = '';
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
        login: function(){
            let me = this;
            axios.post('login', {
                'email' : this.email,
                'password' : this.password,
            })
            .then(function (response){
                if(response.data['code'] == 200){
                    location.href ="home";
                }else{
                    console.log(response.data);
                }
                me.resetForm();
            })
            .catch(function(error){
                if (error.response.status === 422) {
                    me.formErrors = error.response.data;
                }
                $.each(me.formErrors, function (key, value) {
                    $('.result-' + key).html(value);
                });
            });
        }
    }
    
});