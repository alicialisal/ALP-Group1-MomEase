<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class jawabanAssess extends Model
{
    protected $table = 'jawaban_assess';
    protected $primaryKey = 'idJawab';
    use HasFactory;

    protected $fillable = [
        'idJawab',
        'idSesiAssess',
        'idPertanyaan',
        'jawaban',
    ];

    public $timestamps = false;
    public $updated_at = false;

    public function sesiAssess()
    {
        return $this->belongsTo(sesiAssessment::class, 'idSesiAsses');
    }
}
