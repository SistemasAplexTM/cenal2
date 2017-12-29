<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Festivos extends Model
{
    protected $fillable = [
    	'año',
    	'dia_festivo'
    ];
}
