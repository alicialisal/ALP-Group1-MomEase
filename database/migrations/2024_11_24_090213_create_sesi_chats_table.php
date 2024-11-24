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
        Schema::create('sesi_chat', function (Blueprint $table) {
            $table->string('idSesi',15)->primary();
            $table->string('idUser', 12);
            $table->timestamp('waktuMulai');
            $table->timestamp('waktuSelesai')->nullable()->default(null);
            $table->tinyInteger('isActive');

            $table->foreign('idUser')->references('idUser')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sesi_chats');
    }
};
