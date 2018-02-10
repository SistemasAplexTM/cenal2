<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePivotProgUnicosModulos extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('pivot_programas_unicos_modulos', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('id_prog_unicos');
            $table->integer('id_modulo')->unsigned();
            $table->timestamps();
        });
        Schema::table('pivot_programas_unicos_modulos', function (Blueprint $table) {
            $table->foreign('id_modulo')->references('id')->on('modulos');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('pivot_programas_unicos_modulos');
    }
}
