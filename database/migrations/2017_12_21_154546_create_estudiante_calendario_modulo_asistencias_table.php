<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateEstudianteCalendarioModuloAsistenciasTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('estudiante_calendario_modulo_asistencias', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('estudiante_id');
            $table->integer('id_padre_calendario_modulo');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('estudiante_calendario_modulo_asistencias');
    }
}
