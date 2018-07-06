<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>Certificado de notas | CENAL</title>
    <style>
	    .container{
	    	font-family: sans-serif;
	    	width: 80%;
	    	margin: 0 auto;
    		margin-top: 15%;
    	}
    	.center{
    		text-align: center;
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
    		<p class="center">
                La alumna {{ $data->nombre_full }}, identificada con cédula de ciudadanía No. {{ $data->cedula }} y código de matrícula {{ $data->codigo }}; se encuentra cursando el ciclo I del programa técnico laboral por competencias laborales en {{ $data->programa }}, aprobado según resolución No. 2184 del 2015 expedida por parte de la Secretaría de Educación Municipal. En jornada {{ $data->jornada }} con una intensidad de 20 horas semanales. En el periodo de enero a junio de 2018.
    		</p>
            <br>
            <p>
                Obteniendo las siguientes competencias laborales:
            </p>
            <br>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Módulo</th>
                        <th>Nota</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Office</td>
                        <td>5.0</td>
                    </tr>
                </tbody>
            </table>
            <p>
                Para constancia se firma en {{ $data->ciudad }} a los {{ $fecha_letras }} ({!! date('j') !!}) días del mes de {{ $mes }} de {!! date('Y') !!}
            </p>
    		<br>
    		<p>
    			Atentamente,
    		</p>
            <br>
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