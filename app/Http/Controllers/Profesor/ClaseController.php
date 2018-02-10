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
    public function getAll(){
       
    }
}
