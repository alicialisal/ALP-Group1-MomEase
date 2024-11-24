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
        Schema::create('photo_gallery', function (Blueprint $table) {
            $table->id();
            $table->string('idJournaling', 15);
            $table->binary('photo');
            $table->timestamps();

            $table->foreign('idJournaling')->references('idJournaling')->on('mood_journaling');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('photo_gallery');
    }
};
