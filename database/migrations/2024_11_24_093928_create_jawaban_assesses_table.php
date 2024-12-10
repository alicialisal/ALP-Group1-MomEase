<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('jawaban_assess', function (Blueprint $table) {
            $table->string('idJawab',15)->primary();
            $table->string('idSesiAssess');
            $table->tinyInteger('idPertanyaan');
            $table->tinyInteger('jawaban');

            $table->foreign('idSesiAssess')->references('idSesiAssess')->on('sesi_assessment');
            $table->foreign('idPertanyaan')->references('idPertanyaan')->on('pertanyaan_assess');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jawaban_assess');
    }
};
