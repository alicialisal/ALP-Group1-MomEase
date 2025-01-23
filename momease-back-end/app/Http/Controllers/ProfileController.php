<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        try {
            // Ambil user yang sedang login
            $user = $request->user();

            // Pastikan user ada
            if (!$user) {
                return response()->json([
                    'message' => 'User not found.',
                ], 404);
            }

            // Kembalikan data profile
            return response()->json([
                'message' => 'Profile retrieved successfully',
                'profile' => [
                    'namaDpn' => $user->namaDpn,
                    'namaBlkg' => $user->namaBlkg,
                    'tglLahir' => $user->tglLahir,
                    'email' => $user->email,
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to retrieve profile',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function update(Request $request, $id)
{
    try {
        // Cari user berdasarkan ID yang diberikan
        $user = User::where('idUser', $id)->first();

        if (!$user) {
            return response()->json([
                'message' => 'User not found.',
            ], 404);
        }

        // Validasi input
        $request->validate([
            'namaDpn' => 'required|string|max:255',
            'namaBlkg' => 'nullable|string|max:255',
            'tglLahir' => 'required|date',
            'email' => 'required|string|email|max:255|unique:users,email,' . $user->idUser . ',idUser', // Validasi email harus unik kecuali milik user ini
        ]);

        // Update data user
        $user->namaDpn = $request->namaDpn;
        $user->namaBlkg = $request->namaBlkg;
        $user->tglLahir = $request->tglLahir;
        $user->email = $request->email;
        $user->update();

        return response()->json([
            'message' => 'Profile updated successfully',
            'profile' => [
                'namaDpn' => $user->namaDpn,
                'namaBlkg' => $user->namaBlkg,
                'tglLahir' => $user->tglLahir,
                'email' => $user->email,
            ],
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'message' => 'Failed to update profile',
            'error' => $e->getMessage(),
        ], 500);
    }
}

    public function delete(Request $request)
    {
        $user = $request->user();

        // Delete all tokens
        $user->tokens()->delete();

        // Delete the user
        $user->delete();

        return response()->json([
            'message' => 'Profile deleted successfully'
        ], 200);
    }
}