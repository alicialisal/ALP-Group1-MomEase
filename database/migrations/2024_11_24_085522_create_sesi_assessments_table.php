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
        Schema::create('sesi_assessments', function (Blueprint $table) {
            $table->id('idSesiAssess', 15);
            $table->foreign('userId', 12);
            $table->tinyInteger('skorTotal');
            $table->timestamps('waktuTes');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sesi_assessments');
    }
};
