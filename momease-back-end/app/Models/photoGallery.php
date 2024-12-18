<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Casts\Attribute;
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

    protected function photo(): Attribute
    {
        return Attribute::make(
            get: fn ($photo) => url('/storage/posts/' . $photo),
        );
    }

    public function journaling()
    {
        return $this->belongsTo(MoodJournaling::class, 'idJournaling');
    }
}
