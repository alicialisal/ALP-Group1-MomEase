<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ChatbotController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProfileController;
//

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

Route::get('/', function() {
    return 'API';
});

Route::post("register",[AuthController::class,"register"]);
Route::post("login",[AuthController::class,"login"]);
Route::get("login",[AuthController::class,"error_login"])->name("login");

Route::middleware('auth:sanctum')->group(function () {
    Route::post("logout",[AuthController::class,"logout"]);
    //journaling
    Route::apiResource('/journaling', App\Http\Controllers\Api\MoodJournalingController::class);
    Route::get('/mood-summary', [App\Http\Controllers\Api\MoodJournalingController::class, 'getMoodSummary']);

    //photos
    Route::apiResource('/journaling/photos', App\Http\Controllers\Api\PhotoGalleryController::class);

    //self-assessment
    Route::apiResource('/self-assess', App\Http\Controllers\Api\SelfAssessController::class);
    Route::get('/assess-summary', [App\Http\Controllers\Api\SelfAssessController::class, 'getSesiAssessSummary']);

    Route::put('/profile', [ProfileController::class, 'update']);
    Route::delete('/profile', [ProfileController::class, 'delete']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    Route::post('/chat/send', [ChatbotController::class, 'sendMessage']);
});
