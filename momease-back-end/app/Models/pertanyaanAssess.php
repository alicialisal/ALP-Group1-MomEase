<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class pertanyaanAssess extends Model
{
    use HasFactory;

    protected $fillable = [
        'idPertanyaan',
        'pertanyaan',
        'bobot',
    ];

    public function jawabanAssess()
    {
        return $this->hasMany(jawabanAssess::class, 'idPertanyaan', 'idPertanyaan');
    }
}
