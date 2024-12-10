<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\SelfAssessmentResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Illuminate\Support\Str;

class SelfAssessController extends Controller
{
    private function generateIdSesiAssess($idUser)
    {
        $formattedIdUser = str_pad($idUser, 5, '0', STR_PAD_LEFT);
        $currentYear = now()->format('y');
        return "SA" . $currentYear . $formattedIdUser . Str::random(5);
    }

    private function generateIdJawaban($idSesiAssess, $idPertanyaan)
    {
        return $idSesiAssess . str_pad($idPertanyaan, 3, '0', STR_PAD_LEFT);
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
        DB::table('sesi_assessment')->insert([
            'idSesiAssess' => $idSesiAssess,
            'idUser'       => $request->idUser,
            'skorTotal'    => $totalSkor,
            'waktuTes'     => Carbon::now(),
        ]);

        // Simpan jawaban ke jawaban_assess
        foreach ($request->answers as $answers) {
            DB::table('jawaban_assess')->insert([
                'idJawab'       => $this->generateIdJawaban($idSesiAssess, $answers['idPertanyaan']),
                'idSesiAssess'  => $idSesiAssess,
                'idPertanyaan'  => $answers['idPertanyaan'],
                'jawaban'       => $answers['jawaban'],
                'created_at'    => Carbon::now(),
                'updated_at'    => Carbon::now(),
            ]);
        }

        // Return response menggunakan resource
        $response = [
            'idSesiAssess' => $idSesiAssess,
            'idUser'       => $request->idUser,
            'skorTotal'    => $totalSkor,
            'waktuTes'     => Carbon::now(),
        ];

        return new SelfAssessmentResource(true, 'Self-Assessment berhasil disimpan!', $response);
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
