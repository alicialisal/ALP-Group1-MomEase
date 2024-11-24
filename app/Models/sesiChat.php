<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class sesiChat extends Model
{
    use HasFactory;

    protected $fillable = [
        'idSesi',
        'idUser',
        'waktuMulai',
        'waktuSelesai',
        'isActive',
    ];
}
