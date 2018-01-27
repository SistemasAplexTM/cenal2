<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Requests\UbicacionRequest;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\DB;
use App\Ubicacion;

class UbicacionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view('templates.ubicacion');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(UbicacionRequest $request)
    {
        try{
            if (Ubicacion::insert($request->all())) {
                $answer=array(
                    "datos" => $request->all(),
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
    public function update(UbicacionRequest $request, $id)
    {
        try {
            $data = Ubicacion::findOrFail($id);
            $data->update($request->all());
            $answer=array(
                "datos" => $request->all(),
                "code" => 200
            );
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
        $data = Ubicacion::findOrFail($id);
        $data->delete();
    }

    public function getAll(){
        $data = DB::table('ubicacions As a')
        ->select(
            'a.id',
            'a.nombre'
        )
        ->where('a.deleted_at', '=', NULL)
        ->get();
        return Datatables::of($data)->make(true);
    }


    public function delete($id,$logical)
    {
        
        if(isset($logical) and $logical == 'true'){
            $data = Ubicacion::findOrFail($id);
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
        $data = Ubicacion::findOrFail($id);
        $data->deleted_at = NULL;
        $data->save();
    }

    public function getForSelect2(Request  $request){
        $term = $request->term ?: '';
        $tags = Ubicacion::where([['nombre', 'like', $term.'%'],['deleted_at', NULL]])->pluck('nombre', 'id');
        $valid_tags = [];
        foreach ($tags as $id => $tag) {
            $valid_tags[] = ['id' => $id, 'text' => $tag];
        }
        return \Response::json($valid_tags);
        
    }

}
