<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateClasesDetalleTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('clases_detalle', function (Blueprint $table) {
            $table->increments('id');
            $table->string('title', 30);
            $table->integer('clases_id');
            $table->datetime('start')->comment('Este campo está reemplazando el campo fecha');
            $table->datetime('end')->nullable();
            $table->boolean('all_day')->default(true);
            $table->string('color', 10)->nullable();
            $table->integer('estado_id')->default(1);
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
        Schema::dropIfExists('clases_detalle');
    }
}
