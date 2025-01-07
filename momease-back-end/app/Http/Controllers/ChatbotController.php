<?php

namespace App\Http\Controllers;

use App\Models\sesiChat;
use App\Models\pesan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

//

class ChatbotController extends Controller
{
    /**
     * Membuka chat berdasarkan sesi yang ada.
     */
    public function bukaChat($idSesi)
    {
        $sesi = sesiChat::with('pesan')->where('idSesi', $idSesi)->first();

        if (!$sesi) {
            return response()->json(['message' => 'Sesi tidak ditemukan'], 404);
        }

        return response()->json([
            'sesi' => $sesi,
            'pesan' => $sesi->pesan,
        ]);
    }

    /**
     * Membalas pesan menggunakan Gemini API.
     */
    public function kirimPesan(Request $request, $idSesi)
    {
        $request->validate([
            'pesan' => 'required|string',
        ]);

        $sesi = sesiChat::where('idSesi', $idSesi)->first();

        if (!$sesi) {
            return response()->json(['message' => 'Sesi tidak ditemukan'], 404);
        }

        // Kirim pesan ke Gemini API
        $response = Http::post('AIzaSyAhXwJ6NLgxqFJxXqXvZVGK2VzmS_lozP0', [
            'message' => $request->pesan,
            'session_id' => $idSesi,
        ]);

        if ($response->failed()) {
            return response()->json(['message' => 'Gagal terhubung ke Gemini API'], 500);
        }

        $responseMessage = $response->json('reply');

        // Simpan pesan pengguna dan balasan ke database
        pesan::create([
            'idSesi' => $idSesi,
            'pesan' => $request->pesan,
            'isFromUser' => true,
        ]);

        pesan::create([
            'idSesi' => $idSesi,
            'pesan' => $responseMessage,
            'isFromUser' => false,
        ]);

        return response()->json([
            'user_message' => $request->pesan,
            'bot_reply' => $responseMessage,
        ]);
    }

    /**
     * Membuat sesi baru untuk chat.
     */
    public function buatSesiBaru(Request $request)
    {
        $request->validate([
            'idUser' => 'required|exists:users,id',
        ]);

        $idSesi = uniqid('sesi_');

        $sesi = sesiChat::create([
            'idSesi' => $idSesi,
            'idUser' => $request->idUser,
            'waktuMulai' => now(),
            'isActive' => 1,
        ]);

        return response()->json(['message' => 'Sesi berhasil dibuat', 'sesi' => $sesi]);
    }

    /**
     * Menyelesaikan sesi chat.
     */
    public function selesaiSesi($idSesi)
    {
        $sesi = sesiChat::where('idSesi', $idSesi)->first();

        if (!$sesi) {
            return response()->json(['message' => 'Sesi tidak ditemukan'], 404);
        }

        $sesi->update([
            'waktuSelesai' => now(),
            'isActive' => 0,
        ]);

        return response()->json(['message' => 'Sesi telah selesai']);
    }

    /**
     * API untuk menangani semua resource sesi chat.
     */
    public function index()
    {
        $sesiChats = sesiChat::with('pesan')->get();

        return response()->json($sesiChats);
    }

    public function show($id)
    {
        return $this->bukaChat($id);
    }

    public function store(Request $request)
    {
        return $this->buatSesiBaru($request);
    }

    public function update(Request $request, $id)
    {
        return response()->json(['message' => 'Not implemented'], 501);
    }

    public function destroy($id)
    {
        return $this->selesaiSesi($id);
    }
}
