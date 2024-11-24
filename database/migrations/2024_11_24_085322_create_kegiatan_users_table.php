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
        Schema::create('kegiatan_user', function (Blueprint $table) {
            $table->id();
            $table->string('idKegiatan', 12);
            $table->string('idUser', 12);
            $table->timestamp('waktuSelesai');

            $table->foreign('idUser')->references('idUser')->on('users');
            $table->foreign('idKegiatan')->references('idKegiatan')->on('kegiatan_relaksasi');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('kegiatan_users');
    }
};
