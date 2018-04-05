<?php

namespace App\Http\Controllers\Estudiante;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;
use App\Estudiante;
use App\NivelAcademico;
use App\EstadoCivil;
use App\HistorialEstudiante;
use JavaScript;

class PerfilController extends Controller
{
    public function index(Request $request){
    	$user = Auth::user();
        $data = DB::table('estudiante AS a')
        ->join('nivel_academico AS b', 'nivel_academico_id', '=', 'b.id')
        ->join('estado_civil AS c', 'estado_civil_id', '=', 'c.id')
        ->join('sede AS d', 'sede_id', '=', 'd.id')
        ->select(
            'a.id',
            'a.nombres', 
            'a.primer_apellido', 
            'a.segundo_apellido',
            'a.direccion',
            'a.tel_fijo',
            'a.tel_movil',
            'a.genero_id',
            'a.num_documento',
            'a.num_libreta',
            'a.ciudad_domicilio',
            'a.barrio_domicilio',
            'a.correo',
            'a.expedicion_documento',
            'a.consecutivo',
            'a.institucion',
            'a.fecha_nacimiento',
            'a.ocupacion',
            'a.estado_civil_id',
            'b.descripcion AS estado_civil',
            'a.nivel_academico_id',
            'c.descripcion AS nivel_academico',
            'd.nombre AS sede'
        )
    	->where([
    		['correo', '=' ,$user->email ],
            ['a.deleted_at', '=' ,NULL ],
            ['b.deleted_at', '=' ,NULL ],
    		['c.deleted_at', '=' ,NULL ]
    	])->get();
        $data = $data[0];
        $nivel_academico = NivelAcademico::select(['id','descripcion'])->where('deleted_at', '=' ,NULL)->get();
        $estado_civil = EstadoCivil::select(['id','descripcion'])->where('deleted_at', '=' ,NULL)->get();
        $finanzas = $this->finanzas();

        JavaScript::put([
            'estudiante_id' => $data->id,
        ]);
        
        return view('templates/estudiante/perfil', compact('data', 'nivel_academico', 'estado_civil', 'finanzas'));   
    }

    public function update(Request $request, $id){
        try {
            $data = Estudiante::findOrFail($id);
            $historial = new HistorialEstudiante;
            $datos_historial = array(
                'Teléfono fijo',
                'Teléfono movil',
                'Dirección',
                'Correo',
                'Número de documento',
            );

            DB::table('historial_estudiante')->insert([
                [
                    'id_estudiante' => $id,
                    'tipo_campo' => $datos_historial[0],
                    'valor' => $data->tel_fijo
                ],
                [
                    'id_estudiante' => $id,
                    'tipo_campo' => $datos_historial[1],
                    'valor' => $data->tel_movil
                ],
                [
                    'id_estudiante' => $id,
                    'tipo_campo' => $datos_historial[2],
                    'valor' => $data->direccion
                ],
                [
                    'id_estudiante' => $id,
                    'tipo_campo' => $datos_historial[3],
                    'valor' => $data->correo
                ],
                [
                    'id_estudiante' => $id,
                    'tipo_campo' => $datos_historial[4],
                    'valor' => $data->num_documento
                ]
            ]);
            $data->update($request->all());
            return redirect()->action('Estudiante\PerfilController@index');
        } catch (Exception $e) {
            return $e;
        }
    }

    public function pagado(){
        $data = DB::table('recibo_caja AS a')
        ->join('recibo_caja_pivot_estudiante AS b', 'a.id', 'b.recibo_caja_id')
        ->join('recibo_caja_detalle AS c', 'a.id', 'c.recibo_caja_id')
        ->select(
            'a.id',
            'descuento',
            'fecha_pago',
            'b.estudiante_id',
             DB::raw('Sum(c.valor) AS valor'),
             DB::raw('(Sum(c.valor) - a.descuento) AS neto')
        )->where([
            ['b.estudiante_id', '=', $this->getId()],
            ['a.deleted_at', '=' ,NULL ],
            ['b.deleted_at', '=' ,NULL ],
            ['c.deleted_at', '=' ,NULL ]
        ])->groupBy([
            'a.id',
            'consecutivo',
            'descuento',
            'fecha_pago',
            'b.estudiante_id'
        ])->get();
        return Datatables::of($data)
        ->editColumn('valor', function($data){
            return  '$ ' . number_format($data->valor, 2);
        })
        ->editColumn('descuento', function($data){
            return  '$ ' . number_format($data->descuento, 2);
        })
        ->editColumn('neto', function($data){
            return  '$ ' . number_format($data->neto, 2);
        })
        ->make(true);
    }
    public function pendiente(){
        $data = DB::table('factura AS a')
        ->join('detalle_factura AS b', 'a.id', 'b.factura_id')
        ->join('estudiante AS c', 'a.estudiante_id', 'c.id')
        ->join('concepto AS d', 'b.concepto_id', 'd.id')
        ->select(
            'a.id',
            'b.fecha_inicio',
            'b.cuota',
            'b.saldo_vencido',
             DB::raw('DATEDIFF(NOW(),(b.fecha_inicio)) AS Dias'),
            'c.consecutivo',
            'd.descripcion'
        )->where([
            ['a.estudiante_id', '=', $this->getId()],
            ['a.deleted_at', '=' ,NULL ],
            ['b.deleted_at', '=' ,NULL ],
            ['c.deleted_at', '=' ,NULL ],
            ['d.deleted_at', '=' ,NULL ]
        ])->get();

        return Datatables::of($data)
        ->editColumn('saldo_vencido', function($data){
            setlocale(LC_MONETARY, 'es_CO');
            return  '$ ' . number_format($data->saldo_vencido, 2);
        })->editColumn('cuota', function($data){
            setlocale(LC_MONETARY, 'es_CO');
            return  '$ ' . number_format($data->cuota, 2);
        })
        ->make(true);
    }
    public function finanzas(){
        $data = DB::table('detalle_factura AS a')
        ->join('factura AS b', 'a.factura_id', 'b.id')
        ->join('estudiante AS c', 'b.estudiante_id', 'c.id')
        ->join('concepto AS d', 'a.concepto_id', 'd.id')
        ->leftJoin('recibo_caja_detalle AS e', 'a.id', 'e.detalle_factura_id')
        ->select(
            'a.id',
            'a.fecha_inicio',
            'a.saldo_vencido',
            'a.cuota',
            'a.observacion',
            'd.descripcion',
            'e.recibo_caja_id',
            'e.valor',
            'e.saldo',
            DB::raw("IF(DATEDIFF(NOW(),a.fecha_inicio) >= 0 AND a.saldo_vencido = 0,0,DATEDIFF(NOW(),a.fecha_inicio)) AS dias")
        )->where([
            ['c.id', '=', $this->getId()],
            ['a.deleted_at', '=' ,NULL ],
            ['b.deleted_at', '=' ,NULL ],
            ['c.deleted_at', '=' ,NULL ],
            ['d.deleted_at', '=' ,NULL ]
        ])->get();

        return $data;
    }
    public function metodosPago(){
        
        return view('templates/estudiante/metodosPago');
    }
    public function getId(){
        $user = Auth::user();
        $data = DB::table('estudiante AS a')
        ->select(
            'a.id',
            'a.consecutivo'
        )
        ->where([
            ['correo', '=' ,$user->email ],
            ['a.deleted_at', '=' ,NULL ]
        ])->get();
        $id = $data[0]->id;
        return $id;
    }

    public function getModulosByEstudiente($estudiante_id){
        $data = DB::table('clases AS a')
        ->join('modulos AS b', 'a.modulo_id', 'b.id')
        ->join('clases_estudiante AS c', 'a.id', 'c.clases_id')
        ->select(
            'b.id',
            'b.nombre'
        )
        ->where([
            ['c.estudiante_id',$estudiante_id],
            ['a.deleted_at',NULL]
        ])
        ->get();
        return \Response::json($data);
    }

    public function asistenciaEstudiente($estudiante_id, $modulo_id){
        // SELECT
        // DATE_FORMAT(a.`start`, '%Y-%m-%d') AS fecha,
        // IFNULL(
        //         (
        //             SELECT
        //                 a.id
        //             FROM
        //                 clases_estudiante_asistencia AS a
        //             LEFT OUTER JOIN clases_detalle AS b ON a.clases_detalle_id = b.id
        //             LEFT OUTER JOIN clases AS c ON b.clases_id = c.id
        //             WHERE
        //                 a.estudiante_id = 754
        //             AND c.modulo_id = 2
        //             AND b.`start` = a.`start`
        //         ),
        //         null
        //     ) AS asistencia
        // FROM
        // clases_detalle AS a
        // INNER JOIN clases AS b ON a.clases_id = b.id
        // INNER JOIN clases_estudiante AS c ON c.clases_id = b.id
        // WHERE
        // b.modulo_id = 2 AND
        // c.estudiante_id = 754

        $data = DB::table('clases_detalle AS a')
        ->join('clases AS b', 'a.clases_id', 'b.id')
        ->join('clases_estudiante AS c', 'c.clases_id', 'b.id')
        ->select(
            DB::raw("DATE_FORMAT(a.`start`, '%Y-%m-%d') AS fecha"),
            DB::raw("IFNULL(
                (
                    SELECT
                        a.id
                    FROM
                        clases_estudiante_asistencia AS a
                    LEFT OUTER JOIN clases_detalle AS b ON a.clases_detalle_id = b.id
                    LEFT OUTER JOIN clases AS c ON b.clases_id = c.id
                    WHERE
                        a.estudiante_id = $estudiante_id
                    AND c.modulo_id = $modulo_id
                    AND b.`start` = a.`start`
                ),
                null
            ) AS asistencia")
        )
        ->where([
            ['c.estudiante_id',$estudiante_id],
            ['b.modulo_id',$modulo_id]
        ])
        ->get();
        return \Response::json($data);
    }

}