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
        Schema::create('mood_journaling', function (Blueprint $table) {
            $table->string('idJournaling', 15)->primary();
            $table->unsignedBigInteger('idUser');
            $table->timestamp('tglInput');
            $table->tinyInteger('mood');
            $table->json('perasaan');
            $table->json('kondisiBayi');
            $table->text('textJurnal');

            $table->foreign('idUser')->references('idUser')->on('users');
        });
    }


    public function down(): void
    {
        Schema::dropIfExists('mood_journaling');
    }
};
