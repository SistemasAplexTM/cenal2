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
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function addModules(Request $request, $id)
    {
        try{
            $modulos_programas = $this->getDataModulosByPrograma($id);
            $resultado = array();
            foreach ($modulos_programas as $key => $value) {
                $resultado[$key] = $value->id_modulo;
            }
            $modulos_request = $request->modulos;
            if (count($resultado) > 0) {
                if (count($resultado) > count($modulos_request)) {
                    $result = array_diff($resultado, $modulos_request);
                    $result2 = array_diff($modulos_request, $resultado);
                    foreach ($result as $valueDelete) {
                        DB::table('pivot_programas_unicos_modulos')->where('id_modulo', '=', $valueDelete)->delete();
                    }
                    foreach ($result2 as $key => $valueInsert) {
                        DB::table('pivot_programas_unicos_modulos')->insertGetId(
                            ['id_prog_unicos' => $id, 'id_modulo' => $valueInsert]
                        );
                    }
                    // echo '<pre>';
                    // echo 'La bd es mayor que el request';
                    // echo 'BD = ' . count($resultado) . ' Request = ' . count($modulos_request);
                    // echo 'Request';
                    // print_r($modulos_request);
                    // echo '<br>';
                    // echo 'BD';
                    // print_r($resultado);
                    // echo 'Diferencia';
                    // print_r($result);
                    // echo 'Result 2';
                    // print_r($result2);
                    // echo 'Eliminar';
                }else{
                    $result = array_diff($modulos_request, $resultado);
                    $result2 = array_diff($resultado, $modulos_request);
                    foreach ($result2 as $valueDelete) {
                        DB::table('pivot_programas_unicos_modulos')->where('id_modulo', '=', $valueDelete)->delete();
                    }
                    foreach ($result as $key => $valueInsert) {
                        DB::table('pivot_programas_unicos_modulos')->insertGetId(
                            ['id_prog_unicos' => $id, 'id_modulo' => $valueInsert]
                        );
                    }
                    // echo '<pre>';
                    // echo 'El request es mayor que la bd';
                    // echo 'BD = ' . count($resultado) . ' Request = ' . count($modulos_request);
                    // echo 'Request';
                    // print_r($modulos_request);
                    // echo '<br>';
                    // echo 'BD';
                    // print_r($resultado);
                    // echo 'Diferencia';
                    // print_r($result);
                    // echo 'Result 2';
                    // print_r($result2);
                    // echo '</pre>';
                    // echo 'Agregar';
                }
                // exit();
                // return $result;
            }
            
             $validatedData = $request->validate([
                'nombre' => 'required'
            ]);
            $programas_unicos = Programas_unicos::findOrFail($id);
            $programas_unicos->nombre = $request->nombre;
            $programas_unicos->save();
            // $idPrograma = $programas_unicos->id;
            // $modulos = $request->modulos;
            
            // if (count($modulos) > 0) {
            //     foreach ($modulos as $key => $value) {
            //         DB::table('pivot_programas_unicos_modulos')
            //         ->insertGetId(
            //             ['id_prog_unicos' => $idPrograma, 'id_modulo' => $value]
            //         );
            //     }
            // }
            $answer=array(
                "datos" => $request->all(),
                "code" => 200
            );
            return $answer;
        } catch (Exception $e) {
            return $e;
        }
    }

    // /**
    //  * Update the specified resource in storage.
    //  *
    //  * @param  \Illuminate\Http\Request  $request
    //  * @param  int  $id
    //  * @return \Illuminate\Http\Response
    //  */
    // public function updateModules(Request $request, $id)
    // {
    //     try {
            
    //         $data = Programas_unicos::findOrFail($id);
    //         $data->update($request->all());
    //         $answer=array(
    //             "datos" => $request->all(),
    //             "code" => 200
    //         );
    //         return $answer;
            
    //     } catch (Exception $e) {
    //         return $e;
    //     }
    // }

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
            'b.sede_id',
            'c.nombre'
        )
        ->where([['a.deleted_at', '=', NULL],['b.deleted_at', '=', NULL]])
        ->get();
        return Datatables::of($data)->make(true);
    }

    public function getDataModulosByPrograma($id_programa){
        $data = DB::table('pivot_programas_unicos_modulos As a')
        ->select(
            'a.id_modulo'
        )
        ->where([['a.deleted_at', '=', NULL],
                ['a.id_prog_unicos', '=', $id_programa]
                ])
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
