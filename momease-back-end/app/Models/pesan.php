<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class pesan extends Model
{
    use HasFactory;

    protected $table = 'pesan';
    protected $fillable = [
        'idPesan',
        'idSesi',
        'pengirim',
        'pesan',
        'waktuKirim',
    ];

    public function sesiChat()
    {
        return $this->belongsTo(sesiChat::class, 'idSesi', 'idSesi');
    }
}
