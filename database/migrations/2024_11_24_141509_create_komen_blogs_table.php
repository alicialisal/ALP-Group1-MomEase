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
        Schema::create('komen_blog', function (Blueprint $table) {
            $table->id();
            $table->string('idUser', 12);
            $table->string('idBlog', 15);
            $table->text('komentar');
            $table->timestamps();

            $table->foreign('idUser')->references('idUser')->on('users');
            $table->foreign('idBlog')->references('idBlog')->on('blogs');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('komen_blog');
    }
};
