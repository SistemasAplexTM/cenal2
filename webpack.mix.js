let mix = require('laravel-mix');

mix.styles([
	'resources/assets/css/bootstrap.min.css',
	'resources/assets/css/animate.css',
	'resources/assets/css/style.css',
	/*-- Plugins --*/
	'resources/assets/css/plugins/datepicker/datepicker3.css',
	'resources/assets/css/plugins/dataTables/datatables.min.css',
	'resources/assets/css/plugins/iCheck/custom.css',
	'resources/assets/css/plugins/select2/select2.min.css',
	'resources/assets/css/plugins/fullcalendar/fullcalendar.css',
	'resources/assets/css/plugins/steps/jquery.steps.css',
	'resources/assets/css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css',
	// 'resources/assets/css/plugins/ladda/ladda.min.css',
	'resources/assets/css/plugins/ladda/ladda-themeless.min.css',
	'resources/assets/css/plugins/switchery/switchery.css',
	'resources/assets/css/plugins/colorpicker/bootstrap-colorpicker.min.css',
	'resources/assets/css/main.css'
	], 'public/css/plantilla.css');
mix.scripts([
	'resources/assets/js/plugins/fullcalendar/moment.min.js',
	'resources/assets/js/jquery-2.1.1.js',
	'resources/assets/js/plugins/jquery-ui.min.js',
	'resources/assets/js/bootstrap.min.js',
	/*-- Plugins --*/
	'resources/assets/js/plugins/metisMenu/jquery.metisMenu.js',
	'resources/assets/js/plugins/pace/pace.min.js',
	'resources/assets/js/plugins/slimscroll/jquery.slimscroll.min.js',
	'resources/assets/js/plugins/datepicker/bootstrap-datepicker.js',
	'resources/assets/js/plugins/dataTables/datatables.min.js',
	'resources/assets/js/plugins/iCheck/icheck.min.js',
	'resources/assets/js/plugins/select2/select2.full.min.js',
	'resources/assets/js/plugins/fullcalendar/fullcalendar.min.js',
	'resources/assets/js/locale/lang-all.js',
	'resources/assets/js/plugins/steps/jquery.steps.min.js',
	'resources/assets/js/plugins/ladda/spin.min.js',
	'resources/assets/js/plugins/ladda/ladda.min.js',
	'resources/assets/js/plugins/ladda/ladda.jquery.min.js',
	'resources/assets/js/plugins/validate/jquery.validate.min.js',
	'resources/assets/js/plugins/switchery/switchery.js',
	'resources/assets/js/plugins/colorpicker/bootstrap-colorpicker.min.js',
	/*-- Plantilla --*/
	'resources/assets/js/inspinia.js',
	'resources/assets/js/main.js',
	], 'public/js/plantilla.js');
mix.js('resources/assets/js/app.js', 'public/js')
	.sass('resources/assets/css/main.scss', 'public/css');
mix.copyDirectory('resources/assets/css/patterns', 'public/css/');
mix.copyDirectory('resources/assets/js/templates', 'public/js/');
mix.copyDirectory('resources/assets/img', 'public/img/');
mix.copyDirectory('resources/assets/font-awesome', 'public/font-awesome/');