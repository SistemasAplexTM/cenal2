<?php

namespace App\Http\Controllers\Profesor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class ClasesController extends Controller
{
    public function index(){
    	return view('templates\profesor\clases');
    }
}
