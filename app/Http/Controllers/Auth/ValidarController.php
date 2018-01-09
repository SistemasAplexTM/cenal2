<?php

namespace App\Http\Controllers\Auth;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use App\User;

class ValidarController extends Controller
{
    public function validar(Request $request){
    	$email = $request->email;
    	$documento = $request->documento;
    	$data = DB::table('estudiante As a')
        ->select(
            'a.id',
            'a.correo',
            'a.num_documento',
            'a.nombres',
            'a.primer_apellido',
            'a.segundo_apellido',
            'a.direccion',
            'a.tel_fijo',
            'a.tel_movil'
        )
        ->where([
        	['a.num_documento', '=', $documento]
        ])
        ->get();
        $dataUsers = DB::table('users As a')
        ->select(
            'a.id'
        )
        ->where([
            ['a.document', '=', $documento]
        ])
        ->get();
        if (count($dataUsers) > 0) {
            \Session::flash('si_cuenta', "Ya tienes una cuenta");
            return \Redirect::route('login');
        }else{
            if (count($data) > 0) {
               return view('Auth/register2', compact('data'));
            }else{
                \Session::flash('no_cuenta', "No tienes una cuenta");
                return \Redirect::back();    
                // return redirect('register')
                //         ->withErrors(['No existe la cuenta.']);
            }
        }
    }

    public function register2(Request $request){
        DB::table('estudiante')
            ->where('id', $request->id)
            ->update([
                'nombres' => $request->name,
                'primer_apellido' => $request->primer_apellido,
                'segundo_apellido' => $request->segundo_apellido,
                'direccion' => $request->direccion,
                'tel_fijo' => $request->tel_fijo,
                'tel_movil' => $request->tel_movil,
            ]);
        User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => bcrypt($request->password),
        ]);
        return redirect('login');
    }
}
