<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Estudiante extends Model
{
    protected $table = 'estudiante';
    protected $hidden = 'id';
    protected $fillable = [
        'nombres', 
        'primer_apellido', 
        'segundo_apellido', 
        'direccion',
        'tel_fijo',
        'tel_movil',
        'genero_id',
        'num_documento',
        'num_libreta',
        'ciudad_domicilio',
        'barrio_domicilio',
        'correo',
        'expedicion_documento',
        'consecutivo',
        'nivel_academico_id',
        'institucion',
        'fecha_nacimiento',
        'estado_civil_id',
        'ocupacion',
    ];
}
