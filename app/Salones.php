<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Salones extends Model
{
    protected $fillable = [
    	'sede_id',
    	'codigo',
    	'capacidad',
    	'ubicacion'
    ];
    protected $casts = [
		'ubicacion' => 'array'
  	];
}
