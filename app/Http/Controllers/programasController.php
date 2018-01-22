<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Programas_unicos;

class programasController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $sede = DB::table('sede AS a')
        ->select(
            'a.id',
            'a.nombre'
        )->get();
        return view('templates.programas', compact('sede'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        try{
            // $programas_unicos = new Programas_unicos;
            // $programas_unicos->nombre = $request->nombre;
            // $programas_unicos->nombre->save();

            $sedes = $request->sedes;
            return $sedes;
            foreach ($sedes as $key => $value) {
                DB::table('programas')
                ->insert(
                    ['sede_id' => $value] 
                );
            }


            if (Programas_unicos::insert($request->all())) {
                $answer=array(
                    "datos" => $request->all(),
                    "code" => 200
                );
            }
            return $answer;
        } catch (Exception $e) {
            return $e;
        }
        return $request->all();
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
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
