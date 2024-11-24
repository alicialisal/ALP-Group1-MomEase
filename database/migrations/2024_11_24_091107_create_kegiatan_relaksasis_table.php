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
        Schema::create('kegiatan_relaksasi', function (Blueprint $table) {
            $table->id('idKegiatan');
            $table->string('namaKegiatan', 45);
            $table->string('manfaat', 50);
            $table->text('deskripsi');
            $table->time('durasi');
            $table->enum('kategori',['kategori a', 'kategori b']);
            $table->json('tahapan');
            $table->binary('photo');
            $table->timestamp('waktuSelesai');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('kegiatan_relaksasis');
    }
};
