<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\DB;
use App\Http\Requests\UserRequest;
use App\User;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $roles = DB::table('roles As a')
        ->select(
            'a.id',
            'a.name'
        )
        ->where('a.deleted_at', NULL)
        ->get();
        $sedes = DB::table('sede AS a')
        ->select(
            'a.id',
            'a.nombre'
        )
        ->where('a.deleted_at', '=', null)
        ->get();
        return view('templates.user', compact('roles', 'sedes'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(UserRequest $request)
    {
        // return $request->all();
        // exit();
        try{
            $user = User::create([
                'identification_card' => $request->identification_card,
                'name' => $request->name,
                'last_name' => $request->last_name,
                'email' => $request->email,
                'address' => $request->address,
                'phone' => $request->phone,
                'cellphone' => $request->cellphone,
                'sede_id' => $request->sede_id['id'],
                'password' => bcrypt($request->identification_card)
            ]);
            $user->assignRole($request->roles['id']);
            
            return array('code' => 200);
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
            $data = User::findOrFail($id);
            $data->update([
                'identification_card' => $request->identification_card,
                'name' => $request->name,
                'last_name' => $request->last_name,
                'email' => $request->email,
                'address' => $request->address,
                'phone' => $request->phone,
                'cellphone' => $request->cellphone,
                'sede_id' => $request->sede_id['id'],
                'password' => bcrypt($request->identification_card)
            ]);
            DB::table('model_has_roles')->where('model_id', '=', $data->id)->delete();
            $data->assignRole($request->roles['id']);
            $answer=array(
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
        //
    }

    public function delete($id,$logical)
    {
        
        if(isset($logical) and $logical == 'true'){
            $data = User::findOrFail($id);
            $now = new \DateTime();
            $data->deleted_at =$now->format('Y-m-d H:i:s');
            if($data->save()){
                    $answer=array(
                        "datos" => 'Eliminacion exitosa.',
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

    public function getAll(){
        $data = DB::table('users As a')
        ->leftJoin('model_has_roles AS b', 'a.id', 'b.model_id')
        ->leftJoin('roles AS c', 'b.role_id', 'c.id')
        ->join('sede AS d', 'a.sede_id', 'd.id')
        ->select(
            'a.id',
            DB::raw("concat_ws(' ', a.name,last_name) AS nombre"),
            'a.identification_card',
            'a.name',
            'a.last_name',
            'a.email',
            'a.address',
            'a.phone',
            'a.cellphone',
            'a.activo',
            'c.id AS rol_id',
            'c.name AS rol',
            'a.sede_id',
            'd.nombre AS sede'
        )
        ->where([
            ['a.name','<>', 'Administrador'],
            ['a.code', NULL],
            ['a.deleted_at', '=', NULL]
        ])
        ->get();
        return Datatables::of($data)->make(true);
    }

    public function getUsersByRol($rol)
    {
        $data = DB::table('users As a')
        ->join('model_has_roles AS b', 'a.id', 'b.model_id')
        ->join('roles AS c', 'b.role_id', 'c.id')
            ->select(
                'a.id',
                'a.name',
                'a.last_name',
                'a.email'
            )
            ->where([
                ['c.name', '=', $rol],
                ['a.deleted_at', '=', null]
            ])
            ->get();
        return $data;
    }

    public function getRolesForSelect2(Request  $request){
        $term = $request->term ? : '';
        $tags = DB::table('roles As a')
        ->select(
            'a.id',
            'a.name'
        )
        ->where([['a.name', 'like', $term.'%'],['a.deleted_at', NULL]])
        ->get();
        // return $tags;
        $valid_tags = [];
        foreach ($tags as $id => $tag) {
            $valid_tags[] = ['id' => $tag->id, 'text' => $tag->name];
        }
        return \Response::json($valid_tags);
    }
    public function change_state(Request $request){
        
        DB::table('users')
        ->where('id', '=', $request->user)
        ->update(
            ['activo' => $request->action]
        );
        $answer = array('code' => 200);
        return $answer;
    }
}
