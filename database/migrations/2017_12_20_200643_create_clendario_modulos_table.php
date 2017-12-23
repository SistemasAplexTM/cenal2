<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateClendarioModulosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('clendario_modulos', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('modulo_id');
            $table->string('fecha', 15);
            $table->boolean('inicio');
            $table->integer('salon_id');
            $table->integer('sede_id');
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
        Schema::dropIfExists('clendario_modulos');
    }
}
