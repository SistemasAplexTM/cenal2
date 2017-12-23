<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>PDF</title>
    <style>
	    .container{
	    	font-family: sans-serif;
	    	width: 98%;
	    	margin: 0 auto;
    	}
    	.center{
    		text-align: center;
    	}
    	.panel{
    		background-color: white;
    		border: 1px solid #d6d6d6;
    		/*width: 50%;*/
    		/*-webkit-box-shadow: 1px 2px 53px -10px rgba(0,0,0,0.58);
			-moz-box-shadow: 1px 2px 53px -10px rgba(0,0,0,0.58);
			box-shadow: 1px 2px 53px -10px rgba(0,0,0,0.58);*/
			/*-webkit-box-shadow: 0px 0px 31px -6px rgba(0,0,0,0.3);
			-moz-box-shadow: 0px 0px 31px -6px rgba(0,0,0,0.3);
			box-shadow: 0px 0px 31px -6px rgba(0,0,0,0.3);*/
    	}
    	.panel-title{
    		background-color: #4c4c4c;
    		color: white;
    		display: table;
    		width: 100%;
    		height: 30px;
    	}
    	.title{
    		display: table-cell;
    		vertical-align: middle;
    	}
    	.right{
    		width: 60%;
    		float: right;
    		/*margin-right: 4%; */
    	}
    	.left{
    		width: 38%;
    		/*margin-left: 4%; */
    	}
    	#barra{
    		background-color: #ffdb3d;
    		padding: 1px 0px 1px 0px;
    	}
    	#titulo{
    		margin: 7px;
    	}
    	#img{
    		margin: 30px;
    	}
    	table{
    		width: 100%;
    		/*border: 1px solid #d6d6d6;*/
    		border-collapse: collapse;
    		text-align: center;
    	}
    	th, td{
    		/*border: 1px solid #d6d6d6;*/
    		height: 30px;
    	}
    	ul{
    		margin: 4;
		    padding: 0;
		    list-style-type: none;
    	}
    	ul li{
    		text-align: left;
    		/*margin-le: 10px;*/
    		padding: 8px;
    		border-bottom: 1px solid #d6d6d6;
    	}
    </style>
</head>
<body  class="top-navigation skin-1">
    <div id="wrapper">            
        <div id="page-wrapper" class="gray-bg">
        	<br>
        	<div class="container center">
        		<img src="{{ asset('img/baloto.png') }}" alt="" width="180px" id="img">
        		<div id="barra">
					<h2 id="titulo">Pago con Baloto</h2>
        		</div>
        		<h2>Código de pago: <strong>95 95 95 64 67</strong>.</h2>
        		<p>Con ese código puede realizar el pago en la plataforma de baloto.</p>
        		<div class="panel right" >
        			<div class="panel-title">
        				<div class="title">
        					Valor a pagar
        				</div>
        			</div>
        			<div class="panel-content">
						<table class="">
	                        <thead>
	                            <tr>
	                                <th>Concepto</th>
	                                <th>Fecha</th>
	                                <th>Días</th>
	                                <th>Valor</th>
	                            </tr>
	                        </thead>
	                        <tbody>
                                @foreach($mora as $val)
                                <tr>
                                    <td>{{ $val->descripcion }}</td>
                                    <td>{{ $val->fecha_inicio }}</td>
                                    <td>{{ $val->dias }}</td>
                                    <td>$ {!! number_format($val->saldo_vencido, 2) !!}</td>
                                </tr>
                            @endforeach
	                        </tbody>
	                    </table>
        			</div>
        		</div>
        		<div class="panel left">
        			<div class="panel-title">
        				<div class="title">
        					Datos del estudiante
        				</div>
        			</div>
        			<div class="panel-content">
						<ul class="list-group text-left">
	                        <li class="list-group-item">
	                            <strong>
	                                Código:
	                            </strong>
	                            {{ $mora[0]->consecutivo }}
	                        </li>
	                        <li class="list-group-item">
	                            <strong>
	                                Nombre:
	                            </strong>
	                            {{ Auth::user()->name }}
	                        </li>
	                        <li class="list-group-item">
	                            <strong>
	                                Correo:
	                            </strong>
	                            {{ Auth::user()->email }}
	                        </li>
	                    </ul>
        			</div>
        		</div>
        	</div>
        </div>
    </div>
</body>
</html>