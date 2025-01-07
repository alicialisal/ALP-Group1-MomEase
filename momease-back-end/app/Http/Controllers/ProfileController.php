<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProfileController extends Controller
{

    public function update(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'idUser' => 'required|exists:users,id',
            'namaDpn' => 'required|string|max:255',
            'namaBlkg' => 'nullable|string|max:255',
            'tglLahir' => 'required|date|before:today',
        ]);

        // Jika validasi gagal
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            // Cari user berdasarkan idUser
            $user = User::findOrFail($request->idUser);

            // Update data user
            $user->update([
                'namaDpn' => $request->namaDpn,
                'namaBlkg' => $request->namaBlkg,
                'tglLahir' => $request->tglLahir,
            ]);

            // Kembalikan response sukses
            return response()->json([
                'message' => 'Profile updated successfully',
                'profile' => $user,
            ]);
        } catch (\Exception $e) {
            // Jika ada error
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