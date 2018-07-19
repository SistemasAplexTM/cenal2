<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class LoginController extends Controller
{

    use AuthenticatesUsers;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    // protected $redirectTo = '/clases';
    

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    public function index(){
        return view('auth/login');
    }

    public function redirectPath()
    {
        $user = Auth::user();
        $sede = DB::table('sede AS a')->select('a.nombre')->where('a.id', $user->sede_id )->first();
        \Session::put('sede', $sede->nombre);
        if ($user->hasRole('Estudiante')) {
            return 'estudiante/perfil';   
        }
        return '/grupos';
    }
}
