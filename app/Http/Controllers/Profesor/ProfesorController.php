<?php

namespace App\Http\Controllers\Profesor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Requests\ProfesorRequest;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\DB;
use App\User;
use App\Profesores AS Profesor;

class ProfesorController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $user = User::all();
        return view('templates.profesor.profesor', compact('user'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(ProfesorRequest $request)
    {
        try{
            if (Profesor::insert($request->all())) {
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
    public function update(ProfesorRequest $request, $id)
    {
        try {
            $data = Profesor::findOrFail($id);
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
        $data = Profesor::findOrFail($id);
        $data->delete();
    }

    public function getAll(){
        $data = DB::table('profesores As a')
        ->select(
            'a.id',
            'a.nombre',
            'a.apellidos',
            'a.direccion',
            'a.telefono',
            'a.celular',
            'a.user_id',
            'a.created_at',
            'a.updated_at'
        )
        ->where('a.deleted_at', '=', NULL)
        ->get();
        return Datatables::of($data)->make(true);
    }


    public function delete($id,$logical)
    {
        
        if(isset($logical) and $logical == 'true'){
            $data = Profesor::findOrFail($id);
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
        $data = Profesor::findOrFail($id);
        $data->deleted_at = NULL;
        $data->save();
    }

    public function getDataUser($user){
        if ($user == null) {
            $answer=array(
                "data" => false,
                "code" => 404
            );    
        }
        $data = DB::table('users As a')
        ->select(
            'a.name',
            'a.email'
        )
        ->where('a.id', '=', $user)
        ->get();
        $answer=array(
            "data" => $data,
            "code" => 200
        );
        return $answer;
    }
}
