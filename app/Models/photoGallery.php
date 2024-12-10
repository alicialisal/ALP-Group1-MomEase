<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class photoGallery extends Model
{
    use HasFactory;

    protected $table = 'photo_gallery';
    protected $primaryKey = 'id';

    protected $fillable = [
        'idJournaling',
        'photo',
    ];

    public function journaling()
    {
        return $this->belongsTo(MoodJournaling::class, 'idJournaling');
    }
}
