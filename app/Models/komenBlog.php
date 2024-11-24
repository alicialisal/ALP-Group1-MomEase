<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class komenBlog extends Model
{
    use HasFactory;
    protected $fillable = [
        'idBlog',
        'idUser',
        'komentar',
    ];
}
