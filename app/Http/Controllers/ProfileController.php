<?php

namespace App\Http\Controllers;

use App\Models\Profile;
use App\Models\User;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function index()
    {
        return User::all();
    }

    public function update(Request $request, $id)
    {
        $profile = User::findOrFail($id);
        $profile->update($request->all());
        return response()->json(['message' => 'Profile updated successfully', 'profile' => $profile]);
    }
}

