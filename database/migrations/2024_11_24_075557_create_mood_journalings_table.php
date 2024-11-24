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
        Schema::create('mood_journalings', function (Blueprint $table) {
            $table->id('idJournaling', 15);
            $table->foreignId('idUser', 12);
            $table->timestamps('tglInput');
            $table->tinyInteger('mood');
            $table->json('perasaan');
            $table->json('kondisiBayi');
            $table->text('textJurnal');
        });
    }


    public function down(): void
    {
        Schema::dropIfExists('mood_journalings');
    }
};
