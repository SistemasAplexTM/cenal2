<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Programas extends Model
{
	public $timestamps = false;
	protected $table = 'pivot_promarma_modulos_jornada';
    protected $fillable = [
    	'programa_id', 
    	'modulo_id',
    	'jornada_id',
    	'duracion'
    ];
}
