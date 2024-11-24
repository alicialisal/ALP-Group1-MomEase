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

    public function user()
    {
        return $this->belongsTo(User::class, 'idUser');
    }

    public function blog()
    {
        return $this->belongsTo(blog::class, 'idBlog');
    }
}
