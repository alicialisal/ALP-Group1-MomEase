<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class jawabanAssess extends Model
{
    use HasFactory;

    protected $fillable = [
        'idJawab',
        'idSesiAsses',
        'idPertanyaan',
        'jawaban',
    ];
}
