<?php

namespace App\Http\Controllers\Clases;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
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
        // Guardar en tabla Calendario Modulos
        $clase = new Clases;
        $clase->modulo_id = $request->modulo_id; 
        $clase->fecha_inicio = $request->fecha_inicio; 
        $clase->salon_id = $request->salon_id; 
        $clase->sede_id = $request->sede_id;
        $clase->jornada_id = $request->jornada_id;
        $clase->observacion  = $request->observacion;
        $clase->estado_id = 1;
        $clase->save();

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
        return view('templates.clases.add_student');
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
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
}
