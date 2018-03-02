<?php

namespace App\Http\Controllers\Profesor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class ClasesController extends Controller
{
    public function index(){
    	return view('templates.profesor.clases');
    }
      
    public function getAll($profesor_id)
    {
        $data = DB::table('clases As a')
            ->join('clases_detalle AS b', 'a.id', 'b.clases_id')
            ->select(
                'a.id',
                'b.title',
				'b.start',
				'b.end',
				'b.all_day',
				'b.color',
				'b.estado_id'
            )
            ->where([
                ['a.profesor_id', '=', $profesor_id],
                ['a.deleted_at', '=', null]
            ])
            ->get();
        return $data;
    }
}
