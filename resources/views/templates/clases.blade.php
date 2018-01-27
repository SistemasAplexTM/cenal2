@extends('layouts.app')
@section('title', 'Festivos')
@section('content')
<div class="container-fluid" id="">
    <div class="row">
        <div class="col-lg-12">
            <div class="wrapper wrapper-content animated fadeInUp">

                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Clases</h5>
                        <div class="ibox-tools">
                            <a href="" class="btn btn-primary btn-sm"><i class="fa fa-calendar-plus-o"></i> Nueva clase</a>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row m-b-sm m-t-sm">
                            <div class="col-md-1">
                                <button type="button" id="loading-example-btn" class="btn btn-white btn-sm" ><i class="fa fa-refresh"></i> Actualizar</button>
                            </div>
                            <div class="col-md-11">
                                <div class="input-group"><input type="text" placeholder="Buscar clase" class="input-sm form-control"> <span class="input-group-btn">
                                    <button type="button" class="btn btn-sm btn-primary"> Buscar!</button> </span></div>
                            </div>
                        </div>

                        <div class="project-list">

                            <table class="table table-hover" id="tbl-clases">
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="project-status">
                                            <span class="label label-primary">En curso</span>
                                        </td>
                                        <td class="project-title">
                                            <a href="project_detail.html">Múdolo Office</a>
                                            <br/>
                                            <small>Inició 01 enero 2018 - Termina 01 junio 2018</small>
                                        </td>
                                        <td>
                                            <p>Salón SI_01</p>
                                            <small>Estudiantes 10 / 15</small>
                                        </td>
                                        <td class="project-completion">
                                                <small>Conpletado: 48%</small>
                                                <div class="progress progress-mini">
                                                    <div style="width: 48%;" class="progress-bar"></div>
                                                </div>
                                        </td>
                                        <td class="project-people">
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                        </td>
                                        <td class="project-actions">
                                            <a href="#" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> Detalles </a>
                                            <a href="#" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Editar </a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="project-status">
                                            <span class="label label-primary">En curso</span>
                                        </td>
                                        <td class="project-title">
                                            <a href="project_detail.html">Múdolo cultura física</a>
                                            <br/>
                                            <small>Inició 20 enero 2018 - Termina 31 mayo 2018</small>
                                        </td>
                                        <td>
                                            <p>Salón FI_01</p>
                                            <small>Estudiantes 10 / 15</small>
                                        </td>
                                        <td class="project-completion">
                                                <small>Conpletado: 20%</small>
                                                <div class="progress progress-mini">
                                                    <div style="width: 20%;" class="progress-bar"></div>
                                                </div>
                                        </td>
                                        <td class="project-people">
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                        <td class="project-actions">
                                            <a href="#" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> Detalles </a>
                                            <a href="#" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Editar </a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="project-status">
                                            <span class="label label-primary">En curso</span>
                                        </td>
                                        <td class="project-title">
                                            <a href="project_detail.html">Múdolo Office</a>
                                            <br/>
                                            <small>Inició 01 enero 2018 - Termina 01 junio 2018</small>
                                        </td>
                                        <td>
                                            <p>Salón SI_05</p>
                                            <small>Estudiantes 10 / 15</small>
                                        </td>
                                        <td class="project-completion">
                                                <small>Conpletado: 48%</small>
                                                <div class="progress progress-mini">
                                                    <div style="width: 48%;" class="progress-bar"></div>
                                                </div>
                                        </td>
                                        <td class="project-people">
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                            <a href=""><img alt="image" class="img-circle" src="{{ asset('img/profile_small.jpg') }}"></a>
                                        </td>
                                        <td class="project-actions">
                                            <a href="#" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> Detalles </a>
                                            <a href="#" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Editar </a>
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
@endsection
@push('scripts')
<script src="{{ asset('js/clases.js') }}"></script>
@endpush