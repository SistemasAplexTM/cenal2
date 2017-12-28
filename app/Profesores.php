<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Profesores extends Model
{
    protected $fillable = [
    	'nombre',
    	'apellidos',
    	'telefono',
    	'correo',
    	'celular',
    	'direccion',
    	'user_id',
    ];
}
