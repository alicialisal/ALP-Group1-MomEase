<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\MoodJournalingResource;
use App\Models\moodJournaling;
use Illuminate\Http\Request;
use Illuminate\Routing\Controllers\HasMiddleware;
use Illuminate\Routing\Controllers\Middleware;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Carbon;

class MoodJournalingController extends Controller implements HasMiddleware
{
    public static function middleware()
    {
        return [
            new Middleware('auth:sanctum', except:['index', 'show'])
        ];
    }

    public function index()
    {
        //get all posts
        $moodJournaling = moodJournaling::latest()->paginate(5);

        //return collection of posts as a resource
        return new MoodJournalingResource(true, 'List Data Mood Journaling', $moodJournaling);
    }

    private function generateIdJournaling($idUser)
    {
        // Pastikan idUser memiliki 5 digit dengan padding nol di kanan
        $formattedIdUser = str_pad($idUser, 5, '0', STR_PAD_LEFT);

        // Ambil jurnal terakhir untuk user ini
        $lastJournal = DB::table('mood_journaling')
            ->where('idUser', $idUser)
            ->latest('idJournaling') // Mengurutkan berdasarkan ID Journaling
            ->first();

        // Ekstrak angka urut dari ID terakhir jika ada
        $lastNumber = 0;
        if ($lastJournal) {
            $lastId = $lastJournal->idJournaling;
            $lastNumber = (int) substr($lastId, -3); // Ambil 3 digit terakhir sebagai angka urut
        }

        // Tambahkan angka urut berikutnya
        $newNumber = str_pad($lastNumber + 1, 3, '0', STR_PAD_LEFT);

        // Susun ID sesuai format: MJ + tahun + idUser + urutan
        $currentYear = now()->format('y');
        return "MJ" . $currentYear . $formattedIdUser . $newNumber;
    }

    public function store(Request $request)
    {
        //define validation rules
        $validator = Validator::make($request->all(), [
            // 'idJournaling' => 'required|string|max:15', // ID jurnal harus berupa string dengan panjang maksimal 15
            'idUser'       => 'required|exists:users,idUser', // ID user harus ada di tabel `users`
            'tglInput'     => 'required|date', // Tanggal input harus berupa tanggal yang valid
            'mood'         => 'required|integer|min:1|max:5', // Mood harus berupa angka (1-5)
            'perasaan'     => 'array', // Perasaan harus berupa format JSON
            'kondisiBayi'  => 'array', // Kondisi bayi harus berupa format JSON
            'textJurnal'   => 'string', // Text jurnal harus berupa string
        ]);

        //check if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        //upload image
        // $image = $request->file('image');
        // $image->storeAs('public/posts', $image->hashName());

        //create journaling
        $moodJournaling = MoodJournaling::create([
            'idJournaling' => $this->generateIdJournaling($request->idUser),
            'idUser'       => $request->idUser, // Pastikan ini dikirim dari frontend
            'tglInput'     => $request->tglInput, // Menggunakan waktu sekarang sebagai tanggal input
            'mood'         => $request->mood, // Data mood dari input
            'perasaan'     => json_encode($request->perasaan), // Pastikan `perasaan` berupa array atau JSON
            'kondisiBayi'  => json_encode($request->kondisiBayi), // Pastikan `kondisiBayi` berupa array atau JSON
            'textJurnal'   => $request->textJurnal, // Teks jurnal dari input
        ]);

        //return response
        return new MoodJournalingResource(true, 'Data Mood Journaling berhasil ditambahkan!', $moodJournaling);
    }

    public function show($id)
    {
        //find post by ID
        $moodJournaling = moodJournaling::find($id);

        //return single post as a resource
        return new MoodJournalingResource(true, 'Detail Data Mood Journaling', $moodJournaling);
    }

    public function update(Request $request, $id)
    {
        //define validation rules
        $validator = Validator::make($request->all(), [
            'mood'         => 'sometimes|integer|min:1|max:5', // Only validate if mood is provided
            'perasaan'     => 'sometimes|array', // Only validate if perasaan is provided
            'kondisiBayi'  => 'sometimes|array', // Only validate if kondisiBayi is provided
            'textJurnal'   => 'sometimes|string', // Only validate if textJurnal is provided
        ]);

        //check if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $updateData = [];

        //find post by ID
        $moodJournaling = moodJournaling::find($id);

        if (!$moodJournaling) {
            return response()->json(['error' => 'Data not found'], 404);
        }

        if ($request->filled('mood')) {
            $updateData['mood'] = $request->mood;
        }
    
        if ($request->filled('perasaan')) {
            $updateData['perasaan'] = json_encode($request->perasaan); // Convert array to JSON
        }
    
        if ($request->filled('kondisiBayi')) {
            $updateData['kondisiBayi'] = json_encode($request->kondisiBayi); // Convert array to JSON
        }
    
        if ($request->filled('textJurnal')) {
            $updateData['textJurnal'] = $request->textJurnal;
        }

        $moodJournaling->update($updateData);

        //return response
        return new MoodJournalingResource(true, 'Data Mood Journaling Berhasil Diubah!', $moodJournaling);
    }

    /**
     * destroy
     *
     * @param  mixed $post
     * @return void
     */
    public function destroy($id)
    {

        //find post by ID
        $moodJournaling = moodJournaling::find($id);

        //delete image
        // moodJournaling::delete('public/posts/'.basename($post->image));

        //delete post
        $moodJournaling->delete();

        //return response
        return new MoodJournalingResource(true, 'Data Mood Journaling Berhasil Dihapus!', null);
    }

    public function getMoodSummary(Request $request)
    {
        // Validasi parameter
        $validator = Validator::make($request->all(), [
            'month' => 'required|integer|between:1,12', // Bulan antara 1-12
            'year'  => 'required|integer|min:2000|max:' . Carbon::now()->year, // Tahun minimal 2000 sampai tahun ini
        ]);
    
        // Jika validasi gagal, kembalikan respons error
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }
    
        // Ambil bulan dan tahun dari parameter
        $month = $request->input('month');
        $year = $request->input('year');
    
        // Query untuk mendapatkan data mood per hari
        $dailyMoods = moodJournaling::select(
            DB::raw('DATE(tglInput) as date'), // Ambil tanggal
            'mood'                             // Ambil nilai mood
        )
            ->whereMonth('tglInput', $month)
            ->whereYear('tglInput', $year)
            // ->groupBy(DB::raw('DATE(tglInput)'), 'mood') // Kelompokkan berdasarkan tanggal dan mood
            ->orderBy(DB::raw('DATE(tglInput)'))        // Urutkan berdasarkan tanggal
            ->get();

        // Format respons
        $response = [
            'month' => $month,
            'year' => $year,
            'data' => $dailyMoods,
        ];

        return response()->json($response, 200);
    }
}
