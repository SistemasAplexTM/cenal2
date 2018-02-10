<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateModulosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('modulos', function (Blueprint $table) {
            $table->increments('id');
            $table->string('nombre',50);
            $table->timestamps();
        });
        // Schema::create('modulo_jornada', function (Blueprint $table) {
        //     $table->increments('id');
        //     $table->integer('duracion');
        //     $table->integer('modulo_id')->unsigned();
        //     $table->integer('jornada_id')->unsigned();
        //     $table->timestamps();
        // });
        // Schema::table('modulo_jornada', function (Blueprint $table) {
        //     $table->foreign('modulo_id')->references('id')->on('modulos');
        //     $table->foreign('jornada_id')->references('id')->on('jornadas');
        // });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('modulo_jornada');
        Schema::dropIfExists('modulos');
    }
}
