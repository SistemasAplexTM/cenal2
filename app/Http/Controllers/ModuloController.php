<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\DB;
use App\Modulos;

class ModuloController extends Controller
{
    public function index(){
    	return view('templates\modulo');
    }

    public function getAll(){
    	$data = DB::table('modulos As a')
        ->select(
            'a.id',
            'a.nombre',
            'a.created_at',
            'a.updated_at'
        )
        // ->where('a.deleted_at', '=', NULL)
        ->get();
    	return Datatables::of($data)->make(true);
    }

    public function store(Request $request){
    	Modulos::insert($request->all());
    }
}
