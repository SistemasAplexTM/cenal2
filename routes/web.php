<?php

Route::get('/', 'Auth\LoginController@index');

Route::post('validar', 'Auth\ValidarController@validar')->name('validar');
Route::post('validar/register', 'Auth\ValidarController@register2');
Route::get('/register/verify/{code}', 'Auth\ValidarController@verify');
Auth::routes();
Route::get('/change_password', 'Auth\ValidarController@change_password');
Route::post('/change_password', 'Auth\ValidarController@update_password');

Route::get('/error/{code}','ErrorController@index');


Route::group(['middleware' => ['auth', 'VerifyifActive', 'ChangePassword']],function(){
	Route::get('/home', 'HomeController@index')->name('home');
	Route::get('/mora','MoraController@index')->name('mora');
	Route::get('/baloto', 'MoraController@baloto')->name('baloto');
	Route::get('/clients', 'Api\ClientsController@index')->name('clients');
	Route::get('/clients/getAll', 'Api\ClientsController@getAll');
	
	Route::get('/sede/all', 'SalonController@getAllSede');

	Route::put('/modulo/updateCell', 'ModuloController@updateCell');
	Route::get('/modulo/getAllForSelect', 'ModuloController@getAllForSelect');
	Route::get('/modulo/getByPrograma/{programa}', 'ModuloController@getByPrograma');
	Route::get('/modulo', 'ModuloController@index')->name('modulo');
	Route::get('/modulo/all/{type}', 'ModuloController@getAll');
	Route::post('/modulo/store', 'ModuloController@store');
	Route::put('/modulo/{id}', 'ModuloController@update');
	Route::get('modulo/restaurar/{id}' , 'ModuloController@restaurar');
	Route::get('modulo/delete/{id}/{logical?}', 'ModuloController@delete');

	Route::put('user/change_state', 'UserController@change_state');
	Route::get('user/getRolesForSelect2', 'UserController@getRolesForSelect2');
	Route::get('user/all', 'UserController@getAll');
	Route::get('user/restaurar/{id}' , 'UserController@restaurar');
	Route::get('user/delete/{id}/{logical?}', 'UserController@delete');
	Route::resource('user', 'UserController');

	Route::get('salon/getBySede/{sede}', 'SalonController@getBySede');
	Route::get('salon/getUbicacion/{id}', 'SalonController@getUbicacion');
	Route::get('salon/all', 'SalonController@getAll');
	Route::get('salon/restaurar/{id}' , 'SalonController@restaurar');
	Route::get('salon/delete/{id}/{logical?}', 'SalonController@delete');
	Route::resource('salon', 'SalonController');

	Route::get('ubicacion/getForSelect2', 'UbicacionController@getForSelect2');
	Route::get('ubicacion/all', 'UbicacionController@getAll');
	Route::get('ubicacion/restaurar/{id}' , 'UbicacionController@restaurar');
	Route::get('ubicacion/delete/{id}/{logical?}', 'UbicacionController@delete');
	Route::resource('ubicacion', 'UbicacionController');

	Route::get('festivos/all', 'FestivosController@getAll');
	Route::get('festivos/restaurar/{id}' , 'FestivosController@restaurar');
	Route::get('festivos/delete/{id}/{logical?}', 'FestivosController@delete');
	Route::resource('festivos', 'FestivosController');

	Route::get('getAllSedesForSelect', 'ProgramasController@getAllSedesForSelect');

	Route::get('programas/getAllProgramasBySede/{sede}', 'ProgramasController@geAllBySede');
	Route::post('programas/add_modules/{id}', 'ProgramasController@addModules');
	Route::get('programas/getDataModulosByPrograma/{id_programa}', 'ProgramasController@getDataModulosByPrograma');
	Route::get('programas/all', 'ProgramasController@getAll');
	Route::get('programas/restaurar/{id}' , 'ProgramasController@restaurar');
	Route::get('programas/delete/{id}/{logical?}', 'ProgramasController@delete');
	Route::resource('programas', 'ProgramasController');
	/*-- Grupos --*/
	Route::get('grupos/all', 'Clases\GrupoController@getAll');
	Route::get('grupos', 'Clases\GrupoController@index');

	Route::get('clases/profesor/{profesor_id}', 'Profesor\ClasesController@getAll');

	Route::post('changeSalon', 'Clases\ClasesController@changeSalon');
	Route::post('clases/validarSalon', 'Clases\ClasesController@validarSalon');
	Route::get('clases/{clase_id}/getAll_estudiantes_asistencia/{clases_detalle_id}', 'Clases\ClasesController@getAll_estudiantes_asistencia');
	Route::get('clases/{clase_id}/get_estudiante_asistencia', 'Clases\ClasesController@get_estudiante_asistencia');
	Route::post('clases/{clase_id}/set_estudiante_asistencia', 'Clases\ClasesController@set_estudiante_asistencia');
	Route::get('clases/{clase_id}/profesor_asignado', 'Clases\ClasesController@profesor_asignado');
	Route::get('clases/{clase_id}/estudiantes_inscritos', 'Clases\ClasesController@estudiantes_inscritos');
	Route::get('clases/buscar_estudiante/{dato}', 'Clases\ClasesController@buscar_estudiante');
	Route::get('clases/{clase_id}/asignar_profesor/{profesor_id}', 'Clases\ClasesController@asignar_profesor');
	Route::get('clases/{clase_id}/buscar_profesor/{dato}', 'Clases\ClasesController@buscar_profesor');
	Route::get('clases/getFin/{id_clase}', 'Clases\ClasesController@getFin');
	Route::get('clases/day', 'Clases\ClasesController@programarClases');
	// Route::get('clases/{clase_id}', 'Clases\ClasesController@getAll');
	Route::get('clases/{grupo}/grupo', 'Clases\ClasesController@index');
	Route::get('clases/{grupo}/all', 'Clases\ClasesController@getAll');
	Route::get('clases/restaurar/{id}' , 'Clases\ClasesController@restaurar');
	Route::get('clases/delete/{id}/{logical?}', 'Clases\ClasesController@delete');
	Route::resource('clases', 'Clases\ClasesController');
});
	Route::get('clases/{clase_id}/agregar_estudiante/{estudiante_id}', 'Clases\ClasesController@agregar_estudiante');
	Route::get('clases/{clase_id}/retirar_estudiante/{estudiante_id}', 'Clases\ClasesController@removeStudentClass');
/*-- Rutas para el estudiante --*/
Route::group(['middleware' => ['auth', 'mora', 'VerifyifActive']], function(){
	Route::get('/estudiante/asistencia/{estudiante_id}/{modulo_id}', 'Estudiante\PerfilController@asistenciaEstudiente');
	Route::get('/estudiante/modulosByEstudiente/{estudiante_id}', 'Estudiante\PerfilController@getModulosByEstudiente');
	Route::get('/estudiante/perfil/pagado', 'Estudiante\PerfilController@pagado');
	Route::get('/estudiante/perfil/pendiente', 'Estudiante\PerfilController@pendiente');
	Route::get('/estudiante/perfil', 'Estudiante\PerfilController@index');
	Route::post('/estudiante/perfil/update/{id}', 'Estudiante\PerfilController@update');
});
