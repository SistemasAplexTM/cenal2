@extends('layouts.app')
@section('title', 'Módulos')
@section('content')
<div class="container" id="crud_modulo">
	<div class="row">
		<div class="col-lg-7 col-lg-offset-3">
			<div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5><i class="fa fa-puzzle-piece"></i> Módulos</h5>
                    <div class="ibox-tools">
                        @role('Administrador')
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="true">
                            <i class="fa fa-ellipsis-h"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-user">
                            <li><a href="#" onclick="getTable('a')"><i class="fa fa-list"></i> Ver</a>
                            <li><a href="#" onclick="getTable('b')"><i class="fa fa-trash"></i> Ver eliminados</a>
                            </li>
                        </ul>
                        @endrole
                    </div>
                </div>
                <div class="ibox-content">
                    <!--***** contenido ******-->
                	<div class="alert alert-danger" role="alert" v-show="JSON.stringify(formErrors)!='{}'">
                		<ul>
                			<li class="result-nombre"></li>
                			<li class="result-duracion"></li>
                		</ul>
					</div>
					<p>Haga click en el registro para activar la edición y presione la tecla <strong>Enter</strong> para actualizar.</p>
                    
                    <p class="text-center">
                        {{-- <i class="fa fa-calendar big-icon"></i> --}}
                        <div class="form-group text-center">
                            
                            <div class="custom-radios">
                            <div>
                              <input v-model="color" type="radio" id="color-1" name="color" value="#2f8d99" checked>
                              <label for="color-1">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>
                            
                            <div>
                              <input v-model="color" type="radio" id="color-2" name="color" value="#42a5f5">
                              <label for="color-2">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>
                            
                            <div>
                              <input v-model="color" type="radio" id="color-3" name="color" value="#00c5dc">
                              <label for="color-3">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>

                            <div>
                              <input v-model="color" type="radio" id="color-4" name="color" value="#feb38d">
                              <label for="color-4">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>
                            <div>
                              <input v-model="color" type="radio" id="color-5" name="color" value="#EE6E73">
                              <label for="color-5">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>
                            <div>
                              <input v-model="color" type="radio" id="color-6" name="color" value="#6B79C4">
                              <label for="color-6">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>
                            <div>
                              <input v-model="color" type="radio" id="color-7" name="color" value="#FF7176">
                              <label for="color-7">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>
                            <div>
                              <input v-model="color" type="radio" id="color-8" name="color" value="#FF252B">
                              <label for="color-8">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>
                            <div>
                              <input v-model="color" type="radio" id="color-9" name="color" value="#7F393B">
                              <label for="color-9">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>
                            <div>
                              <input v-model="color" type="radio" id="color-10" name="color" value="#CC1D23">
                              <label for="color-10">
                                <span>
                                  <img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/242518/check-icn.svg" alt="Checked Icon" />
                                </span>
                              </label>
                            </div>
                          </div>
                        </div>
                    </p>
                    <div class="table-responsive">
                        <table id="tbl-modulos" class="table table-striped table-hover table-bordered">
                            <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Duración <small>(clases)</small></th>
                                    <th>Color</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tfoot class="table-foot">
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th class="none"></th>
                                    <th class="none"></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
		</div>
	</div>
</div>
@endsection
@push('scripts')
<script src="{{ asset('js/modulo.js') }}"></script>
@endpush