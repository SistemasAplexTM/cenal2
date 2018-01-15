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

	Route::get('/modulo', 'ModuloController@index')->name('modulo');
	Route::get('/modulo/all', 'ModuloController@getAll');
	Route::post('/modulo/store', 'ModuloController@store');
	Route::put('/modulo/{id}', 'ModuloController@update');
	Route::get('modulo/restaurar/{id}' , 'ModuloController@restaurar');
	Route::get('modulo/delete/{id}/{logical?}', 'ModuloController@delete');

	Route::get('profesor/all', 'Profesor\ProfesorController@getAll');
	Route::get('profesor/getDataUser/{user}', 'Profesor\ProfesorController@getDataUser');
	Route::get('profesor/restaurar/{id}' , 'Profesor\ProfesorController@restaurar');
	Route::get('profesor/delete/{id}/{logical?}', 'Profesor\ProfesorController@delete');
	Route::resource('profesor', 'Profesor\ProfesorController');

	Route::get('salon/all', 'SalonController@getAll');
	Route::get('salon/restaurar/{id}' , 'SalonController@restaurar');
	Route::get('salon/delete/{id}/{logical?}', 'SalonController@delete');
	Route::resource('salon', 'SalonController');

	Route::get('ubicacion/all', 'UbicacionController@getAll');
	Route::get('ubicacion/restaurar/{id}' , 'UbicacionController@restaurar');
	Route::get('ubicacion/delete/{id}/{logical?}', 'UbicacionController@delete');
	Route::resource('ubicacion', 'UbicacionController');

	Route::get('festivos/all', 'FestivosController@getAll');
	Route::get('festivos/restaurar/{id}' , 'FestivosController@restaurar');
	Route::get('festivos/delete/{id}/{logical?}', 'FestivosController@delete');
	Route::resource('festivos', 'FestivosController');
});
/*-- Rutas para el estudiante --*/
Route::group(['middleware' => ['auth', 'mora', 'VerifyifActive']], function(){
	Route::get('/estudiante/perfil/pagado', 'Estudiante\PerfilController@pagado');
	Route::get('/estudiante/perfil/pendiente', 'Estudiante\PerfilController@pendiente');
	Route::get('/estudiante/perfil', 'Estudiante\PerfilController@index');
	Route::post('/estudiante/perfil/update/{id}', 'Estudiante\PerfilController@update');
});
/*-- Rutas para el profesor --*/
Route::group(['middleware' => ['auth', 'teacher', 'VerifyifActive']], function(){
	Route::get('/profesor/perfil', 'Profesor\PerfilController@index');
	Route::get('/profesor/clases', 'Profesor\ClasesController@index');
});
