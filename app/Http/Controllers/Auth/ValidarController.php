<?php

namespace App\Http\Controllers\Auth;

use Mail;
use App\Mail\VerifyEmail;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use App\User;
use Illuminate\Support\Facades\Auth;

class ValidarController extends Controller
{
    public function validar(Request $request){
    	$email = $request->email;
    	$code = $request->code;
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
        	['a.consecutivo', '=', $code]
        ])
        ->get();
        $dataUsers = DB::table('users As a')
        ->select(
            'a.id'
        )
        ->where([
            ['a.code', '=', $code]
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
            $confirmation = str_random(25);
        User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => bcrypt($request->password),
            'confirmation_code' => $confirmation
        ]);
        $data = array(
            'code' => $confirmation,
            'name' => $request->name
        );
        Mail::to($request->email)->send(new VerifyEmail($data));
        return redirect('login');
    }

    public function verify($code)
    {
        $user = User::where('confirmation_code', $code)->first();

        if (!$user){
            return redirect('/');
        }

        $user->confirmed = 1;
        $user->confirmation_code = null;
        $user->save();
        
        return redirect('/login')
        ->with('notification', 'Has confirmado correctamente tu correo!')
        ->with('email', $user->email); 
    }
}
