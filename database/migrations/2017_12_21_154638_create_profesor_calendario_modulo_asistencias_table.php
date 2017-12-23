<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProfesorCalendarioModuloAsistenciasTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('profesor_calendario_modulo_asistencias', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('id_padre_calendario_modulo');
            $table->integer('id_profesor');
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
        Schema::dropIfExists('profesor_calendario_modulo_asistencias');
    }
}
