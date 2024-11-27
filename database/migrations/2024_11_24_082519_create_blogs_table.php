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
        Schema::create('like_blog', function (Blueprint $table) {
            $table->string('idBlog', 15);
            $table->unsignedBigInteger('idUser');
            $table->boolean('isLike');
            $table->timestamps();

            $table->primary(['idBlog', 'idUser']);

            $table->foreign('idUser')->references('idUser')->on('users');
            $table->foreign('idBlog')->references('idBlog')->on('blogs');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('like_blog');
    }
};
