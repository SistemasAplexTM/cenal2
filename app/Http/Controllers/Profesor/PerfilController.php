<?php

namespace App\Http\Controllers\Profesor;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class PerfilController extends Controller
{
    public function index(){
    	return view('templates/profesor/perfil');
    }
}
