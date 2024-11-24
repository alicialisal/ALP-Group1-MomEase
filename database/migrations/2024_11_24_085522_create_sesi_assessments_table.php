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
        Schema::create('sesi_assessment', function (Blueprint $table) {
            $table->string('idSesiAssess', 15)->primary();
            $table->string('idUser', 12);
            $table->tinyInteger('skorTotal');
            $table->timestamp('waktuTes');

            $table->foreign('idUser')->references('idUser')->on('users');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sesi_assessment');
    }
};
