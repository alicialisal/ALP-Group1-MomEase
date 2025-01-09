<?php

namespace App\Http\Controllers;

use App\Models\sesiChat;
use App\Models\pesan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

//

class ChatbotController extends Controller
{
    private $geminiApiUrl = "https://api.geminiai.com/chat";
    private $geminiApiKey = "AIzaSyAhXwJ6NLgxqFJxXqXvZVGK2VzmS_lozP0";

    public function startChatSession(Request $request)
    {
        $user = $request->user();

        $sesi = sesiChat::create([
            'idSesi' => uniqid(),
            'idUser' => $user->id,
            'waktuMulai' => now(),
            'isActive' => true,
        ]);

        return response()->json($sesi);
    }

    public function sendMessage(Request $request, $idSesi)
    {
        $request->validate([
            'message' => 'required|string',
        ]);

        $sesi = sesiChat::where('idSesi', $idSesi)->where('isActive', true)->first();

        if (!$sesi) {
            return response()->json(['error' => 'Session not found or inactive'], 404);
        }

        $pesan = pesan::create([
            'idSesi' => $sesi->idSesi,
            'idUser' => $sesi->idUser,
            'pesanUser' => $request->message,
            'waktuKirim' => now(),
        ]);

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . $this->geminiApiKey,
        ])->post($this->geminiApiUrl, [
            'message' => $request->message,
        ]);

        if ($response->failed()) {
            return response()->json(['error' => 'Failed to connect to GeminiAI'], 500);
        }

        $botResponse = $response->json('response');

        pesan::create([
            'idSesi' => $sesi->idSesi,
            'idUser' => null, // null indicates system/bot response
            'pesanBot' => $botResponse,
            'waktuKirim' => now(),
        ]);

        return response()->json(['user_message' => $pesan, 'bot_response' => $botResponse]);
    }

    public function endChatSession($idSesi)
    {
        $sesi = sesiChat::where('idSesi', $idSesi)->where('isActive', true)->first();

        if (!$sesi) {
            return response()->json(['error' => 'Session not found or already inactive'], 404);
        }

        $sesi->update([
            'waktuSelesai' => now(),
            'isActive' => false,
        ]);

        return response()->json(['message' => 'Session ended']);
    }

    public function getChatHistory($idSesi)
    {
        $sesi = sesiChat::with('pesan')->where('idSesi', $idSesi)->first();

        if (!$sesi) {
            return response()->json(['error' => 'Session not found'], 404);
        }

        return response()->json($sesi);
    }
}