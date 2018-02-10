<?php

namespace App\Http\Controllers\Clases;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;
use DateTime;
use DateInterval;
use App\Clases;
use App\Salones;
use App\Modulos;
use App\Profesores;

class ClasesController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view('templates.clases.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $modulos = Modulos::where('deleted_at', NULL)->get();
        $salones = Salones::where('deleted_at', NULL)->get();
        $profesores = Profesores::where('deleted_at', NULL)->get();
        $jornadas = DB::table('jornadas')
        ->select(
            'id',
            'jornada'
        )
        ->where([
            ['deleted_at', '=',null],
            ['jornada', '<>', 'Default'],
        ])
        ->get();
        $sedes = DB::table('sede')
        ->select(
            'id',
            'nombre'
        )
        ->where([
            ['deleted_at', '=',null]
        ])
        ->get();
        return view('templates.clases.create', compact('modulos','salones', 'profesores', 'jornadas', 'sedes'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        // Guardar en tabla pivot modulo_jornada
        // DB::table('modulos_jornada')
        // ->insert(
        //     ['modulo_id' -> $request->modulo, 'jornada_id' => $request->jornada, 'duracion' => $request->duracion]
        // );
        // Guardar en tabla clases
        $clases_id = Clases::create($request->all())->id;
        $fechas_clase = $this->programarClases($request->fecha_inicio, $request->duracion, $request->semena);
        // Guardar en tabla clases_detalle
        foreach ($fechas_clase as $key => $value) {
            DB::table('clases_detalle')->insert([
                ['title' => 'clase', 'clases_id' => $clases_id, 'start' => $value, 'end' => $value, 'color' => $request->color]
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
            'b.descripcion AS estado'
        )
        ->where([
            ['a.deleted_at', '=', NULL],
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
        $data = DB::table('clases As a')
        ->join('salones AS b', 'a.salon_id', 'b.id')
        ->join('modulos AS c', 'a.modulo_id', 'c.id')
        ->join('jornadas AS d', 'a.jornada_id', 'd.id')
        ->join('estado AS e', 'a.estado_id', 'e.id')
        ->join('sede AS f', 'a.sede_id', 'f.id')
        // ->join('profesores AS g', 'a.profesor_id', 'g.id')
        ->select(
            'a.id',
            DB::raw('(select max(start) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id)) AS fecha_fin'),
            DB::raw('(select count(estado_id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id and`g`.`estado_id` = 3)) AS completadas'),
            DB::raw('(select count(id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id )) AS total'),
            'a.fecha_inicio',
            'a.observacion',
            'a.estado_id',
            'a.cant_estudiantes',
            'b.nombre AS salon',
            'b.capacidad',
            'c.nombre AS modulo',
            'd.jornada AS jornada',
            'e.descripcion AS estado',
            'e.clase AS clase_estado',
            'f.nombre AS sede',
            'a.profesor_id AS profesor'
        )
        ->where([
            ['a.deleted_at', '=', NULL],
            ['a.ID', '=', $id]
        ])
        ->get();
        $data = $data[0];
        $porcentaje = $data->completadas/$data->total*100;
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
        $data = DB::table('clases As a')
        ->join('salones AS b', 'a.salon_id', 'b.id')
        ->join('modulos AS c', 'a.modulo_id', 'c.id')
        ->join('jornadas AS d', 'a.jornada_id', 'd.id')
        ->join('estado AS e', 'a.estado_id', 'e.id')
        ->join('sede AS f', 'a.sede_id', 'f.id')
        // ->join('profesores AS g', 'a.profesor_id', 'g.id')
        ->select(
            'a.id',
            DB::raw('(select max(start) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id)) AS fecha_fin'),
            DB::raw('(select count(estado_id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id and`g`.`estado_id` = 3)) AS completadas'),
            DB::raw('(select count(id) from `clases_detalle` as `g` where (`g`.`deleted_at` is null and `g`.`clases_id` = a.id )) AS total'),
            'a.fecha_inicio',
            'a.observacion',
            'a.estado_id',
            'a.cant_estudiantes',
            'b.nombre AS salon',
            'b.capacidad',
            'c.nombre AS modulo',
            'd.jornada AS jornada',
            'e.descripcion AS estado',
            'e.clase AS clase_estado',
            'f.nombre AS sede',
            'a.profesor_id AS profesor'
        )
        ->where('a.deleted_at', '=', NULL)
        ->get();
        return Datatables::of($data)->make(true);
    }

    public function getById()
    {
        $data = DB::table('clases_detalle As a')
        ->select(
            'a.start',
            'a.estado_id'
        )
        ->where([['a.deleted_at', '=', NULL]])
        ->get();
        return Datatables::of($data)->make(true);
    }

    public function getFin($clases_id)
    {
        $data = DB::table('clases_detalle As a')
        ->select(
            DB::raw('max(start) as fecha')
        )
        ->where([['a.deleted_at', '=', NULL],['a.clases_id', '=' , $clases_id]])
        ->get();
        return $data;
    }

    public function programarClases($fecha_inicio, $duracion, $dias_clase){

        $fechas_clase = array();

        for ($i=0; count($fechas_clase) < $duracion ; $i++) {
            // 1. sumarle 1 a la fecha de fecha_inicio
            if ($i == 0) {
                $fecha = new DateTime($fecha_inicio);
                $sgte_dia = $fecha->format('Y-m-d');
            }
            if ($i > 0) {
                $fecha = new DateTime($sgte_dia);
                $fecha = $fecha->add(new DateInterval('P1D'));
                $sgte_dia = $fecha->format('Y-m-d');
            }
            // 2. obtengo el número de la semana de la fecha incio más 1
            $numero_dia = $this->numberDay($sgte_dia);
            // 3. comparo el numero con el arreglo de clases en la semana 
            if (in_array($numero_dia, $dias_clase)) {
            // si hay clase ese día, se agrega al arreglo de de sgte fecha
                array_push($fechas_clase,$sgte_dia);
                // echo "El día ".$numero_dia." SÍ hay clase. fecha: ".$sgte_dia."<br>";
            }
        }
        
        return $fechas_clase;
    }

    function numberDay($date) {
        // La N como parametro en la función date() es para obtener el número del día de la semana 1 = lunes 7 = domingo 
        return date('N', strtotime($date));
    }

    function saber_dia($nombredia) {
        // Arreglo para reemplazar los número del día de la semana por su respectivo nombre
        $dias = array('','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo');
        // La N como parametro en la función date() es para obtener el número del día de la semana 1 = lunes 7 = domingo 
        $fecha = $dias[date('N', strtotime($nombredia))];
        echo $fecha;
    }

    public function buscar_estudiante($dato){
        $data = DB::table('estudiante As a')
        ->select(
            'a.id',
            'a.consecutivo',
            'a.nombres',
            'a.primer_apellido',
            'a.segundo_apellido'
        )
        ->where([['a.deleted_at', '=', NULL],['a.consecutivo', '=' , $dato]])
        ->get();
        return $data;
    }
}
