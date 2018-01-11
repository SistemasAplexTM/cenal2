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
                return redirect('login')->with('VerifyifActive', 'Debe activar su cuenta para poder acceder.');
            }
        }
        return $next($request);
    }
}
