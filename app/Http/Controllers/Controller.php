<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Support\Facades\Auth;
use JavaScript;


class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    public function info_user(){
    	$user = Auth::user();
    	JavaScript::put([
            'user' => $user,
            'roles' => $user->getRoleNames(),
            'permissions' => $user->permissions
        ]);
    }
    public function get_user($param = null){
    	if ($param == null) {
            return Auth::user();
        }else{
            return Auth::user()->$param;
        }
    }

}
