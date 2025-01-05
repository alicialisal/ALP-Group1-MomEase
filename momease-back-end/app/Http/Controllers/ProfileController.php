<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Resources\UserResource;

class ProfileController extends Controller
{
    public function update(Request $request)
    {
        $user = $request->user();
            
        // Validate the request
        $validated = $request->validate([
            'namaDpn' => 'string|max:255',
            'namaBlkg' => 'nullable|string|max:255',
            'email' => 'email|unique:users,email,' . $user->id,
            'tglLahir' => 'date|before:today',
        ]);

        $user->update($validated);

        return response()->json([
            'message' => 'Profile updated successfully',
            'profile' => new UserResource($user)
        ]);
    }

    public function destroy(Request $request)
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