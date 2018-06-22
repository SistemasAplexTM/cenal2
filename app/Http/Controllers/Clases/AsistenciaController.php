<?php

namespace App\Http\Controllers\Clases;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;

class AsistenciaController extends Controller
{
    public function index($clases_id)
    {
    	// $this->info_user();
        $data = DB::table('clases As a')
            ->join('modulos AS c', 'a.modulo_id', 'c.id')
            ->join('jornadas AS d', 'a.jornada_id', 'd.id')
            ->join('estado AS e', 'a.estado_id', 'e.id')
            ->join('sede AS f', 'a.sede_id', 'f.id')
            ->leftJoin('users AS g', 'a.profesor_id', 'g.id')
            ->select(
                'a.id',
                DB::raw('(select min(start) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id)) AS fecha_inicio'),
                DB::raw('(select max(start) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id)) AS fecha_fin'),
                DB::raw('(select count(estado_id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id and`g`.`estado_id` = 3)) AS completadas'),
                DB::raw('(select count(id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id )) AS total'),
                DB::raw('(SELECT GROUP_CONCAT(DISTINCT s.codigo,"    /    ", s.capacidad SEPARATOR ", ") AS salon FROM clases_detalle AS j INNER JOIN salones AS s ON j.salon_id = s.id WHERE j.clases_id = a.id ) AS salon'),
                'a.observacion',
                'a.estado_id',
                'a.cant_estudiantes',
                'c.nombre AS modulo',
                'd.jornada AS jornada',
                'd.hora_inicio AS inicio_jornada',
                'd.hora_fin AS fin_jornada',
                'd.jornada AS jornada',
                'e.descripcion AS estado',
                'e.clase AS clase_estado',
                'f.nombre AS sede',
                'a.profesor_id',
                'g.img AS perfil_profesor',
                DB::raw("concat_ws(' ', g.name,g.last_name) AS profesor")
            )
            ->where([
                ['a.deleted_at', '=', null],
                ['a.id', '=', $clases_id],
            ])
            ->get();
        $data       = $data[0];
        $porcentaje = $data->completadas / $data->total * 100;

        return view('templates.clases.asistencia', compact('data', 'porcentaje'));
    }

    public function getAll($clase_id)
    {
    	$data = DB::table('clases_estudiante_asistencia AS a')
    	->join('clases_detalle AS b', 'a.clases_detalle_id', 'b.id')
    	->select('a.estudiante_id', 'a.clases_detalle_id')
    	->where('b.clases_id', $clase_id)
    	->get();
        return $data;
    }
}