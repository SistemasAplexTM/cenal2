@extends('layouts.app')
@section('title', 'Clases')
@section('content')
<div class="container" id="">
    <div class="row">
        <div class="ibox">
            <div class="ibox-title">
                <h5><i class="fa fa-calendar-check-o"></i> Módulo Office</h5>
            </div>
            <div class="ibox-content">
                <div class="row">
            <div class="col-lg-9">
                    <div class="ibox">
                        <div class="ibox-content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="m-b-md text-center">
                                        <a href="#" class="btn btn-white btn-xs pull-right">Editar</a>
                                        <h1>Módulo Office</h1>
                                    </div>
                                    <dl class="dl-horizontal">
                                        <dt>Estado:</dt> <dd><span class="label label-primary">En curso</span></dd>
                                    </dl>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-5">
                                    <dl class="dl-horizontal">
                                        <dt>Salón:</dt> <dd>SI_01</dd>
                                        <dt>Cupos totales:</dt> <dd> 20</dd>
                                        <dt>Cupos usados:</dt> <dd>  16 </dd>
                                        <dt>Profesor:</dt> <dd><a href="#" class="text-navy">Julio Castañeda</a> </dd>
                                    </dl>
                                </div>
                                <div class="col-lg-7" id="cluster_info">
                                    <dl class="dl-horizontal" >

                                        <dt>Inicio:</dt> <dd>16 Enero 2018</dd>
                                        <dt>Fin:</dt> <dd>  20 junio 2018</dd>
                                        {{-- <dt>Profesor:</dt>
                                        <dd class="project-people">
                                        <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                        </dd> --}}
                                    </dl>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <dl class="dl-horizontal">
                                        <dt>Progreso:</dt>
                                        <dd>
                                            <div class="progress progress-striped active m-b-sm">
                                                <div style="width: 60%;" class="progress-bar"></div>
                                            </div>
                                            <small>Se han dictado <strong>15</strong> clases de 20 en total.</small>
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                            <div class="row m-t-sm">
                                <div class="col-lg-12">
                                <div class="panel blank-panel">
                                <div class="panel-heading">
                                    <div class="panel-options">
                                        <ul class="nav nav-tabs">
                                            <li class="active"><a href="#tab-1" data-toggle="tab">Estudiantes activos</a></li>
                                            <li class=""><a href="#tab-2" data-toggle="tab">Last activity</a></li>
                                        </ul>
                                    </div>
                                </div>

                                <div class="panel-body">

                                <div class="tab-content">
                                <div class="tab-pane active" id="tab-1">
                                    <div class="feed-activity-list">
                                        <div class="feed-element">
                                            <a href="#" class="pull-left">
                                                <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                                            </a>
                                            <div class="media-body ">
                                                <strong>Jhonny Poconuco</strong><br>
                                                <small class="text-muted"><strong>Asistencia:</strong> 03 / 15</small><br>
                                                <small class="text-muted"><strong>Programa:</strong> Técnico en sistemas</small>
                                            </div>
                                        </div>
                                        <div class="feed-element">
                                            <a href="#" class="pull-left">
                                                <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                                            </a>
                                            <div class="media-body ">
                                                <strong>Jhonny Poconuco</strong><br>
                                                <small class="text-muted"><strong>Asistencia:</strong> 03 / 15</small><br>
                                                <small class="text-muted"><strong>Programa:</strong> Técnico en sistemas</small>
                                            </div>
                                        </div>
                                        <div class="feed-element">
                                            <a href="#" class="pull-left">
                                                <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                                            </a>
                                            <div class="media-body ">
                                                <strong>Jhonny Poconuco</strong><br>
                                                <small class="text-muted"><strong>Asistencia:</strong> 03 / 15</small><br>
                                                <small class="text-muted"><strong>Programa:</strong> Técnico en sistemas</small>
                                            </div>
                                        </div>
                                        <div class="feed-element">
                                            <a href="#" class="pull-left">
                                                <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                                            </a>
                                            <div class="media-body ">
                                                <strong>Jhonny Poconuco</strong><br>
                                                <small class="text-muted"><strong>Asistencia:</strong> 03 / 15</small><br>
                                                <small class="text-muted"><strong>Programa:</strong> Técnico en sistemas</small>
                                            </div>
                                        </div>
                                        <div class="feed-element">
                                            <a href="#" class="pull-left">
                                                <img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}">
                                            </a>
                                            <div class="media-body ">
                                                <strong>Jhonny Poconuco</strong><br>
                                                <small class="text-muted"><strong>Asistencia:</strong> 03 / 15</small><br>
                                                <small class="text-muted"><strong>Programa:</strong> Técnico en sistemas</small>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <div class="tab-pane" id="tab-2">

                                    <table class="table table-striped">
                                        <thead>
                                        <tr>
                                            <th>Status</th>
                                            <th>Title</th>
                                            <th>Start Time</th>
                                            <th>End Time</th>
                                            <th>Comments</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td>
                                                <span class="label label-primary"><i class="fa fa-check"></i> Completed</span>
                                            </td>
                                            <td>
                                               Create project in webapp
                                            </td>
                                            <td>
                                               12.07.2014 10:10:1
                                            </td>
                                            <td>
                                                14.07.2014 10:16:36
                                            </td>
                                            <td>
                                            <p class="small">
                                                Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable.
                                            </p>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="label label-primary"><i class="fa fa-check"></i> Accepted</span>
                                            </td>
                                            <td>
                                                Various versions
                                            </td>
                                            <td>
                                                12.07.2014 10:10:1
                                            </td>
                                            <td>
                                                14.07.2014 10:16:36
                                            </td>
                                            <td>
                                                <p class="small">
                                                    Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                                                </p>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="label label-primary"><i class="fa fa-check"></i> Sent</span>
                                            </td>
                                            <td>
                                                There are many variations
                                            </td>
                                            <td>
                                                12.07.2014 10:10:1
                                            </td>
                                            <td>
                                                14.07.2014 10:16:36
                                            </td>
                                            <td>
                                                <p class="small">
                                                    There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which
                                                </p>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="label label-primary"><i class="fa fa-check"></i> Reported</span>
                                            </td>
                                            <td>
                                                Latin words
                                            </td>
                                            <td>
                                                12.07.2014 10:10:1
                                            </td>
                                            <td>
                                                14.07.2014 10:16:36
                                            </td>
                                            <td>
                                                <p class="small">
                                                    Latin words, combined with a handful of model sentence structures
                                                </p>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="label label-primary"><i class="fa fa-check"></i> Accepted</span>
                                            </td>
                                            <td>
                                                The generated Lorem
                                            </td>
                                            <td>
                                                12.07.2014 10:10:1
                                            </td>
                                            <td>
                                                14.07.2014 10:16:36
                                            </td>
                                            <td>
                                                <p class="small">
                                                    The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.
                                                </p>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="label label-primary"><i class="fa fa-check"></i> Sent</span>
                                            </td>
                                            <td>
                                                The first line
                                            </td>
                                            <td>
                                                12.07.2014 10:10:1
                                            </td>
                                            <td>
                                                14.07.2014 10:16:36
                                            </td>
                                            <td>
                                                <p class="small">
                                                    The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
                                                </p>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="label label-primary"><i class="fa fa-check"></i> Reported</span>
                                            </td>
                                            <td>
                                                The standard chunk
                                            </td>
                                            <td>
                                                12.07.2014 10:10:1
                                            </td>
                                            <td>
                                                14.07.2014 10:16:36
                                            </td>
                                            <td>
                                                <p class="small">
                                                    The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested.
                                                </p>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="label label-primary"><i class="fa fa-check"></i> Completed</span>
                                            </td>
                                            <td>
                                                Lorem Ipsum is that
                                            </td>
                                            <td>
                                                12.07.2014 10:10:1
                                            </td>
                                            <td>
                                                14.07.2014 10:16:36
                                            </td>
                                            <td>
                                                <p class="small">
                                                    Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable.
                                                </p>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="label label-primary"><i class="fa fa-check"></i> Sent</span>
                                            </td>
                                            <td>
                                                Contrary to popular
                                            </td>
                                            <td>
                                                12.07.2014 10:10:1
                                            </td>
                                            <td>
                                                14.07.2014 10:16:36
                                            </td>
                                            <td>
                                                <p class="small">
                                                    Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical
                                                </p>
                                            </td>

                                        </tr>

                                        </tbody>
                                    </table>

                                </div>
                                </div>

                                </div>

                                </div>
                                </div>
                            </div>
                        </div>
                    </div>
                
            </div>
            <div class="col-lg-3">
                <div class="wrapper wrapper-content project-manager">
                    <h4 class="text-center">Módulo Office</h4>
                    <p class="small">
                        Acá va una descripción del módulo.
                        There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look
                    </p>
                    <h5>Project files</h5>
                    <ul class="list-unstyled project-files">
                        <li><a href=""><i class="fa fa-file"></i> Project_document.docx</a></li>
                        <li><a href=""><i class="fa fa-file-picture-o"></i> Logo_zender_company.jpg</a></li>
                        <li><a href=""><i class="fa fa-stack-exchange"></i> Email_from_Alex.mln</a></li>
                        <li><a href=""><i class="fa fa-file"></i> Contract_20_11_2014.docx</a></li>
                    </ul>
                    <div class="text-center m-t-md">
                        <a href="#" class="btn btn-xs btn-block btn-primary">Detalles</a>
                        {{-- <a href="#" class="btn btn-xs btn-primary">Report contact</a> --}}

                    </div>
                </div>
            </div>
        </div>
            </div>
        </div>
    </div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/clases.js') }}"></script>
@endpush