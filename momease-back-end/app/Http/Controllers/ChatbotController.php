<?php

namespace App\Http\Controllers;

use App\Models\Pesan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Validator;

class ChatbotController extends Controller
{

    public function sendMessage(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'idSesi' => 'required|string',
            'pesan' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Ambil user yang terautentikasiz
        $user = Auth::user();

        // Simpan pesan pengguna    ke database
        $pesanUser = Pesan::create([
            'idSesi' => $request->idSesi,
            'pengirim' => $user->name ?? 'User', // Nama pengguna dari autentikasi
            'pesan' => $request->pesan,
            'waktuKirim' => now(),
        ]);

        // Kirim pesan ke API GeminiAI
        $response = Http::withHeaders([
            'Content-Type' => 'application/json',
        ])->post('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=' . env('GEMINI_API_KEY'), [
            'contents' => [
                [
                    'parts' => [
                        ['text' => $request->pesan]
                    ]
                ]
            ]
        ]);

        if ($response->failed()) {
            return response()->json([
                'error' => 'Failed to communicate with GeminiAI.',
                'details' => $response->json(),
            ], 500);
        }

        // Simpan respons GeminiAI ke database
        $responseMessage = $response->json('response');
        return response()->json([
            $response
        ], 200);

        $pesanAi = Pesan::create([
            'idSesi' => $request->idSesi,
            'pengirim' => 'chatBot',
            'pesan' => $responseMessage,
            'waktuKirim' => now(),
        ]);

        return response()->json([
            'user_message' => $pesanUser,
            'ai_response' => $pesanAi,
        ], 200);
    }
}
