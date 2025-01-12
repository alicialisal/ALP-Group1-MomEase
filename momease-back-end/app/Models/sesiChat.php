<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class sesiChat extends Model
{
    use HasFactory;
    protected $table = "sesi_chat";
    protected $fillable = [
        'idSesi',
        'idUser',
        'waktuMulai',
        'waktuSelesai',
        'isActive',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'idUser');
    }

    public function pesan()
    {
        return $this->hasMany(pesan::class, 'idSesi', 'idSesi');
    }
}
