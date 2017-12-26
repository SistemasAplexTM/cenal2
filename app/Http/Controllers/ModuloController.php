<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\DB;
use App\Modulos;

class ModuloController extends Controller
{
    public function index(){
    	return view('templates\modulo');
    }

    public function getAll(){
    	$data = DB::table('modulos As a')
        ->select(
            'a.id',
            'a.nombre',
            'a.created_at',
            'a.updated_at'
        )
        ->where('a.deleted_at', '=', NULL)
        ->get();
    	return Datatables::of($data)->make(true);
    }

    public function store(Request $request){
    	try{
            if (Modulos::insert($request->all())) {
                $answer=array(
                    "datos" => '',
                    "code" => 200
                );
            }
            return $answer;
        } catch (Exception $e) {
            return $e;
        }
    }

    public function update(Request $request, $id){
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
}
