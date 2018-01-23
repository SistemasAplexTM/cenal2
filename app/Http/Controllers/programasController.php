<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;
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
             $validatedData = $request->validate([
                'nombre' => 'required'
            ]);
            $programas_unicos = new Programas_unicos;
            $programas_unicos->nombre = $request->nombre;
            $programas_unicos->save();
            $idPrograma = $programas_unicos->id;
            $sedes = $request->sedes;
            
            if (count($sedes) > 0) {
                foreach ($sedes as $key => $value) {
                    $ids[$key] = DB::table('programas')
                    ->insertGetId(
                        ['sede_id' => $value, 'descripcion' => $request->nombre, 'programa' => $request->nombre]
                    );
                }
                foreach ($ids as $value_ids) {
                    $ids[$key] = DB::table('pivot_programas_unicos_programas')
                    ->insertGetId(
                        ['id_prog_unicos' => $idPrograma, 'id_programa' => $value_ids]
                    );
                }
            }
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
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(SalonRequest $request, $id)
    {
        // try {
        //     $data = Salones::findOrFail($id);
        //     $data->update($request->all());
        //     $answer=array(
        //         "datos" => $request->all(),
        //         "code" => 200
        //     );
        //     return $answer;
            
        // } catch (Exception $e) {
        //     return $e;
        // }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        // $data = Programas_unicos::findOrFail($id);
        // $data->delete();
    }

    public function getAll(){
        // $data = DB::table('programas As a')
        // ->join('sede AS b', 'a.sede_id', 'b.id')
        // ->select(
        //     'a.id',
        //     'a.programa',
        //     'a.sede_id',
        //     'b.nombre'
        // )
        $data = DB::table('pivot_programas_unicos_programas As a')
        ->join('programas AS b', 'a.id_programa', 'b.id')
        ->join('sede AS c', 'b.sede_id', 'c.id')
        ->select(
            'a.id_prog_unicos',
            'b.programa',
            'b.sede_id',
            'c.nombre'
        )
        ->where([['a.deleted_at', '=', NULL],['b.deleted_at', '=', NULL]])
        ->get();
        return Datatables::of($data)->make(true);
    }

    public function getDataSedesByPrograma($id_programa){
        $data = DB::table('pivot_programas_unicos_programas As a')
        ->join('programas AS b', 'a.id_programa', 'b.id')
        ->select(
            'a.id',
            'b.id AS id_prog_tbl',
            'b.sede_id'
        )
        ->where([['a.deleted_at', '=', NULL],['b.deleted_at', '=', NULL],
                ['a.id_prog_unicos', '=', $id_programa]
                ])
        ->get();
        return $data;
    }


    public function delete($id,$logical)
    {
        
        if(isset($logical) and $logical == 'true'){
            $programas = $this->getDataSedesByPrograma($id);
            foreach ($programas as $key => $value) {
                // echo $value->id_prog_tbl . '<br>';
                DB::table('programas')->where('id', '=', $value->id_prog_tbl)->delete();
            }
            $data = Programas_unicos::findOrFail($id);
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
}