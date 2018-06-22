<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\DB;
use App\Http\Requests\ModuloRequest;
use App\Modulos;

class ModuloController extends Controller
{
    public function index(){
    	return view('templates.modulo');
    }

    public function getAll($type){
        $op = '=';
        if ($type == 'b') {
            $op = '<>';
        }
        $data = DB::table('modulos As a')
        ->select(
            'a.id',
            'a.nombre',
            'a.duracion',
            'a.color',
            'a.created_at',
            'a.updated_at'
        )
        ->where('a.deleted_at',  $op , NULL)
        ->get();
        return Datatables::of($data)->make(true);
    }

    public function store(ModuloRequest $request){
    	try{
            if (Modulos::insert($request->all())) {
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

    public function update(ModuloRequest $request, $id){
        try {
            $data = Modulos::findOrFail($id);
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

    public function updateCell(Request $request){
    	try {
            $obj = $request->obj;
            $data = Modulos::findOrFail($obj['id']);
            $data->update($obj);
            $answer=array(
                "code" => 200
            );
            return $answer;
            
        } catch (Exception $e) {
            return $e;
        }
    }

    public function delete($id,$logical)
    {
        
        if(isset($logical) and $logical == 'true'){
            $data = Modulos::findOrFail($id);
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
    
    public function destroy($id){
        $data = Modulos::findOrFail($id);
        $data->delete();
    }

    public function restaurar($id){
        $data = Modulos::findOrFail($id);
        $data->deleted_at = NULL;
        $data->save();
    }

    public function getByPrograma($programa, $jornada){
        
        $data = DB::table('pivot_promarma_modulos_jornada AS a')
        ->join('modulos AS b','b.id', 'a.modulo_id')
        ->select(
            'b.id',
            'b.nombre',
            'a.duracion'
        )
        ->where([
            ['a.programa_id', $programa],
            ['a.jornada_id', $jornada]
        ])
        ->get();
        
        return $data;
    }

    // public function getByPrograma($programa){
    //     $data = DB::table('pivot_programas_unicos_programas AS a')
    //     ->join('programas_unicos AS b', 'a.id_prog_unicos', 'b.id')
    //     ->select(
    //         'b.modulos_json'
    //     )
    //     ->where('a.id_programa', '=', $programa)
    //     ->first();
        
    //     return (isset($data->modulos_json) ? $data->modulos_json : null);
    // }

    public function getAllForSelect(Request $request){
        $term = $request->term ?: '';
        $data = DB::table('modulos As a')
        ->select(
            'a.id',
            'a.nombre AS name',
            'a.duracion'
        )
        ->where([
            ['a.nombre', 'LIKE', $term.'%'],
            ['a.deleted_at', '=', NULL]
        ])
        ->get();
        $answer = array(
            'code' => 200,
            'items' => $data
        );
        return \Response::json($answer);
    }
}