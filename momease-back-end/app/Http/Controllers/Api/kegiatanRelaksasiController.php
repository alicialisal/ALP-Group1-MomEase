<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Http\Resources\kegiatanRelaksasiResource;
use App\Models\kegiatanRelaksasi;
use Illuminate\Http\Request;
use Illuminate\Routing\Controllers\HasMiddleware;
use Illuminate\Routing\Controllers\Middleware;

class kegiatanRelaksasiController extends Controller
{
    public function index()
    {
        //get all activities
        $kegiatanRelaksasi = kegiatanRelaksasi::latest()->paginate(5);

        //return collection of posts as a resource
        return new kegiatanRelaksasiResource(true, 'List Data Kegiatan Relaksasi', $kegiatanRelaksasi);
    }
    public function show($id)
    {
        //find post by ID
        $kegiatanRelaksasi = kegiatanRelaksasi::find($id);

        //return single post as a resource
        return new kegiatanRelaksasiResource(true, 'Detail Data Kegiatan Relaksasi', $kegiatanRelaksasi);
    }
}
