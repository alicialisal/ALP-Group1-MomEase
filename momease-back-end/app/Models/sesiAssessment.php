<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class sesiAssessment extends Model
{
    protected $table = 'sesi_assessment';
    protected $primaryKey = 'idSesiAssess';
    protected $keyType = 'string';
    use HasFactory;

    protected $fillable = [
        'idSesiAssess',
        'idUser',
        'skorTotal',
        'waktuTes',
    ];

    public $timestamps = false;
    public $updated_at = false;

    public function user()
    {
        return $this->belongsTo(User::class, 'idUser');
    }

    public function jawabanAssess()
    {
        return $this->hasMany(jawabanAssess::class, 'idSesiAssess', 'idSesiAssess');
    }
}
