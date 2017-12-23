<?php

Route::get('/', 'Auth\LoginController@index');


Auth::routes();

Route::get('/error/{code}','ErrorController@index');

Route::group(['middleware' => 'auth'],function(){
	Route::get('/mora','MoraController@index')->name('mora');
	Route::get('/baloto', 'MoraController@baloto')->name('baloto');
	Route::get('/home', 'ModuloController@index')->name('home');
	Route::get('/clients', 'Api\ClientsController@index')->name('clients');
	Route::get('/clients/getAll', 'Api\ClientsController@getAll');
	Route::get('/modulo', 'ModuloController@index')->name('modulo');
	Route::get('/modulo/all', 'ModuloController@getAll');
	Route::post('/modulo/store', 'ModuloController@store');
});
/*-- Rutas para el estudiante --*/
Route::group(['middleware' => ['auth', 'mora']], function(){
	Route::get('/estudiante/perfil/pagado', 'Estudiante\PerfilController@pagado');
	Route::get('/estudiante/perfil/pendiente', 'Estudiante\PerfilController@pendiente');
	Route::get('/estudiante/perfil', 'Estudiante\PerfilController@index');
	Route::post('/estudiante/perfil/update/{id}', 'Estudiante\PerfilController@update');
});
/*-- Rutas para el profesor --*/
Route::group(['middleware' => ['auth', 'teacher']], function(){
	Route::get('/profesor/perfil', 'Profesor\PerfilController@index');
	Route::get('/profesor/clases', 'Profesor\ClasesController@index');
});
