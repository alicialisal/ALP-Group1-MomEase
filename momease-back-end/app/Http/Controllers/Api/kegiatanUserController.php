<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Http\Resources\kegiatanUserResource;
use App\Models\kegiatanUser;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class kegiatanUserController extends Controller
{
    public function index()
    {
        //get all activities
        $kegiatanUser = kegiatanUser::orderBy('id', 'desc')->paginate(5);

        //return collection of posts as a resource
        return new kegiatanUserResource(true, 'List Data Kegiatan User', $kegiatanUser);
    }
    public function show($id)
    {
        //find post by ID
        $kegiatanRelaksasi = kegiatanUser::find($id);

        //return single post as a resource
        return new kegiatanUserResource(true, 'Detail Data Kegiatan Relaksasi', $kegiatanRelaksasi);
    }

    public function store(Request $request)
    {
        //define validation rules
        $validator = Validator::make($request->all(), [
            'idKegiatan' => 'required|string|max:15', // ID jurnal harus berupa string dengan panjang maksimal 15
            'idUser'       => 'required|exists:users,idUser', // ID user harus ada di tabel `users`
            'tglInput'     => 'required|date', // Tanggal input harus berupa tanggal yang valid
        ]);

        //check if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        //upload image
        // $image = $request->file('image');
        // $image->storeAs('public/posts', $image->hashName());

        //create kegiatanUser
        $kegiatanUser = kegiatanUser::create([
            'idKegiatan'   => $request->idKegiatan, // Pastikan ini dikirim dari frontend
            'idUser'       => $request->idUser, // Pastikan ini dikirim dari frontend
            'waktuSelesai'     => now(), // Menggunakan waktu sekarang sebagai tanggal input
        ]);

        //return response
        return new kegiatanUserResource(true, 'Data Kegiatan User berhasil ditambahkan!', $kegiatanUser);
    }
}
