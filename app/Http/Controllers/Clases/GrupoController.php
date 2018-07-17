<?php

namespace App\Http\Controllers\Clases;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;

class GrupoController extends Controller
{
    public function index()
    {
        return view('templates.clases.grupo');
    }

    public function getAll()
    {
        $user = $this->get_user();
        $where = array(
                ['b.deleted_at', NULL]
            );

        if (!$user->hasRole('Administrador')) {
            $where = array(
                ['f.id', $user->sede_id]
            );
        }
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
                DB::raw("'fecha_inicio'"),
                'd.jornada',
                'e.descripcion AS estado',
                'e.clase AS clase_estado',
                DB::raw('(SELECT Count(x.id) FROM grupo AS z INNER JOIN clases AS v ON v.grupo_id = z.id INNER JOIN clases_estudiante AS x ON x.clases_id = v.id WHERE z.id = a.id) AS cantidad'),
                'f.nombre AS sede'
            )
            ->groupBy(
                'a.id',
                'a.nombre',
                'd.jornada',
                'd.jornada',
                'f.nombre',
                'e.descripcion',
                'e.clase'
            )
            ->where($where)
            ->get();
        return Datatables::of($data)->make(true);
    }

    public function buscar_estudiante($clase_id, $dato)
    {
        $data = DB::table('estudiante As a')
            ->select(
                'a.id',
                'a.consecutivo AS codigo',
                'a.num_documento',
                DB::raw("concat_ws(' ', a.primer_apellido, a.segundo_apellido, a.nombres) AS nombre"),
                DB::raw("(SELECT Count(z.id) FROM clases_estudiante AS z WHERE z.clases_id = ".$clase_id." AND z.estudiante_id = a.id) AS cantidad")
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

    public function agregar_estudiante($clase_id, $estudiante_id)
    {
        
        DB::table('clases_estudiante')->insert([
            ['estudiante_id' => $estudiante_id, 'clases_id' => $clase_id]
        ]);
        return array('code' => 200);
    }

    public function validar_limite_agregar_estudiante($clase_id)
    {
        $data = DB::table('clases As a')
        ->select(
            'a.fecha_inicio'
        )
        ->where('a.id', $clase_id)
        ->first();

        $fecha = new \DateTime($data->fecha_inicio);
        $fecha = $fecha->add(new \DateInterval('P14D'));
        $fecha_limite = $fecha->format('Y-m-d'); 
        $fecha_actual = date('Y-m-d'); 
        if ($fecha_actual <= $fecha_limite) {
            $result = true;
        }else{
            $result = false;
        }
        return array('result' => $result);
    }

    public function get_estado_clase($clase_id)
    {
        $data = DB::table('clases As a')
        ->join('estado As b', 'a.estado_id', 'b.id')
        ->select(
            'a.estado_id',
            'b.descripcion',
            'b.clase',
            DB::raw('(select count(estado_id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id and`g`.`estado_id` = 3)) AS completadas'),
            DB::raw('(select count(id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id )) AS total')
        )
        ->where('a.id', $clase_id)
        ->first();
        $porcentaje = $data->completadas / $data->total * 100;

        if ($data->estado_id != 3) {
            if ($data->completadas == $data->total) {
                DB::table('clases')
                    ->where('id', '=', $clase_id)
                    ->update(
                        ['estado_id' => 3]
                    );
            }
            if ($data->completadas > 0 && $data->completadas < $data->total) {
                DB::table('clases')
                    ->where('id', '=', $clase_id)
                    ->update(
                        ['estado_id' => 2]
                    );
            }
        }

        return array('code' => 200, 'data' => $data, 'porcentaje' => $porcentaje);
    }

    public function estudiantes_inscritos($clases_id)
    {
        $data = DB::table('clases_estudiante AS a')
            ->join('estudiante AS b', 'a.estudiante_id', 'b.id')
            ->join('programas AS c', 'b.programas_id', 'c.id')
            ->select(
                'a.aprobado',
                'b.id',
                'b.consecutivo AS codigo',
                'b.correo',
                DB::raw("concat_ws(' ', b.primer_apellido, b.segundo_apellido, b.nombres) AS nombre"),
                'c.programa'
            )
            ->where([
                ['a.clases_id', $clases_id]
            ])
            ->orderBy('nombre')
            ->get();

        return $data;
    }
    
    public function estudiantes_reprobados($clases_id)
    {
        $data = DB::table('clases_estudiante AS a')
            ->join('estudiante AS b', 'a.estudiante_id', 'b.id')
            ->select(
                'b.id',
                'b.consecutivo AS codigo',
                'b.correo',
                DB::raw("concat_ws(' ', b.primer_apellido, b.segundo_apellido, b.nombres) AS nombre")
            )
            ->where([
                ['a.aprobado', 1],
                ['a.clases_id', $clases_id]
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

    public function getModulosByGrupo($grupo_id){
        try {
            $data = DB::table('grupo AS a')
                ->select('a.orden_modulos', 'a.dias_clase')
                ->where('a.id', $grupo_id)
                ->first();
            $programados = DB::table('clases AS a')
                ->select('a.modulo_id')
                ->where([
                    ['a.grupo_id', $grupo_id],
                    ['a.ciclo', DB::raw('(SELECT z.ciclo FROM grupo AS z WHERE z.id = '.$grupo_id.')')]
                ])
                ->get();
            $dias_clase = explode(',', $data->dias_clase);
            $orden = explode(',', $data->orden_modulos);
            $result = array();
            foreach ($orden as $key => $value) {
                $result[] = DB::table('modulos AS a')
                ->leftJoin('pivot_promarma_modulos_jornada AS b', 'a.id', 'b.modulo_id')
                ->select('a.id', 'a.nombre', 'b.duracion')
                ->where('a.id', $value)
                ->first();
            }
            foreach ($programados as $key => $value) {
                $program[] = $value->modulo_id;
            }
            foreach ($result as $key => $value) {
                $result_ids[] = $value->id;
            }
            
            // $diff = array_diff($result_ids, $program );

            $answer = array(
                'code' => 200,
                'data' => $result,
                'terminados' => $program,
                'dias_clase' => $dias_clase
            );
            return $answer;
        } catch (Exception $e) {
            return $e;
        }    
    }

    public function getAllCiclos($grupo)
    {
        $data = DB::table('clases AS a')
            ->select('a.ciclo')
            ->where('a.grupo_id', $grupo)
            ->groupBy('a.ciclo')
            ->get();
        $actual = DB::table('grupo AS a')
            ->select('a.ciclo')
            ->where('a.id', $grupo)
            ->first();
        return array('code' => 200, 'data' => $data, 'actual' => $actual->ciclo);
    }
}
