<?php

namespace App\Http\Controllers\Clases;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;

class GrupoController extends Controller
{
    public function index()
    {
        return view('templates..clases.grupo');
    }

    public function getAll()
    {
        $user = $this->get_user();
        $where = array(
                ['b.deleted_at', NULL]
            );
        if ($user->hasRole('Profesor')) {
            $where = array(
                ['b.profesor_id', $user->id]
            );
        }
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
                DB::raw('(SELECT Count(x.id) FROM grupo AS z INNER JOIN clases AS v ON v.grupo_id = z.id INNER JOIN clases_estudiante AS x ON x.clases_id = v.id WHERE z.id = a.id) AS cantidad'),
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
            ->where($where)
            ->get();
        return Datatables::of($data)->make(true);
    }

    public function buscar_estudiante($dato)
    {
        $data = DB::table('estudiante As a')
            ->select(
                'a.id',
                'a.consecutivo AS codigo',
                'a.grupo_id',
                'a.num_documento',
                DB::raw("concat_ws(' ', a.primer_apellido, a.segundo_apellido, a.nombres) AS nombre")
            )
            ->where([
                ['a.consecutivo', '=', $dato],
                ['a.estudiante_status_id', '=', 1],
                ['a.deleted_at', '=', null],
            ])
            ->orWhere('a.num_documento', '=', $dato)
            ->get();
        return $data;
    }

    public function agregar_estudiante($grupo_id, $estudiante_id)
    {
        $exist = DB::table('estudiante AS a')
            ->join('grupo AS b', 'a.grupo_id', 'b.id')
            ->select(
                'b.id',
                'b.nombre'
            )
            ->where('a.id', '=', $estudiante_id)
            ->get();
        $repeat = DB::table('estudiante AS a')
            ->select(
                DB::raw("count(a.id) AS cant")
            )
            ->where([
                ['a.id', '=', $estudiante_id],
                ['a.grupo_id', '=', $grupo_id],
            ])
            ->get();
        if ($repeat[0]->cant != 0) {
            $answer = array(
                'code' => 600
            );
        }elseif (count($exist) > 0) {
            $answer = array(
                'code' => 601,
                'data' => $exist
            );
        } else {
            DB::table('estudiante AS a')
                ->where('a.id', $estudiante_id)
                ->update(['a.grupo_id' => $grupo_id]);
            $answer = array('code' => 200);
        }
        return $answer;
    }

    public function estudiantes_inscritos($grupo_id)
    {
        $data = DB::table('grupo AS a')
            ->join('clases AS b', 'b.grupo_id', 'a.id')
            ->join('clases_estudiante AS c', 'c.clases_id', 'b.id')
            ->join('estudiante AS d', 'c.estudiante_id', 'd.id')
            ->select(
                'd.id',
                'd.consecutivo AS codigo',
                'd.correo',
                DB::raw("concat_ws(' ', d.primer_apellido, d.segundo_apellido, d.nombres) AS nombre")
            )
            ->where([
                ['a.id', $grupo_id]
            ])
            ->orderBy('nombre')
            ->get();

        return $data;
    }

    public function removeStudent($estudiante_id)
    {
        try {
            DB::table('estudiante AS a')
                ->where('a.id', $estudiante_id)
                ->update(['a.grupo_id' => NULL]);
            $answer = array(
                'code' => 200,
            );
            return $answer;
        } catch (Exception $e) {
            return $e;
        }
    }
}
