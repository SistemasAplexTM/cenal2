<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class MoraMiddleware
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
        if(Auth::user()->rol == 0){
            $email = Auth::user()->email;
            $data = DB::table('estudiante AS a')
            ->select(
                'a.id',
                'a.consecutivo'
            )
            ->where([
                ['correo', '=' ,$email ],
                ['a.deleted_at', '=' ,NULL ]
            ])->get();
            $id = $data[0]->id;
            if(count($data) > 0){
                $cartera = DB::table('factura AS a')
                ->join('detalle_factura AS b', 'a.id', 'b.factura_id')
                ->join('estudiante AS c', 'a.estudiante_id', 'c.id')
                ->join('concepto AS d', 'b.concepto_id', 'd.id')
                ->select(
                     DB::raw('DATEDIFF(NOW(),(b.fecha_inicio)) AS dias')
                )->where([
                    ['a.estudiante_id', '=', $id],
                    ['b.saldo_vencido', '>', 0],
                    [ DB::raw('DATEDIFF(NOW(),(b.fecha_inicio))'), '>=', 0],
                    ['a.deleted_at', '=' ,NULL ],
                    ['b.deleted_at', '=' ,NULL ],
                    ['c.deleted_at', '=' ,NULL ],
                    ['d.deleted_at', '=' ,NULL ]
                ])
                ->orderBy('dias', 'ASC')
                ->get();
                // abort(403, 'acá vamos' . $cartera);
                if (count($cartera) > 0) {
                    foreach ($cartera as $key => $val) {
                        if ($val->dias >= 0 && $val->dias <= 5) {
                            // return redirect('/perfil')->with('mora', 'true'); 
                            // return true;
                        }else{
                            return redirect('/mora');
                        }
                    }
                }else{
                    // return true;
                }
            }
        }else{
            return redirect('/error/403');
        }

        return $next($request);
    }
}
