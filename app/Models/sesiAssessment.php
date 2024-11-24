<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class sesiAssessment extends Model
{
    use HasFactory;

    protected $fillable = [
        'idSesiAssess',
        'idUser',
        'skorTotal',
        'waktuTes',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'idUser');
    }

    public function jawabanAssess()
    {
        return $this->hasMany(jawabanAssess::class, 'idSesiAssess', 'idSesiAssess');
    }
}
