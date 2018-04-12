<?php

namespace App\Http\Controllers\Clases;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;

class GrupoController extends Controller
{
    public function index(){
    	return view('templates..clases.grupo');
    }

    public function getAll()
    {
        $user = $this->get_user();
        $data = DB::table('grupo As a')
            ->join('clases AS b', 'b.grupo_id', 'a.id')
            ->leftJoin('jornadas AS d', 'b.jornada_id', 'd.id')
            ->leftJoin('estado AS e', 'a.estado_id', 'e.id')
            ->join('sede AS f', 'b.sede_id', 'f.id')
            ->select(
                'a.id',
                'a.nombre',
                DB::raw('DATE_FORMAT(b.fecha_inicio, "%Y-%m-%d") fecha_inicio'),
				'd.jornada',
				'e.descripcion AS estado',
                'e.clase AS clase_estado',
                DB::raw('IFNULL(( SELECT Count(b.id) FROM grupo AS e INNER JOIN estudiante AS f ON f.grupo_id = e.id WHERE f.grupo_id = a.id ),0) AS cantidad'),
                'f.nombre AS sede'
            )
            ->groupBy(
            	'a.id',
				'a.nombre',
				'b.fecha_inicio',
				'd.jornada',
				'd.jornada',
				'f.nombre'
            )
            ->get();
        return Datatables::of($data)->make(true);
    }
}
