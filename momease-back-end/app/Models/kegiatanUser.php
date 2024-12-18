<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class kegiatanUser extends Model
{
    use HasFactory;

    protected $fillable = [
        'idKegiatan',
        'idUser',
        'waktuSelesai',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'idUser');
    }
}
