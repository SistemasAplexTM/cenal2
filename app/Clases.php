<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Clases extends Model
{
    protected $fillable = ['modulo','fecha', 'inicio', 'salon', 'padre', 'sede_id', 'ids_estudiantes'];
}
