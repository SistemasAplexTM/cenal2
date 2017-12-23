// $('#tbl-clients').DataTable({
//     "language": {
//         "paginate": {
//             "previous": "Anterior",
//             "next": "Siguiente"
//         },
//         "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json",
//         "info": " _START_ a _END_  de _TOTAL_",
//         "search": "Buscar",
//         "lengthMenu": "Mostrar _MENU_ Registros",
//         "infoEmpty": "0 a 0 de 0 Registros",
//         "emptyTable": "No hay datos disponibles en la tabla",
//         "infoFiltered": "(Filtrando para _MAX_ Registros totales)",
//         "zeroRecords": "No se encontraron registros coincidentes",
//         "decimal": ",",
//         "thousands": "."
//     },
//     "ajax": 'oauth/clients',
//     "columns": [
//         { "data": "id" },
//         { "data": "created_at" },
//         { "data": "id" },
//         { "data": "name" },
//         { "data": "password_client" },
//         { "data": "personal_access_client" },
//         { "data": "redirect" },
//         { "data": "revoked" },
//         { "data": "secret" },
//         { "data": "updated_at" },
//         { "data": "user_id" }
//       ]
// });

var objVue = new Vue({
    el: '#clients',
    mounted: function () {
        this.getAll();
    },
    data:{
        clients: {}
    },
    methods:{
        getAll: function(){
            let me = this;
            axios.get('oauth/personal-access-tokens')
            .then(function (response){
                me.clients = response.data;
            })
            .catch(function(error){
                alert('error al consultar: ' + error);
            });
        }
    }
    
});