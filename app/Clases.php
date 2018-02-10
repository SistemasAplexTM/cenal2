<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Clases extends Model
{
    protected $fillable = ['modulo_id','fecha_inicio', 'salon_id', 'sede_id','jornada_id','observacion','estado_id', 'ids_estudiantes'];
}
