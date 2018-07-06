<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>Certificado de costos | CENAL</title>
    <style>
	    .container{
	    	font-family: sans-serif;
	    	width: 80%;
	    	margin: 0 auto;
    		margin-top: 15%;
    	}
    	.wrapper{
    	}
    	.center{
    		text-align: center;
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
    	small{
    		font-size: 10px;
    	}
    </style>
</head>
<body>
    <div id="wrapper">
    	<div class="container">
    		<p class="center">
        		<small>
	        		El suscrito Asistente Administrativo del Centro Nacional de Capacitación Laboral- CENAL, en uso de las facultades legales que le confiere el capítulo V del Manual de Convivencia, expide la siguiente constancia, acogida a la resolución de aprobación  No. {{ $data->decreto }}, emanada de la Secretaria de Educación Municipal, actuando en nombre del Ministerio de Educación Nacional.
	        	</small>
    		</p>
			<br>
    		<h2 class="center">HACE CONSTAR QUE:</h2>
    		<p class="center" style="text-align: justify-all !important;">
    			El alumno {{ $data->nombre_full }}, identificado con cédula de ciudadanía No {{ $data->cedula }} y código de matrícula {{ $data->codigo }}; se encuentra cursando el *CICLO II* del programa técnico laboral por competencias en {{ $data->programa }}, aprobado según resolución No. 7630 de 2009 expedida por parte de la Secretaría de Educación Municipal, en jornada {{ $data->jornada }}, en el periodo de febrero a julio de 2018.
    		</p>
    		<br>
    		<p class="center">
    			El ciclo II tiene un saldo de ($160.000) ciento sesenta mil pesos moneda legal vigente.
    		</p>
    		<br>
    		<p>
    			<strong>
    				Consignar en la cuenta corriente 092004423 Banco de Occidente o girar cheque a nombre de INVERSORA PALACIOS / CENAL.
    			</strong>
    		</p>
    		<br>
    		<p>
    			Para constancia se firma en {{ $data->ciudad }} a los {{ $fecha_letras }} ({!! date('j') !!}) días del mes de {{ $mes }} de {!! date('Y') !!}
    		</p>
    		<p>
    			Atentamente,
    		</p>
    		<br>
    		<p>
    			_________________________________________
    			<br>
    			<strong>
    				VANESSA GUAUÑA G.
    			</strong>
    			<br>
				ASISTENTE ADMINISTRATIVO.
				<br>
				<small>
					ESTE CERTIFICADO TIENE VALIDEZ POR UN PERIODO DE 90 DÍAS A PARTIR DE LA FECHA DE EXPEDICION
				</small>

    		</p>
    	</div>
    </div>
</body>
</html>