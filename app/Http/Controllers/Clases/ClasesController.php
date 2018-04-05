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
    public function index()
    {
        $this->info_user();
        return view('templates.clases.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
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

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        // Guardar en tabla clases
        $clases_id = Clases::create($request->all())->id;

        $fechas_clase = $this->programarClases($request->fecha_inicio, $request->duracion, $request->semana);
        // Guardar en tabla clases_detalle
        $hora_inicio = $request->hora_inicio_jornada;
        $hora_fin    = $request->hora_fin;
        $modulo      = DB::table('modulos AS a')
            ->select(
                'a.nombre'
            )
            ->where('a.id', '=', $request->modulo_id)
            ->get();
        foreach ($fechas_clase as $key => $value) {
            DB::table('clases_detalle')->insert([
                ['title' => 'clase de ' . $modulo[0]->nombre, 'clases_id' => $clases_id, 'start' => $value . ' ' . $hora_inicio, 'end' => $value . ' ' . $hora_fin, 'color' => $request->color, 'salon_id' => $request->salon_id],
            ]);

        }

        return redirect('clases');
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
        $data = DB::table('clases As a')
        // ->join('salones AS b', 'a.salon_id', 'b.id')
            ->join('modulos AS c', 'a.modulo_id', 'c.id')
            ->join('jornadas AS d', 'a.jornada_id', 'd.id')
            ->join('estado AS e', 'a.estado_id', 'e.id')
            ->join('sede AS f', 'a.sede_id', 'f.id')
            ->leftJoin('users AS g', 'a.profesor_id', 'g.id')
            ->select(
                'a.id',
                DB::raw('(select max(start) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id)) AS fecha_fin'),
                DB::raw('(select count(estado_id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id and`g`.`estado_id` = 3)) AS completadas'),
                DB::raw('(select count(id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id )) AS total'),
                DB::raw('(select count(id) from `clases_estudiante` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id )) AS cupos_usados'),
                DB::raw('(SELECT GROUP_CONCAT(DISTINCT s.codigo,"    /    ", s.capacidad SEPARATOR ", ") AS salon FROM clases_detalle AS j INNER JOIN salones AS s ON j.salon_id = s.id WHERE j.clases_id = a.id ) AS salon'),

                'a.fecha_inicio',
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

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }

    public function getAll()
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
        // ->join('salones AS b', 'k.salon_id', 'b.id')
            ->join('modulos AS c', 'a.modulo_id', 'c.id')
            ->join('jornadas AS d', 'a.jornada_id', 'd.id')
            ->join('estado AS e', 'a.estado_id', 'e.id')
            ->join('sede AS f', 'a.sede_id', 'f.id')
            ->leftJoin('users AS i', 'a.profesor_id', 'i.id')
            ->select(
                'a.id',
                DB::raw('(select max(start) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id)) AS fecha_fin'),
                DB::raw('(select count(estado_id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id and`g`.`estado_id` = 3)) AS completadas'),
                DB::raw('(select count(id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id )) AS total'),
                DB::raw('(select count(g.estudiante_id) from `clases_estudiante` as `g` where (`g`.`clases_id` = a.id )) AS cant'),
                DB::raw('(SELECT GROUP_CONCAT(DISTINCT s.codigo,"    /    ", s.capacidad SEPARATOR ", ") AS salon FROM clases_detalle AS j INNER JOIN salones AS s ON j.salon_id = s.id WHERE j.clases_id = a.id ) AS salon'),
                'a.fecha_inicio',
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

    public function buscar_estudiante($dato)
    {
        $data = DB::table('estudiante As a')
            ->select(
                'a.id',
                'a.consecutivo AS codigo',
                'a.num_documento',
                DB::raw("concat_ws(' ', a.primer_apellido, a.segundo_apellido, a.nombres) AS nombre")
            )
            ->where([['a.deleted_at', '=', null], ['a.consecutivo', '=', $dato]])
            ->orWhere('a.num_documento', '=', $dato)
            ->get();
        return $data;
    }

    public function agregar_estudiante($clases_id, $estudiante_id)
    {
        $exist = DB::table('clases_estudiante AS a')
            ->join('clases AS b', 'a.clases_id', 'b.id')
            ->join('jornadas AS c', 'b.jornada_id', 'c.id')
            ->join('sede AS d', 'b.sede_id', 'd.id')
            ->select(
                'b.id',
                'd.nombre AS sede',
                'c.jornada'
            )
            ->where([
                ['a.estudiante_id', '=', $estudiante_id],
                ['a.clases_id', '=', $clases_id],
                ['b.estado_id', '<>', 3],
            ])
            ->get();

        $cupos_usados = DB::table('clases_estudiante AS a')
            ->select(
                DB::raw("count(a.estudiante_id) AS cant")
            )
            ->where([
                ['a.clases_id', '=', $clases_id],
            ])
            ->get();

        $salon = DB::table('salones AS a')
            ->join('clases_detalle AS b', 'a.id', 'b.salon_id')
            ->select(
                'a.capacidad'
            )
            ->where([['b.clases_id', '=', $clases_id]])
            ->get();
        if ($salon[0]->capacidad == $cupos_usados[0]->cant) {
            $answer = array(
                'code' => 601,
            );
        } else {
            if (count($exist) <= 0) {
                DB::table('clases_estudiante')
                    ->insert([
                        ['clases_id' => $clases_id, 'estudiante_id' => $estudiante_id],
                    ]);
                $answer = array('code' => 200);
            } else {
                $answer = array(
                    'code' => 600,
                    'data' => $exist[0],
                );
            }
        }
        return $answer;
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

    public function estudiantes_inscritos($clases_id)
    {
        $data = DB::table('clases_estudiante AS a')
            ->join('estudiante AS b', 'a.estudiante_id', 'b.id')
            ->join('programas AS c', 'b.programas_id', 'c.id')
            ->select(
                DB::raw("concat_ws(' ', primer_apellido, segundo_apellido, nombres) AS nombre"),
                'programa',
                'b.consecutivo AS codigo',
                'b.correo',
                'b.id'
            )
            ->where('a.clases_id', '=', $clases_id)
            ->orderBy('nombre')
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

    public function removeStudentClass($clases_id, $estudiante_id)
    {
        try {
            DB::table('clases_estudiante AS a')
            ->where([
                ['a.clases_id', $clases_id],
                ['a.estudiantes_id', $estudiante_id],
            ])
            ->delete();
            return true;
        } catch (Exception $e) {
            return $e;
        }
    }

}
