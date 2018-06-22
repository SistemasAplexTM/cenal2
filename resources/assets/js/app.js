
/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

require('./bootstrap');


window.Vue = require('vue');

window.swal = require('sweetalert2');

window.toastr = require('toastr');
// window.SweetModal = require('sweet-modal');

// import SweetModal from 'sweet-modal-vue/plugin.js'
// Vue.use(SweetModal)
import vSelect from 'vue-select'
Vue.component('v-select', vSelect)

import draggable from 'vuedraggable';
Vue.component('draggable', draggable)

import VTooltip from 'v-tooltip';
Vue.use(VTooltip);

// import vueConfirmationButton from 'vue-confirmation-button';
// Vue.component('vue-confirmation-button', vueConfirmationButton);

/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

Vue.component('confirm-button', require('./components/Confirm_button.vue'));
Vue.component('example', require('./components/Example.vue'));

Vue.component(
	'passport-clients',
	require('./components/passport/Clients.vue')	
);
Vue.component(
	'passport-authorized-clients',
	require('./components/passport/AuthorizedClients.vue')	
);
Vue.component(
	'passport-personal-access-tokens',
	require('./components/passport/PersonalAccessTokens.vue')	
);

// const app = new Vue({
//     el: '#app'
// });
