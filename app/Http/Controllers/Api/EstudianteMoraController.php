<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class EstudianteMoraController extends Controller
{
    public function verifyIfMora($code = null){
		try {
			if($code == null){
				return \Response::json(['message' => 'Debe envíar un código'], 500);
			}
			$result = DB::table('estudiante AS a')
			->select(
				DB::raw('COUNT(a.id) AS cant')
			)
			->where([
	            ['a.consecutivo', '=' , $code ],
	            ['a.deleted_at', '=' ,NULL ]
	        ])->get();
	        if ($result[0]->cant > 0) {
				$answer = DB::table('factura AS a')
				->join('detalle_factura AS b', 'a.id', 'b.factura_id')
				->join('estudiante AS c', 'a.estudiante_id', 'c.id')
		        ->select(
		            "a.id",
					"a.estudiante_id",
					"b.fecha_inicio",
					"b.cuota",
					"b.saldo_vencido",
					DB::raw('DATEDIFF(NOW(),(b.fecha_inicio)) AS dias'),
					"c.consecutivo"
		        )
		        ->where([
		            ['c.consecutivo', '=' , $code ],
		            ['b.saldo_vencido', '>' , 0 ],
		            [DB::raw('DATEDIFF(NOW(),(b.fecha_inicio))'), '>', 0],
		            ['a.deleted_at', '=' ,NULL ]
		        ])->get();
				if (count($answer) > 0 ) {
					// return response()->json('No está al día');
					return \Response::json(['message' => '401'], 200);
				}else{
					return \Response::json(['message' => '200'], 200);
				}
	        }else{
				return \Response::json(['message' => '404']);
	        }
		} catch (Exception $e) {
			
		}
    }
}
