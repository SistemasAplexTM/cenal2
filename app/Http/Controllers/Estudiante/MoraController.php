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
        return view('templates.estudiante.mora', compact('mora')); 
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

    public function costos_certificado($id) 
    {
        setlocale(LC_TIME, "es");
        $mes = strftime("%B");
        $fecha_letras = \NumeroALetras::convertir(date('j'));
        $data = $this->getDataForImpress($id);
        $view =  \View::make('templates.estudiante.pdf-costos', compact('data', 'fecha_letras', 'mes'))->render();
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML($view);
        return $pdf->stream('costos.pdf');
    }

    public function eps_certificado($id) 
    {
        setlocale(LC_TIME, "es");
        $mes = strftime("%B");
        $fecha_letras = \NumeroALetras::convertir(date('j'));
        $data = $this->getDataForImpress($id);
        $view =  \View::make('templates.estudiante.pdf-eps', compact('data', 'fecha_letras', 'mes'))->render();
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML($view);
        return $pdf->stream('eps.pdf');
    }

    public function notas_certificado($id) 
    {
        setlocale(LC_TIME, "es");
        $mes = strftime("%B");
        $fecha_letras = \NumeroALetras::convertir(date('j'));
        $data = $this->getDataForImpress($id);
        $view =  \View::make('templates.estudiante.pdf-notas', compact('data', 'fecha_letras', 'mes'))->render();
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML($view);
        return $pdf->stream('eps.pdf');
    }

    public function baloto() 
    {
        $mora = $this->mora();
        $view =  \View::make('templates.estudiante.pdf-baloto', compact('mora'))->render();
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML($view);
        return $pdf->download('baloto.pdf');
    }

    public function getDataForImpress($id){
        $data = DB::table('estudiante AS a')
        ->join('programas AS b', 'a.programas_id', 'b.id')
        ->join('jornadas AS c', 'a.jornadas_id', 'c.id')
        ->join('sede AS d', 'a.sede_id', 'd.id')
        ->select(
            'a.nombres AS nombre_full',
            'a.num_documento AS cedula',
            'a.consecutivo AS codigo',
            'b.programa',
            'c.jornada',
            'd.ciudad',
            'd.decreto'
        )
        ->where('a.id', $id)
        ->first();
        return $data;
    }

}