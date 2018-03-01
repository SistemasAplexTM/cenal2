<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateClasesEstudianteTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('clases_estudiante', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('clases_id');
            $table->integer('estudiante_id');
            $table->timestamps();
        });
        Schema::table('clases_estudiante', function (Blueprint $table) {
           $table->foreign('clases_id')->references('id')->on('clases');
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
        Schema::dropIfExists('clases_estudiante');
    }
}
