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
        Schema::create('pesan', function (Blueprint $table) {
            $table->uuid('idPesan')->primary();
            $table->string('idSesi', 15);
            $table->enum('pengirim', ['user','chatBot']);
            $table->text('pesan');
            $table->timestamp('waktuKirim');
            $table->timestamps(false);
            $table->foreign('idSesi')->references('idSesi')->on('sesi_chat');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pesan');
    }
};
