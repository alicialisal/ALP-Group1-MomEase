<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Http\Resources\UserResource;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    // Register Function
    public function register(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'idUser' => 'required|string|unique:users,idUser|max:12', // Sesuai format idUser
            'namaDpn' => 'required|string|max:255',
            'namaBlkg' => 'nullable|string|max:255',
            'passUsr' => 'required|string|min:8|confirmed',
            'tglLahir' => 'required|date|before:today', // Validasi tanggal dalam format "YYYY-MM-DD"
            'email' => 'required|string|email|max:255|unique:users,email',
        ]);

        // Jika validasi gagal
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Membuat pengguna baru
        $user = User::create([
            'idUser' => $request->idUser,
            'namaDpn' => $request->namaDpn,
            'namaBlkg' => $request->namaBlkg,
            'passUsr' => Hash::make($request->passUsr), // Hashing password
            'tglLahir' => $request->tglLahir,
            'email' => $request->email,
        ]);

        // Membuat token setelah register
        $token = $user->createToken($request->namaDpn);

        // Mengembalikan respons berhasil
        return response()->json([
            'message' => 'Registration successful',
            'user' => [
                'idUser' => $user->idUser,
                'namaDpn' => $user->namaDpn,
                'namaBlkg' => $user->namaBlkg,
                'email' => $user->email,
            ],
            'token' => $token,
        ], 201);
    }

    // Login Function
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',  // Memastikan email ada dan valid
            'passUsr' => 'required|string|min:8',  // Memastikan password ada dan memiliki minimal 8 karakter
        ]);
    
        // Jika validasi gagal, kembalikan error 422
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
    
        // Cek apakah email ada di database
        $user = User::where('email', $request->email)->first();
    
        // Jika user tidak ditemukan, kembalikan error 404
        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }
    
        // Memeriksa apakah password sesuai
        if (!Hash::check($request->passUsr, $user->passUsr)) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
    
        // Generate token
        $token = $user->createToken('auth_token')->accessToken;
    
        // Mengembalikan user dan token
        return response()->json([
            'user' => new UserResource($user), // Menggunakan UserResource untuk memformat data user
            'token' => $token                  // Token untuk autentikasi
        ], 200);
    }
}
