<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Clases extends Model
{
	public $timestamps = true;
    protected $fillable = ['modulo_id','fecha_inicio', 'sede_id','jornada_id','observacion','estado_id', 'grupo_id'];
}
