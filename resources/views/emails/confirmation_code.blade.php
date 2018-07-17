<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
</head>
<body>
    <h2>Estimado(a) <strong>{{ $data['name'] }}</strong>, te damos la bienvenida a nuestra familia <strong>CENAL</strong>.</h2>

	<p>
		Tus datos de acceso a nuestro portal son:
		Usuario: {{ $data['correo'] }}
		Clave: {{ $data['password'] }}
	</p>
	

    <p>Debes confirmar tu correo electrónico, para ello debes hacer click en el siguiente enlace:</p>

    <a href="{{ url('/register/verify/' . $data['code']) }}">
        Clic para confirmar tu email
    </a>
</body>
</html>