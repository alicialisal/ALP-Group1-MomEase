<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class moodJournaling extends Model
{
    use HasFactory;

    protected $fillable = [
        'idJournaling',
        'idUser',
        'tglInput',
        'mood',
        'perasaan',
        'kondisiBayi',
        'textJournal',
    ];
}
