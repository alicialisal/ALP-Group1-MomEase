<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\PhotoGalleryResource;
use App\Models\photoGallery;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class PhotoGalleryController extends Controller
{
    public function store(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'idJournaling' => 'required|exists:mood_journaling,idJournaling', // ID Journaling harus valid
            'photo'        => 'required|image|mimes:jpeg,png,jpg|max:2048', // Gambar harus valid dengan ukuran maksimal 2MB
        ]);
    
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }
    
        // Cek jumlah foto yang sudah disimpan untuk idJournaling
        $photoCount = DB::table('photo_gallery')
            ->where('idJournaling', $request->idJournaling)
            ->count();
    
        if ($photoCount >= 1) {
            return response()->json(['error' => 'Maksimal 3 foto untuk setiap jurnal.'], 422);
        }

        // Upload dan simpan gambar
        try {
            $photo = $request->file('photo');

            // Simpan file ke storage/public/posts
            $photo->storeAs('public/posts', $photo->hashName());

            // Simpan path file ke database
            $photoGallery = PhotoGallery::create([
                'idJournaling' => $request->idJournaling,
                'photo'        => $photo->hashName(), // Menyimpan nama file di database
            ]);

            return new PhotoGalleryResource(true, 'Data Foto berhasil disimpan!', $photoGallery);
        } catch (\Exception $e) {
            Log::error('Photo upload error: ' . $e->getMessage());
            return response()->json([
                'error' => 'An error occurred while uploading the photo. Please try again later.',
            ], 500);
        }
    }
    
    public function show($idJournaling)
    {
        // Ambil foto berdasarkan idJournaling
        $photos = PhotoGallery::where('idJournaling', $idJournaling)->get();
    
        if ($photos->isEmpty()) {
            return response()->json(['error' => 'Tidak ada foto untuk jurnal ini.'], 404);
        }
    
        return new PhotoGalleryResource(true, 'Foto-foto untuk jurnal ditemukan!', $photos);
    }

    public function update(Request $request, $id)
    {
        // $request->getContent();

        $validator = Validator::make($request->all(), [
            // 'idJournaling' => 'required|exists:mood_journaling,idJournaling', // ID Journaling harus valid
            'photo'        => 'required|image|mimes:jpeg,png,jpg|max:2048', // Gambar harus valid dengan ukuran maksimal 2MB
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        //find post by ID
        $gallery = PhotoGallery::find($id);

        // Check if the gallery is found
        if (!$gallery) {
            return response()->json(['error' => 'Data not found.'], 404);
        }

        // Upload dan simpan gambar
        try {
        //check if image is not empty
            if ($request->hasFile('photo')) {
            
                //upload image
                $photo = $request->file('photo');
                $photo->storeAs('public/posts', $photo->hashName());
            
                //delete old image
                Storage::delete('public/posts/'.basename($gallery->photo));
            
                //update post with new image
                $gallery->update([
                    'photo'     => $photo->hashName(),
                ]);
            
                //return response
                return new PhotoGalleryResource(true, 'Data Photo Gallery Berhasil Diubah!', $gallery);
            }
        }
        catch (\Exception $e) {
            Log::error('Photo upload error: ' . $e->getMessage());
            return response()->json([
                'error' => 'An error occurred while uploading the photo. Please try again later.',
            ], 500);
        }
        return new PhotoGalleryResource(true, 'Data Photo Gallery Berhasil Diubah tanpa Perubahan Foto!', $gallery);
    }

    /**
     * destroy
     *
     * @param  mixed $post
     * @return void
     */
    public function destroy($id)
    {
        // Cari foto berdasarkan ID
        $gallery = PhotoGallery::find($id);

        if (!$gallery) {
            return response()->json(['error' => 'Foto tidak ditemukan.'], 404);
        }
        
        Storage::delete('public/posts/'.basename($gallery->photo));

        // Hapus foto
        $gallery->delete();

        return new PhotoGalleryResource(true, 'Foto berhasil dihapus!', null);
    }


}
