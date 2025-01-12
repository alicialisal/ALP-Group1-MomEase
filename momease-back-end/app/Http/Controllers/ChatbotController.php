<?php

namespace App\Http\Controllers;

use App\Models\Pesan;
use App\Models\sesiChat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Validator;

class ChatbotController extends Controller
{

    public function sendMessage(Request $request)
    {
        try {
            $prompt_setting = '
                    Kamu adalah seorang asisten yang Ramah, sabar, dan penuh perhatian. Namamu adalah Momease, kamu Selalu memberikan dorongan positif dan validasi perasaan ibu. Kamu suka memberikan dukungan emotional untuk menjauhkan orang-orang dari pikiran negative kamu juga sering Menyediakan tips praktis dalam mengelola kebutuhan bayi dan keseharian. 
                Kamu berkomunikasi Gunakan kalimat sederhana dan bersahabat. 
                Kamu juga memberikan jawaban singkat agar sang ibu tidak perlu membaca panjang-panjang
                Kamu juga menghindari nada menghakimi atau memerintah dan gunakan pendekatan kolaboratif.
                Kamu juga memberikan tanggapan yang relate dengan pembahasan ibu-ibu.';

            $validator = Validator::make($request->all(), [
                'idSesi' => 'required|string',
                'pesan' => 'required|string',
            ]);


            if ($validator->fails()) {
                return response()->json(['errors' => $validator->errors()], 422);
            }

            // Ambil user yang terautentikasiz
            $user = Auth::user();
            $sesiAvailable = sesiChat::where('idSesi', $request->idSesi)->where("idUser", $user->idUser)->count() > 0 ? true : false;
            if (!$sesiAvailable) {
                sesiChat::create(
                    [
                        "idSesi" => $request->idSesi,
                        "idUser" => $user->idUser,
                        "waktuMulai" => now(),
                        "isActive" => true
                    ]
                );
            }
            $history = Pesan::where('idSesi', $request->idSesi)->get()->map(function ($historyChat) {
                return [
                    "role" => ($historyChat->pengirim == "chatBot") ? "model" : "user",
                    "parts" => [['text' => $historyChat->pesan]]
                ];
            });

            // Simpan pesan pengguna    ke database
            $pesanUser = Pesan::create([
                'idSesi' => $request->idSesi,
                'pengirim' => $user->name ?? 'User', // Nama pengguna dari autentikasi
                'pesan' => $request->pesan,
                'waktuKirim' => now(),
            ]);

            $payload = [];
            if (count($history) > 0) array_push($payload, ...$history);
            array_push($payload, [
                'role' => "user",
                'parts' => [
                    ['text' => $request->pesan . $prompt_setting],
                ],
            ]);

            // Kirim pesan ke API GeminiAI
            $response = Http::withHeaders([
                'Content-Type' => 'application/json',
            ])->post('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=' . env('GEMINI_API_KEY'), [
                'contents' => [
                    $payload
                ]
            ]);

            if ($response->failed()) {
                return response()->json([
                    'error' => 'Failed to communicate with GeminiAI.',
                    'details' => $response->body(),
                ], 500);
            }

            // Simpan respons GeminiAI ke database
            $chatbotResponse = $response->json();

            $responseMessage = substr($chatbotResponse['candidates'][0]['content']['parts'][0]['text'], 0, -1) ?? 'No response from Gemini API';

            $pesanAi = Pesan::create([
                'idSesi' => $request->idSesi,
                'pengirim' => 'chatBot',
                'pesan' => $responseMessage,
                'waktuKirim' => now(),
            ]);

            return response()->json([
                'user_message' => $pesanUser,
                'ai_response' => $pesanAi,
                'history_chat' => $history,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                "error" => $e->getMessage(),
                "trace" => $e->getTrace()
            ], 500);
        }
    }
}
