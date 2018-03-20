<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;
use App\Programas_unicos;

class ProgramasController extends Controller
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
        $modulo = DB::table('modulos AS a')
        ->select(
            'a.id',
            'a.nombre'
        )->get();
        return view('templates.programas', compact('sede', 'modulo'));
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
                'nombre' => 'required',
                'sedes' => 'required'
            ]);
            $programas_unicos = new Programas_unicos;
            $programas_unicos->nombre = $request->nombre;
            $mod = array();
            if(count($request->modulos) > 0){
                foreach ($request->modulos as $key => $value) {
                    $mod[] = array(
                        'id' => $value['id'],
                        'name' => $value['text'],
                        'duracion' => $value['duracion']
                    );
                }
            }

            $programas_unicos->modulos_json = json_encode($mod);
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
    public function update(Request $request, $id)
    {   
        try {
            $data = Programas_unicos::findOrFail($id);
            $mod = array();
            if(count($request->modulos) > 0){
                foreach ($request->modulos as $key => $value) {
                    $cadena= $value['text'];
                    if (strpos($cadena, '(')) {
                        $parte1=explode('(',$cadena);
                        $parte2=explode(')',$parte1[1]);
                        $parentesis= $parte2[0];
                        $mod[] = array(
                            'id' => $value['id'],
                            'name' => $parte1[0],
                            'duracion' => $parentesis
                        );
                    }else{
                        $mod[] = array(
                            'id' => $value['id'],
                            'name' => $value['text'],
                            'duracion' => $value['duracion']
                        );
                    }

                }
            }
            $data->modulos_json = json_encode($mod);
            $data->nombre = $request->nombre;
            $data->save();
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
        // $data = Programas_unicos::findOrFail($id);
        // $data->delete();
    }

    public function getAll(){
        $data = DB::table('pivot_programas_unicos_programas As a')
        ->join('programas AS b', 'a.id_programa', 'b.id')
        ->join('programas_unicos AS d', 'a.id_prog_unicos', 'd.id')
        ->join('sede AS c', 'b.sede_id', 'c.id')
        ->select(
            'a.id_prog_unicos',
            'd.nombre AS programa',
            'd.modulos_json AS modulos',
            'b.sede_id',
            'c.nombre'
        )
        ->where([['a.deleted_at', '=', NULL],['b.deleted_at', '=', NULL]])
        ->get();
        return Datatables::of($data)->make(true);
    }
    public function geAllBySede($sede){
        $data = DB::table('programas As a')
        ->select(
            'a.id',
            'a.programa'
        )
        ->where([
            ['a.sede_id', '=', $sede],
            ['a.deleted_at', '=', NULL]
        ])
        ->orderBy('a.programa')
        ->get();
        return $data;
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
    public function getAllSedesForSelect(Request $request){
        $term = $request->term ?: '';
        $data = DB::table('sede As a')
        ->select(
            'a.id',
            'a.nombre'
        )
        ->where([
            ['a.nombre', 'LIKE', $term.'%'],
            ['a.deleted_at', '=', NULL]
        ])
        ->get();
        $valid_data = [];
        foreach ($data as $id => $tag) {
            $valid_data[] = ['id' => $tag->id, 'text' => $tag->nombre];
        }
        return \Response::json($valid_data);
    }

    public function delete($id,$logical)
    {
        
        if(isset($logical) and $logical == 'true'){
            $programas = $this->getDataSedesByPrograma($id);
            foreach ($programas as $key => $value) {
                DB::table('programas')->where('id', '=', $value->id_prog_tbl)->delete();
                DB::table('pivot_programas_unicos_programas')->where('id_programa', '=', $value->id_prog_tbl)->delete();
            }
            $data = Programas_unicos::findOrFail($id);
            if($data->delete()){
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
