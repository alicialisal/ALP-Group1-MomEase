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
        Schema::create('jawaban_assesses', function (Blueprint $table) {
            $table->id('idJawab');
            $table->foreignId('idSesiAssess');
            $table->foreignId('idPertanyaan');
            $table->tinyInteger('jawaban');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jawaban_assesses');
    }
};
