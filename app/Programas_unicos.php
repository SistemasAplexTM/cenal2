<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Programas_unicos extends Model
{
    protected $fillable = [
    	'nombre', 'modulos_json'
    ];
}
