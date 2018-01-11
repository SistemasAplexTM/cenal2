<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
</head>
<body>
    <h2>Hola {{ $data['name'] }}, gracias por registrarte en <strong>CENAL</strong> !</h2>
    <p>Por favor confirma tu correo electrónico.</p>
    <p>Para ello simplemente debes hacer click en el siguiente enlace:</p>

    <a href="{{ url('/register/verify/' . $data['code']) }}">
        Clic para confirmar tu email
    </a>
</body>
</html>