<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no">
    <meta name="mobile-web-app-capable" content=yes>
    <link rel="icon" sizes="192x192" href="{{ asset('img/logo_cenal.png') }}">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>CENAL</title>

    <!-- Styles -->
    <link href="{{ asset('font-awesome/css/font-awesome.min.css') }}" rel="stylesheet">
    <link href="{{ asset('css/plantilla.css') }}" rel="stylesheet">
</head>
<body class="gray-bg">
    <div class="animated fadeInDown">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox">
                        <div class="ibox-title">
                            <h5>Registro</h5>
                        </div>
                        <div class="ibox-content">
                            <h2>
                                Registro plataforma CENAL
                            </h2>
                            <p>
                                Completa los campos para realizar el registro.
                            </p>

                            <form id="form" action="{{ url('validar/register') }}" method="POST" class="wizard-big">
                                {{ csrf_field() }}
                                <input value="{{ $data[0]->id }}" name="id" style="display: none">
                                <h1>Contacto</h1>
                                <fieldset>
                                    <h2>Información de contacto</h2>
                                    <div class="row">
                                        <div class="col-lg-6">
                                            <div class="form-group">
                                                <label>Nombres *</label>
                                                <input id="name" name="name" type="text" class="form-control required" value="{{ $data[0]->nombres }}">
                                            </div>
                                            <div class="form-group">
                                                <label>Primer apellido *</label>
                                                <input id="primer_apellido" name="primer_apellido" type="text" class="form-control required" value="{{ $data[0]->primer_apellido }}">
                                            </div>
                                            <div class="form-group">
                                                <label>Segundo apellido *</label>
                                                <input id="segundo_apellido" name="segundo_apellido" type="text" class="form-control required" value="{{ $data[0]->segundo_apellido }}">
                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <div class="form-group">
                                                <label>Dirección *</label>
                                                <input id="direccion" name="direccion" type="text" class="form-control required" value="{{ $data[0]->direccion }}">
                                            </div>
                                            <div class="form-group">
                                                <label>Teléfono fijo</label>
                                                <input id="tel_fijo" name="tel_fijo" type="text" class="form-control" value="{{ $data[0]->tel_fijo }}">
                                            </div>
                                            <div class="form-group">
                                                <label>Teléfono movil*</label>
                                                <input id="tel_movil" name="tel_movil" type="text" class="form-control required" value="{{ $data[0]->tel_movil }}">
                                            </div>
                                        </div>
                                    </div>
                                    

                                </fieldset>
                                <h1>Acceso</h1>
                                <fieldset>
                                    <h2>Información de acceso</h2>
                                    <div class="row">
                                        <div class="col-lg-8">
                                            <div class="form-group">
                                                <label>Correo *</label>
                                                <input id="email" name="email" type="text" class="form-control required email" value="{{ $data[0]->correo }}">
                                            </div>
                                            <div class="form-group">
                                                <label>Contraseña *</label>
                                                <input id="password" name="password" type="password" class="form-control required">
                                            </div>
                                            <div class="form-group">
                                                <label>Confirmar contraseña *</label>
                                                <input id="confirm" name="confirm" type="password" class="form-control required">
                                            </div>
                                        </div>
                                        <div class="col-lg-4">
                                            <div class="text-center">
                                                <div style="margin-top: 20px">
                                                    <i class="fa fa-sign-in" style="font-size: 180px;color: #e5e5e5 "></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </fieldset>

                                <h1>Fin</h1>
                                <fieldset>
                                    <h2 class="text-center">Bienvenido</h2>
                                    <p class="text-center">Ha completado satisfactoriamente su proceso de inscripción.</p>
                                </fieldset>
                            </form>
                        </div>
                    </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
  <script src="{{ asset('js/plantilla.js') }}"></script>
  <script>
      $(document).ready(function(){
        jQuery.extend(jQuery.validator.messages, {
          required: "Este campo es obligatorio.",
          remote: "Por favor, rellena este campo.",
          email: "Por favor, escribe una dirección de correo válida",
          url: "Por favor, escribe una URL válida.",
          date: "Por favor, escribe una fecha válida.",
          dateISO: "Por favor, escribe una fecha (ISO) válida.",
          number: "Por favor, escribe un número entero válido.",
          digits: "Por favor, escribe sólo dígitos.",
          creditcard: "Por favor, escribe un número de tarjeta válido.",
          equalTo: "Por favor, escribe el mismo valor de nuevo.",
          accept: "Por favor, escribe un valor con una extensión aceptada.",
          maxlength: jQuery.validator.format("Por favor, no escribas más de {0} caracteres."),
          minlength: jQuery.validator.format("Por favor, no escribas menos de {0} caracteres."),
          rangelength: jQuery.validator.format("Por favor, escribe un valor entre {0} y {1} caracteres."),
          range: jQuery.validator.format("Por favor, escribe un valor entre {0} y {1}."),
          max: jQuery.validator.format("Por favor, escribe un valor menor o igual a {0}."),
          min: jQuery.validator.format("Por favor, escribe un valor mayor o igual a {0}.")
        });
            $("#wizard").steps();
            $("#form").steps({
                labels: {
                    cancel: "Cancelar",
                    current: "Actual step:",
                    pagination: "Paginación",
                    finish: "Fin",
                    next: "Siguiente",
                    previous: "Anterior",
                    loading: "Cargando ..."
                },
                bodyTag: "fieldset",
                onStepChanging: function (event, currentIndex, newIndex)
                {
                    // Always allow going backward even if the current step contains invalid fields!
                    if (currentIndex > newIndex)
                    {
                        return true;
                    }

                    // Forbid suppressing "Warning" step if the user is to young
                    if (newIndex === 3 && Number($("#age").val()) < 18)
                    {
                        return false;
                    }

                    var form = $(this);

                    // Clean up if user went backward before
                    if (currentIndex < newIndex)
                    {
                        // To remove error styles
                        $(".body:eq(" + newIndex + ") label.error", form).remove();
                        $(".body:eq(" + newIndex + ") .error", form).removeClass("error");
                    }

                    // Disable validation on fields that are disabled or hidden.
                    form.validate().settings.ignore = ":disabled,:hidden";

                    // Start validation; Prevent going forward if false
                    return form.valid();
                },
                onStepChanged: function (event, currentIndex, priorIndex)
                {
                    // Suppress (skip) "Warning" step if the user is old enough.
                    if (currentIndex === 2 && Number($("#age").val()) >= 18)
                    {
                        $(this).steps("Siguiente");
                    }

                    // Suppress (skip) "Warning" step if the user is old enough and wants to the previous step.
                    if (currentIndex === 2 && priorIndex === 3)
                    {
                        $(this).steps("anterior");
                    }
                },
                onFinishing: function (event, currentIndex)
                {
                    var form = $(this);

                    // Disable validation on fields that are disabled.
                    // At this point it's recommended to do an overall check (mean ignoring only disabled fields)
                    form.validate().settings.ignore = ":disabled";

                    // Start validation; Prevent form submission if false
                    return form.valid();
                },
                onFinished: function (event, currentIndex)
                {
                    var form = $(this);

                    form.submit();
                }
            }).validate({
                        errorPlacement: function (error, element)
                        {
                            element.before(error);
                        },
                        rules: {
                            confirm: {
                                equalTo: "#password"
                            }
                        }
                    });
       });
  </script>
</body>
</html>