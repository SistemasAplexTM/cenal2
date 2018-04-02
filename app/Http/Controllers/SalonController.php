<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Requests\SalonRequest;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\DB;
use App\Salones;
use App\Ubicacion;

class SalonController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $ubicacion = Ubicacion::where('deleted_at', NULL)->get();
        $sedes = DB::table('sede AS a')
        ->select(
            'a.id',
            'a.nombre'
        )
        ->get();
        return view('templates.salon', compact('ubicacion', 'sedes'));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $data = Salones::findOrFail($id);
        return $data;
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(SalonRequest $request)
    {
        try{
            $data = new Salones;
            $data->fill($request->all());
            $data->sede_id = $request->sede_id['id'];
            $data->ubicacion = implode(",", $request->ubicacion);
            if ($data->save()) {
                $answer=array(
                    "code" => 200
                );
            }
            return $answer;
        } catch (Exception $e) {
            return $e;
        }
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(SalonRequest $request, $id)
    {
        try {
            $data = Salones::findOrFail($id);
            $data->fill($request->all());
            $data->sede_id = $request->sede_id['id'];
            if (count($request->ubicacion) > 0)  {
                $data->ubicacion = implode(",", $request->ubicacion);
            }
            if ($data->save()) {
                $answer=array(
                    "code" => 200
                );
            }
            return $answer;
            
        } catch (Exception $e) {
            return $e;
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $data = Salones::findOrFail($id);
        $data->delete();
    }

    public function getAll(){
        $data = DB::table('salones As a')
        ->join('sede AS b', 'a.sede_id', '=', 'b.id')
        ->select(
            'a.id',
            'a.sede_id',
            'a.codigo',
            'a.capacidad',
            'a.ubicacion',
            'b.nombre AS sede'
        )
        ->where('a.deleted_at', '=', NULL)
        ->get();
        return Datatables::of($data)->make(true);
    }

    public function getBySede($sede){
        $data = DB::table('salones As a')
        ->select(
            'a.id',
            'a.sede_id',
            'a.codigo',
            'a.capacidad',
            'a.ubicacion'
        )
        ->where([
            ['a.sede_id', '=', $sede],
            ['a.deleted_at', '=', NULL]
        ])
        ->get();
        return $data;
    }


    public function delete($id,$logical)
    {
        
        if(isset($logical) and $logical == 'true'){
            $data = Salones::findOrFail($id);
            $now = new \DateTime();
            $data->deleted_at =$now->format('Y-m-d H:i:s');
            if($data->save()){
                    $answer=array(
                        "datos" => 'Eliminación exitosa.',
                        "code" => 200
                    ); 
               }  else{
                    $answer=array(
                        "error" => 'Error al intentar Eliminar el registro.',
                        "code" => 600
                    );
               }          
                
                return $answer;
        }else{
            $this->destroy($id);
        }
    }

    public function restaurar($id){
        $data = Salones::findOrFail($id);
        $data->deleted_at = NULL;
        $data->save();
    }

    public function getUbicacion($id){
        $data = Salones::findOrFail($id);
        return json_decode($data->ubicacion);
    }

    public function getAllSede(){
        $sedes = DB::table('sede AS a')
        ->select(
            'a.id',
            'a.nombre'
        )
        ->get();
        return json_encode($sedes);
    }
}
