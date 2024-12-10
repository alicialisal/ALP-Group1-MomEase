<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\SelfAssessmentResource;
use App\Models\jawabanAssess;
use App\Models\sesiAssessment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class SelfAssessController extends Controller
{
    private function generateIdSesiAssess($idUser)
    {
        $formattedIdUser = str_pad($idUser, 5, '0', STR_PAD_LEFT);
        $currentYear = now()->format('y');

        // Ambil jurnal terakhir untuk user ini
        $lastSesi = DB::table('sesi_assessment')
            ->where('idUser', $idUser)
            ->latest('idSesiAssess') // Mengurutkan berdasarkan ID Sesi
            ->first();

        // Ekstrak angka urut dari ID terakhir jika ada
        $lastNumber = 0;
        if ($lastSesi) {
            $lastId = $lastSesi->idSesiAssess;
            $lastNumber = (int) substr($lastId, -3); // Ambil 3 digit terakhir sebagai angka urut
        }

        // Tambahkan angka urut berikutnya
        $newNumber = str_pad($lastNumber + 1, 3, '0', STR_PAD_LEFT);

        return "SA" . $currentYear . $formattedIdUser . $newNumber;
    }

    public function store(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'idUser'      => 'required|exists:users,idUser',
            'answers'     => 'required|array', // Answers harus berupa array
            'answers.*.idPertanyaan' => 'required|integer|exists:pertanyaan_assess,idPertanyaan',
            'answers.*.jawaban'      => 'required|integer|min:1|max:5', // Jawaban harus bernilai 1-5
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        // Generate ID Sesi
        $idSesiAssess = $this->generateIdSesiAssess($request->idUser);

        // Hitung skor total (sum jawaban)
        $totalSkor = collect($request->answers)->sum('jawaban');

        // Simpan ke sesi_assessment
        $sesiAssess = SesiAssessment::create([
            'idSesiAssess' => $idSesiAssess,
            'idUser'       => $request->idUser,
            'skorTotal'    => $totalSkor,
            'waktuTes'     => Carbon::now(),
        ]);

        // Simpan jawaban ke jawaban_assess
        foreach ($request->answers as $answer) {
            $jawabanAssess = JawabanAssess::create([
                'idJawab'       => 1,
                'idSesiAssess'  => $idSesiAssess,
                'idPertanyaan'  => $answer['idPertanyaan'],
                'jawaban'       => $answer['jawaban'],
            ]);
        }

        return new SelfAssessmentResource(true, 'Self-Assessment berhasil disimpan!', $sesiAssess);
    }

    public function show($idSesiAssess)
    {
        // Cari data sesi_assessment
        $sesi = DB::table('sesi_assessment')->where('idSesiAssess', $idSesiAssess)->first();

        if (!$sesi) {
            return new SelfAssessmentResource(false, 'Data Self-Assessment tidak ditemukan', null);
        }

        // Cari data jawaban_assess
        $jawaban = DB::table('jawaban_assess')
            ->where('idSesiAssess', $idSesiAssess)
            ->get();

        $response = [
            'sesi'    => $sesi,
            'jawaban' => $jawaban,
        ];

        return new SelfAssessmentResource(true, 'Detail Self-Assessment ditemukan', $response);
    }
}
