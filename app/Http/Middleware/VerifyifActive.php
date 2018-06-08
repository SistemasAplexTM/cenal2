<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class VerifyifActive
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        if (!Auth::guest()) {
            if (Auth::user()->confirmed == 0) {
                Auth::logout();
                return redirect('login')->with('notification', 'Debe activar su cuenta para poder acceder.');
            }
            if (Auth::user()->activo != 0) {
                Auth::logout();
                return redirect('login')->with('notification', 'Su cuenta se encuentra incativa, contacte a un administrador.');
            }
        }
        return $next($request);
    }
}
