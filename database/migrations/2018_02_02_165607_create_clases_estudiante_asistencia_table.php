<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateClasesEstudianteAsistenciaTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('clases_estudiante_asistencia', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('clases_detalle_id')->nullable();
            $table->integer('estudiante_id');
            $table->boolean('asistencia')->default(false);
            $table->timestamps();
        });

        Schema::table('clases_estudiante_asistencia', function (Blueprint $table) {
            $table->foreign('clases_detalle_id')->references('id')->on('clases_detalle');
            $table->foreign('estudiante_id')->references('id')->on('estudiante');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('clases_estudiante_asistencia');
    }
}
