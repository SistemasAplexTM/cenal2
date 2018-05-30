<?php

namespace App\Http\Controllers\Clases;

use App\Clases;
use App\Http\Controllers\Controller;
use App\Modulos;
use App\Salones;
use DateInterval;
use DateTime;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;
use Session;
use Javascript;

class ClasesController extends Controller
{
    private $hoy;
    private $festivos;
    private $ano;
    private $pascua_mes;
    private $pascua_dia;

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($grupo)
    {   
        $this->info_user();
        Javascript::put([
            'grupo_id' => $grupo
        ]);
        $data = DB::table('grupo As a')
        ->join('clases AS b', 'b.grupo_id', 'a.id')
        ->leftJoin('jornadas AS d', 'b.jornada_id', 'd.id')
        ->leftJoin('estado AS e', 'a.estado_id', 'e.id')
        ->join('sede AS f', 'b.sede_id', 'f.id')
        ->select(
            'a.id',
            'a.nombre',
            'd.jornada',
            'e.descripcion AS estado',
            'e.clase AS clase_estado',
            DB::raw('(SELECT Count(x.id) FROM grupo AS z INNER JOIN clases AS v ON v.grupo_id = z.id INNER JOIN clases_estudiante AS x ON x.clases_id = v.id WHERE z.id = a.id) AS cantidad'),    
            'f.nombre AS sede'
        )
        ->where('a.id', $grupo)
         ->groupBy(
                'a.id',
                'a.nombre',
                'd.jornada',
                'f.nombre',
                'e.descripcion',
                'f.clase'
            )
        ->get();
        $data = $data[0];
        return view('templates.clases.index', compact('data'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $this->info_user();
        $modulos  = Modulos::where('deleted_at', null)->get();
        $salones  = Salones::where('deleted_at', null)->get();
        $jornadas = DB::table('jornadas')
            ->select(
                'id',
                'jornada',
                'hora_inicio',
                'hora_fin'
            )
            ->where([
                ['deleted_at', '=', null],
                ['jornada', '<>', 'Default'],
            ])
            ->get();
        $sedes = DB::table('sede')
            ->select(
                'id',
                'nombre'
            )
            ->where([
                ['deleted_at', '=', null],
            ])
            ->get();
        return view('templates.clases.create', compact('modulos', 'salones', 'jornadas', 'sedes'));
    }

    public function validarSalon($fechas_clase, $hora_inicio, $salon_id){
        $new_f = array();
        foreach ($fechas_clase as $value) {
            array_push($new_f, $value.' '.$hora_inicio);
        }

        $valid_salon = DB::table('clases_detalle AS a')
        ->join('salones AS b', 'a.salon_id', 'b.id')
        ->select(
            'a.id',
            'a.start',
            'b.codigo'
        )
        ->where([
            ['a.salon_id', $salon_id],
            ['a.estado_id', '<>', 3 ],
            ['a.deleted_at', NULL]
        ])
        ->whereIn('start', $new_f)
        ->get();
        $answer = array(
            'errorSalon' => false
        );
        if (count($valid_salon) > 0) {
            $answer = array(
                'errorSalon' => true,
                'fechas' => $valid_salon
            );
        }
        return $answer;
    }
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $success = true;
        $fechas_error = null;
        DB::beginTransaction();

        try {
            $moduloOrden = array();
            foreach ($request->modulos as $key => $value) {
                array_push($moduloOrden, $value['id']);
            }
            $grupo = DB::table('grupo')->insertGetId([
                'nombre' => $request->grupo,
                'orden_modulos' => implode(",", $moduloOrden),
                'dias_clase' => implode(",", $request->semana)
            ]);

            $hora_inicio = $request->hora_inicio_jornada;
            $hora_fin = $request->hora_fin_jornada;

            $id_class = Clases::create([
                'modulo_id' => $moduloOrden[0],
                'fecha_inicio' => $request->fecha_inicio,
                'sede_id' => $request->sede,
                'jornada_id' => $request->jornada,
                'observacion' => $request->observacion,
                'estado_id' => 1,
                'grupo_id' => $grupo
            ])->id;

            $fechas_clase = $this->programarClases($request->fecha_inicio, $request->modulos[0]['duracion'], $request->semana);
            $result = $this->validarSalon($fechas_clase, $hora_inicio, $request->salon['id']);
            if ($result['errorSalon']) {
                $fechas_error = $result['fechas'];
                throw new \Exception("something happened");
            }

            foreach ($fechas_clase as $clave => $value) {
                DB::table('clases_detalle')->insert([
                    ['title' => 'clase de '. $request->modulos[0]['name'], 'clases_id' => $id_class, 'start' => $value . ' ' . $hora_inicio, 'end' => $value . ' ' . $hora_fin, 'color' => $request->color, 'salon_id' => $request->salon['id']],
                ]);
            }



            // foreach ($request->modulos as $key => $value) {
            //     $id_class = Clases::create([
            //         'modulo_id' => $value['id'],
            //         'fecha_inicio' => $request->fecha_inicio,
            //         'sede_id' => $request->sede,
            //         'jornada_id' => $request->jornada,
            //         'observacion' => $request->observacion,
            //         'estado_id' => 1,
            //         'grupo_id' => $grupo
            //     ])->id;
            //     array_push($clases_id, $id_class);
            //     if ($key == 0) {
            //         $fecha_inicio = $request->fecha_inicio;
            //     }else{
            //         $fecha = new DateTime(end($fechas_clase[$key - 1]));
            //         $fecha = $fecha->add(new DateInterval('P1D'));
            //         $fecha_inicio = $fecha->format('Y-m-d');
            //     }
            //     $nombres_modulo[] = $value['name'];
            //     $fechas_clase[] = $this->programarClases($fecha_inicio, $value['duracion'], $request->semana);
            // }
            // foreach ($fechas_clase as $value) {
            //     $result = $this->validarSalon($value, $hora_inicio, $request->salon['id']);
            //     if ($result['errorSalon']) {
            //         $fechas_error = $result['fechas'];
            //         throw new \Exception("something happened");
            //     }
            // }
            // foreach ($fechas_clase as $clave => $arr) {
            //     foreach ($arr as $key => $value) {
            //         DB::table('clases_detalle')->insert([
            //             ['title' => 'clase de '. $nombres_modulo[$clave], 'clases_id' => $clases_id[$clave], 'start' => $value . ' ' . $hora_inicio, 'end' => $value . ' ' . $hora_fin, 'color' => $request->color, 'salon_id' => $request->salon['id']],
            //         ]);
            //     }
            // }
            DB::commit();
        } catch (\Exception $e) {
            DB::rollback();
            $success = false;
            $exception = $e;
            return $e;
        }
        if($success){
            return array(
                'code' => 200,
                'errorSalon' => false
            );
        }else{
            return array(
                'code' => 600,
                'errorSalon' => true,
                'fechas' => $fechas_error,
                'exception' => $exception
            );
        }
    }
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function programar_modulo($grupo_id)
    {
        $grupo = DB::table('grupo AS a')
        ->select('a.orden_modulos', 'a.dias_clase')
        ->where('a.id', $grupo_id)
        ->first();
        $modulo = DB::table('clases AS a')
        ->join('modulos AS b', 'a.modulo_id', 'b.id')
        ->join('jornadas AS c', 'a.jornada_id', 'c.id')
        ->select('a.sede_id', 'b.id', 'b.duracion', 'c.id AS jornada_id', 'c.hora_inicio', 'c.hora_fin',
            DB::raw('(select max(start) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id)) AS fecha_fin')
        )
        ->where('a.grupo_id', $grupo_id)
        ->orderby('a.created_at','DESC')
        ->take(1)->first();
        $fecha = new DateTime($modulo->fecha_fin);
        $fecha = $fecha->add(new DateInterval('P1D'));
        $fecha_inicio = $fecha->format('Y-m-d');
        // return response()->json($modulo->fecha_fin);
        $orden_modulos = explode(',', $grupo->orden_modulos);
        $dias_clase = explode(',', $grupo->dias_clase);
        $clave = array_search($modulo->id, $orden_modulos);
        // return $orden_modulos[$clave + 1];
        if (array_key_exists($clave + 1, $orden_modulos)) {
            $sgte_modulo = $orden_modulos[$clave + 1];
            $nombre_modulo = DB::table('modulos')
            ->select('nombre')
            ->where('id', $sgte_modulo)
            ->first();
        }else{
            return array(
                'code' => 300
            );
        }
        $success = true;
        $fechas_error = null;
        DB::beginTransaction();

        try {

            $hora_inicio = $modulo->hora_inicio;
            $hora_fin = $modulo->hora_fin;

            $id_class = Clases::create([
                'modulo_id' => $orden_modulos[$clave + 1],
                'fecha_inicio' => $fecha_inicio,
                'sede_id' => $modulo->sede_id,
                'jornada_id' => $modulo->jornada_id,
                'estado_id' => 1,
                'grupo_id' => $grupo_id
            ])->id;

            $fechas_clase = $this->programarClases($fecha_inicio, $modulo->duracion, $dias_clase);
            $result = $this->validarSalon($fechas_clase, $hora_inicio, 8);
            if (isset($result['errorSalon']) && $result['errorSalon']) {
                $fechas_error = $result['fechas'];
                throw new \Exception("El salón no está disponible");
            }

            foreach ($fechas_clase as $clave => $value) {
                DB::table('clases_detalle')->insert([
                    ['title' => 'clase de '. $nombre_modulo->nombre, 'clases_id' => $id_class, 'start' => $value . ' ' . $hora_inicio, 'end' => $value . ' ' . $hora_fin, 'salon_id' => 8],
                ]);
            }
            DB::commit();
        } catch (\Exception $e) {
            DB::rollback();
            $success = false;
            $exception = $e;
            return $e;
        }
        if($success){
            return array(
                'code' => 200,
                'errorSalon' => false
            );
        }else{
            return array(
                'code' => 600,
                'errorSalon' => true,
                'fechas' => $fechas_error,
                'exception' => $exception
            );
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $data = DB::table('clases_detalle As a')
            ->join('estado AS b', 'a.estado_id', 'b.id')
            ->select(
                'a.id',
                'a.title',
                'a.start',
                'a.end',
                'a.all_day',
                'a.color',
                'b.descripcion AS estado',
                DB::raw('(SELECT b.codigo FROM salones AS b WHERE b.id = a.salon_id) AS salon'),
                DB::raw('(SELECT c.sede_id FROM clases AS c WHERE c.id = a.clases_id) AS sede_id')
            )
            ->where([
                ['a.deleted_at', '=', null],
                ['a.clases_id', '=', $id],
            ])
            ->get();
        return Response()->json($data);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $this->info_user();
        $grupo = DB::table('grupo AS a')
        ->join('clases AS b', 'a.id', 'b.grupo_id')
        ->select('a.id')
        ->where('b.id', $id)
        ->first();
        Javascript::put([
            'clase_id' => $id,
            'grupo_id' => $grupo->id,
        ]);
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
                ['a.id', '=', $id],
            ])
            ->get();
        $data       = $data[0];
        $porcentaje = $data->completadas / $data->total * 100;

        return view('templates.clases.detail', compact('data', 'porcentaje'));
    }

    public function getAll($grupo)
    {
        $user = $this->get_user();
        if ($user->hasRole('Profesor')) {
            $where = array(
                ['a.profesor_id', '=', $this->get_user('id')],
                ['a.deleted_at', '=', null],
                ['a.sede_id', '=', $this->get_user('sede_id')],
            );
        } elseif ($user->hasRole('Administrador')) {
            $where = array(
                ['a.deleted_at', '=', null],
            );
        } elseif ($user->hasRole('Coordinador')) {
            $where = array(
                ['a.sede_id', '=', $this->get_user('sede_id')],
                ['a.deleted_at', '=', null],
            );
        } else {
            $where = array(
                ['a.deleted_at', '=', null],
            );

        }
        $data = DB::table('clases As a')
            ->join('modulos AS c', 'a.modulo_id', 'c.id')
            ->join('jornadas AS d', 'a.jornada_id', 'd.id')
            ->join('estado AS e', 'a.estado_id', 'e.id')
            ->join('sede AS f', 'a.sede_id', 'f.id')
            ->leftJoin('users AS i', 'a.profesor_id', 'i.id')
            ->select(
                'a.id',
                DB::raw('(select min(start) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id)) AS fecha_inicio'),
                DB::raw('(select max(start) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id)) AS fecha_fin'),
                DB::raw('(select count(estado_id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id and`g`.`estado_id` = 3)) AS completadas'),
                DB::raw('(select count(id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id )) AS total'),
                // DB::raw('(select count(g.id) from `estudiante` as `g` where (`g`.`grupo_id` = a.id )) AS cant'),
                DB::raw('(SELECT Count(x.id) FROM grupo AS z INNER JOIN clases AS v ON v.grupo_id = z.id INNER JOIN clases_estudiante AS x ON x.clases_id = v.id WHERE z.id = a.id) AS cant'),
                DB::raw("(IFNULL(( SELECT CONCAT_WS('/',s.codigo,s.capacidad) FROM clases_detalle AS j INNER JOIN salones AS s ON j.salon_id = s.id WHERE j.clases_id = a.id AND j.estado_id = 3 ORDER BY j.id DESC LIMIT 1 ), ( SELECT CONCAT_WS('/',s.codigo,s.capacidad) FROM clases_detalle AS j INNER JOIN salones AS s ON  j.salon_id = s.id WHERE j.clases_id = a.id ORDER BY j.id ASC LIMIT 1 ) )) AS salon"),
                'a.observacion',
                'a.estado_id',
                'c.nombre AS modulo',
                'd.jornada AS jornada',
                'e.descripcion AS estado',
                'e.clase AS clase_estado',
                'f.nombre AS sede',
                'a.profesor_id',
                DB::raw("concat_ws(' ', i.name,i.last_name) AS profesor"),
                'i.img AS profesor_img'

            )
            ->where($where)
            ->where('a.grupo_id', $grupo)
            ->orderBy('estado')
            ->get();
        foreach ($data as $key => $value) {
            if ($value->completadas == $value->total) {
                DB::table('clases')
                    ->where('id', '=', $value->id)
                    ->update(
                        ['estado_id' => 3]
                    );
            }
            if ($value->completadas > 0 && $value->completadas < $value->total) {
                DB::table('clases')
                    ->where('id', '=', $value->id)
                    ->update(
                        ['estado_id' => 2]
                    );
            }
        }
        return Datatables::of($data)->make(true);
    }

    public function getById()
    {
        $data = DB::table('clases_detalle As a')
            ->select(
                'a.start',
                'a.estado_id'
            )
            ->where([['a.deleted_at', '=', null]])
            ->get();
        return Datatables::of($data)->make(true);
    }

    public function getFin($clases_id)
    {
        $data = DB::table('clases_detalle As a')
            ->select(
                DB::raw('max(start) as fecha')
            )
            ->where([['a.deleted_at', '=', null], ['a.clases_id', '=', $clases_id]])
            ->get();
        return $data;
    }

    public function programarClases($fecha_inicio, $duracion, $dias_clase)
    {

        $fechas_clase = array();
        $this->festivos(date('Y', strtotime($fecha_inicio)));

        for ($i = 0; count($fechas_clase) < $duracion; $i++) {
            // 1. sumarle 1 a la fecha de fecha_inicio
            if ($i == 0) {
                $fecha    = new DateTime($fecha_inicio);
                $sgte_dia = $fecha->format('Y-m-d');
            }
            if ($i > 0) {
                $fecha    = new DateTime($sgte_dia);
                $fecha    = $fecha->add(new DateInterval('P1D'));
                $sgte_dia = $fecha->format('Y-m-d');
            }
            // 2. obtengo el número de la semana de la fecha incio más 1
            $numero_dia = $this->numberDay($sgte_dia);
            // 3. comparo el numero con el arreglo de clases en la semana
            if (in_array($numero_dia, $dias_clase)) {
                // si hay clase ese día, se agrega al arreglo de de sgte fecha
                if (!$this->esFestivo($sgte_dia)) {
                    array_push($fechas_clase, $sgte_dia);
                }
                // echo "El día ".$numero_dia." SÍ hay clase. fecha: ".$sgte_dia."<br>";
            }
        }

        return $fechas_clase;
    }

    public function numberDay($date)
    {
        // La N como parametro en la función date() es para obtener el número del día de la semana 1 = lunes 7 = domingo
        return date('N', strtotime($date));
    }

    public function numberMonth($date)
    {
        // La N como parametro en la función date() es para obtener el número del día de la semana 1 = lunes 7 = domingo
        return date('j', strtotime($date));
    }

    public function saber_dia($nombredia)
    {
        // Arreglo para reemplazar los número del día de la semana por su respectivo nombre
        $dias = array('', 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo');
        // La N como parametro en la función date() es para obtener el número del día de la semana 1 = lunes 7 = domingo
        $fecha = $dias[date('N', strtotime($nombredia))];
        echo $fecha;
    }

    public function set_estudiante_asistencia(Request $request)
    {
        try {
            foreach ($request->estudiantes_id as $key => $value) {
                DB::table('clases_estudiante_asistencia')
                    ->insert([
                        ['clases_detalle_id' => $request->clases_detalle_id, 'estudiante_id' => $value],
                    ]);
            }
            DB::table('clases_detalle')
                ->where('id', '=', $request->clases_detalle_id)
                ->update(
                    ['estado_id' => 3, 'color' => '#999da3']
                );

            $grupo = DB::table('grupo AS a')
                ->join('clases AS b', 'a.id', 'b.grupo_id')
                ->select('a.id')
                ->where('b.id', $request->clases_id)
                ->first();

            DB::table('grupo AS a')
                ->where('a.id', '=', $grupo->id)
                ->update(
                    ['a.estado_id' => 2]
                );

            DB::table('clases_profesor_asistencia')
                ->insert([
                    ['clases_detalle_id' => $request->clases_detalle_id, 'user_id' => $this->get_user('id')],
                ]);
            $answer = array('code' => 200);

            return $answer;
        } catch (Exception $e) {

        }
    }

    public function get_estudiante_asistencia($estudiante_id, $clases_detalle_id)
    {
        $data = DB::table('clases_estudiante_asistencia AS a')
            ->select(
                DB::raw('count(a.id) AS cantidad')
            )
            ->where([
                ['estudiante_id', '=', $estudiante_id],
                ['clases_detalle_id', '=', $clases_detalle_id],
            ])
            ->get();
        return $data;
    }

    public function getAll_estudiantes_asistencia($clase_id, $clases_detalle_id)
    {
        $data = DB::table('clases_estudiante_asistencia AS a')
            ->select(
                'a.estudiante_id',
                DB::raw('(SELECT c.descripcion FROM clases_detalle AS b INNER JOIN estado AS c ON c.id = b.estado_id WHERE b.id = a.clases_detalle_id) AS estado')
            )
            ->where([
                ['clases_detalle_id', '=', $clases_detalle_id],
            ])
            ->get();
        return $data;
    }

    public function buscar_profesor($clases_id, $dato)
    {
        $data = DB::table('users As a')
            ->join('model_has_roles AS b', 'a.id', 'b.model_id')
            ->join('roles AS c', 'b.role_id', 'c.id')
            ->select(
                'a.sede_id',
                'a.id',
                'a.name',
                'a.last_name',
                'a.email',
                'a.identification_card'
            )
            ->where([
                ['a.name', 'LIKE', $dato . '%'],
                ['c.id', '=', 1],
                ['a.sede_id', '=', DB::raw('(SELECT sede_id FROM clases WHERE id = ' . $clases_id . ')')],
                ['a.deleted_at', '=', null],
            ])
            ->get();
        return $data;
    }

    public function changeSalon(Request $request)
    {
        try {
            if ($request->salon_id != 0) {
                DB::table('clases_detalle')
                    ->where('id', '=', $request->clases_detalle_id)
                    ->update(
                        ['salon_id' => $request->salon_id]
                    );
                $salon = DB::table('salones AS b')
                    ->select('b.codigo')
                    ->where('b.id', '=', $request->salon_id)
                    ->get();
                $answer = array('code' => 200, 'salon' => $salon[0]->codigo);
                return $answer;
            }
        } catch (Exception $e) {
            return $e;
        }
    }

    public function asignar_profesor($clases_id, $profesor_id)
    {
        try {
            DB::table('clases')
                ->where('id', '=', $clases_id)
                ->update(
                    ['id' => $clases_id, 'profesor_id' => $profesor_id]
                );
            $answer = array('code' => 200, 'datos' => $profesor_id);
            return $answer;
        } catch (Exception $e) {
            return $e;
        }
    }

    public function profesor_asignado($clases_id)
    {
        $data = DB::table('clases AS a')
            ->leftJoin('users AS b', 'a.profesor_id', 'b.id')
            ->select(
                DB::raw("concat_ws(' ', b.name,b.last_name) AS profesor"),
                'a.profesor_id'
            )
            ->where('a.id', '=', $clases_id)
            ->get();

        return $data;
    }

    public function getFestivos($ano = '')
    {
        $this->festivos($ano);
        return $this->festivos;
    }

    public function festivos($ano = '')
    {
        $this->hoy = date('d/m/Y');

        if ($ano == '') {
            $ano = date('Y');
        }

        $this->ano = $ano;

        $this->pascua_mes = date("m", easter_date($this->ano));
        $this->pascua_dia = date("d", easter_date($this->ano));

        $this->festivos[$ano][1][1]   = true; // Primero de Enero
        $this->festivos[$ano][5][1]   = true; // Dia del Trabajo 1 de Mayo
        $this->festivos[$ano][7][20]  = true; // Independencia 20 de Julio
        $this->festivos[$ano][8][7]   = true; // Batalla de Boyacá 7 de Agosto
        $this->festivos[$ano][12][8]  = true; // Maria Inmaculada 8 diciembre (religiosa)
        $this->festivos[$ano][12][25] = true; // Navidad 25 de diciembre

        $this->calcula_emiliani(1, 6); // Reyes Magos Enero 6
        $this->calcula_emiliani(3, 19); // San Jose Marzo 19
        $this->calcula_emiliani(6, 29); // San Pedro y San Pablo Junio 29
        $this->calcula_emiliani(8, 15); // Asunción Agosto 15
        $this->calcula_emiliani(10, 12); // Descubrimiento de América Oct 12
        $this->calcula_emiliani(11, 1); // Todos los santos Nov 1
        $this->calcula_emiliani(11, 11); // Independencia de Cartagena Nov 11

        //otras fechas calculadas a partir de la pascua.

        $this->otrasFechasCalculadas(-6); //lunes santo
        $this->otrasFechasCalculadas(-5); //martes santo
        $this->otrasFechasCalculadas(-4); //miercoles santo
        $this->otrasFechasCalculadas(-3); //jueves santo
        $this->otrasFechasCalculadas(-2); //viernes santo
        $this->otrasFechasCalculadas(-1); //sábado santo
        $this->otrasFechasCalculadas(0); //domingo santo

        $this->otrasFechasCalculadas(43, true); //Ascención el Señor pascua
        $this->otrasFechasCalculadas(64, true); //Corpus Cristi
        $this->otrasFechasCalculadas(71, true); //Sagrado Corazón

        // otras fechas importantes que no son festivos

        // $this->otrasFechasCalculadas(-46);       // Miércoles de Ceniza
        // $this->otrasFechasCalculadas(-46);       // Miércoles de Ceniza
        // $this->otrasFechasCalculadas(-48);       // Lunes de Carnaval Barranquilla
        // $this->otrasFechasCalculadas(-47);       // Martes de Carnaval Barranquilla
    }
    protected function calcula_emiliani($mes_festivo, $dia_festivo)
    {
        // funcion que mueve una fecha diferente a lunes al siguiente lunes en el
        // calendario y se aplica a fechas que estan bajo la ley emiliani
        //global  $y,$dia_festivo,$mes_festivo,$festivo;
        // Extrae el dia de la semana
        // 0 Domingo  6 Sábado
        $dd = date("w", mktime(0, 0, 0, $mes_festivo, $dia_festivo, $this->ano));
        switch ($dd) {
            case 0: // Domingo
                $dia_festivo = $dia_festivo + 1;
                break;
            case 2: // Martes.
                $dia_festivo = $dia_festivo + 6;
                break;
            case 3: // Miércoles
                $dia_festivo = $dia_festivo + 5;
                break;
            case 4: // Jueves
                $dia_festivo = $dia_festivo + 4;
                break;
            case 5: // Viernes
                $dia_festivo = $dia_festivo + 3;
                break;
            case 6: // Sábado
                $dia_festivo = $dia_festivo + 2;
                break;
        }
        $mes                                    = date("n", mktime(0, 0, 0, $mes_festivo, $dia_festivo, $this->ano)) + 0;
        $dia                                    = date("d", mktime(0, 0, 0, $mes_festivo, $dia_festivo, $this->ano)) + 0;
        $this->festivos[$this->ano][$mes][$dia] = true;
    }
    protected function otrasFechasCalculadas($cantidadDias = 0, $siguienteLunes = false)
    {
        $mes_festivo = date("n", mktime(0, 0, 0, $this->pascua_mes, $this->pascua_dia + $cantidadDias, $this->ano));
        $dia_festivo = date("d", mktime(0, 0, 0, $this->pascua_mes, $this->pascua_dia + $cantidadDias, $this->ano));

        if ($siguienteLunes) {
            $this->calcula_emiliani($mes_festivo, $dia_festivo);
        } else {
            $this->festivos[$this->ano][$mes_festivo + 0][$dia_festivo + 0] = true;
        }
    }
    public function esFestivo($fecha = null)
    {
        if ($fecha == null) {
            return false;
        }
        $dia = date('d', strtotime($fecha));
        $mes = date('m', strtotime($fecha));
        if (isset($this->festivos[$this->ano][(int) $mes][(int) $dia])) {
            // return 'Sí es festivo';
            return true;
        } else {
            // return 'No es festivo';
            return false;
        }

    }

}
