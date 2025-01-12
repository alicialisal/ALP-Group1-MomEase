<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

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

    protected static function boot() {
        parent::boot();
        self::creating(function ($model) {
            if ( ! $model->getKey()) {
                $model->idPesan = (string) Str::uuid();
            }
        });
    }

    public function sesiChat()
    {
        return $this->belongsTo(sesiChat::class, 'idSesi', 'idSesi');
    }
}
