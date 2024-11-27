<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class moodJournaling extends Model
{
    use HasFactory;

    protected $table = 'mood_journaling';
    protected $primaryKey = 'idJournaling';
    protected $keyType = 'string';
    protected $fillable = [
        'idJournaling',
        'idUser',
        'tglInput',
        'mood',
        'perasaan',
        'kondisiBayi',
        'textJurnal',
    ];

    public $timestamps = false;
    public $updated_at = false;

    public function user()
    {
        return $this->belongsTo(User::class, 'idUser');
    }
}
