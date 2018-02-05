<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateClasesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('clases', function (Blueprint $table) {
            $table->increments('id');
            $table->datetime('fecha_inicio');
            $table->integer('modulo_id')->unsigned();
            $table->integer('salon_id')->unsigned();
            $table->integer('estado_id')->unsigned();
            $table->integer('sede_id')->unsigned();
            $table->integer('jornada_id')->unsigned();
            $table->text('ids_estudiantes')->nullable();
            $table->text('observacion')->nullable();
            $table->timestamps();
        });

        Schema::table('clases', function (Blueprint $table) {
            $table->foreign('modulo_id')->references('id')->on('modulos');
            $table->foreign('salon_id')->references('id')->on('salones');
            $table->foreign('sede_id')->references('id')->on('sede');
            $table->foreign('jornada_id')->references('id')->on('jornadas');
            $table->foreign('estado_id')->references('id')->on('estado');
        });

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('clases');
    }
}
