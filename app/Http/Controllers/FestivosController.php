<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\DB;
use App\Http\Requests\FestivosRequest;
use App\Festivos;

class FestivosController extends Controller
{
    public function index(){
        return view('templates\festivos');
    }

    public function getAll(){
        $data = DB::table('festivos As a')
        ->select(
            'a.id',
            'a.año',
            'a.dia_festivo'
        )
        ->where('a.deleted_at', '=', NULL)
        ->get();
        return Datatables::of($data)->make(true);
    }

    public function store(FestivosRequest $request){
        try{
            if (Festivos::insert($request->all())) {
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

    public function update(FestivosRequest $request, $id){
        try {
            $data = Festivos::findOrFail($id);
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
            $data = Festivos::findOrFail($id);
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
        $data = Festivos::findOrFail($id);
        $data->delete();
    }

    public function restaurar($id){
        $data = Festivos::findOrFail($id);
        $data->deleted_at = NULL;
        $data->save();
    }
}