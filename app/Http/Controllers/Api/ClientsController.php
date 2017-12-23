<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;

class ClientsController extends Controller
{
    public function index(){
    	return view('templates/clients');
    }

    public function getAll(){
    	return view('templates/clients');
    }
}
