<?php

namespace App\Http\Controllers\Estudiante;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class MoraController extends Controller
{
    public function index(){
    	$mora = $this->mora();  
        return view('templates/estudiante/mora', compact('mora')); 
    }
    public function mora(){
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
            $mora = DB::table('factura AS a')
            ->join('detalle_factura AS b', 'a.id', 'b.factura_id')
            ->join('estudiante AS c', 'a.estudiante_id', 'c.id')
            ->join('concepto AS d', 'b.concepto_id', 'd.id')
            ->select(
                 DB::raw('DATEDIFF(NOW(),(b.fecha_inicio)) AS dias'),
                 'c.consecutivo',
                 'b.saldo_vencido',
                 'b.fecha_inicio',
                 'd.descripcion'
            )->where([
                ['a.estudiante_id', '=', $id],
                ['b.saldo_vencido', '>', 0],
                [DB::raw('DATEDIFF(NOW(),(b.fecha_inicio))'), '>=', 0],
                ['a.deleted_at', '=' ,NULL ],
                ['b.deleted_at', '=' ,NULL ],
                ['c.deleted_at', '=' ,NULL ],
                ['d.deleted_at', '=' ,NULL ]
            ])->get();
        }
        return $mora;
    }

    public function baloto() 
    {
        $mora = $this->mora();
        $view =  \View::make('templates.estudiante.pdf-baloto', compact('mora'))->render();
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML($view);
        return $pdf->download('baloto.pdf');
    }
}