<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class kegiatanRelaksasi extends Model
{
    use HasFactory;
    protected $table = 'kegiatan_relaksasi';
    protected $primaryKey = 'idKegiatan';
    protected $fillable = [
        'idKegiatan',
        'namaKegiatan',
        'manfaat',
        'deskripsi',
        'durasi',
        'kategori',
        'tahapan',
        'photo',
    ];
}
