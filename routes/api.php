<?php

use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProfileController;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

Route::get('/', function() {
    return 'API';
});

Route::post("register",[AuthController::class,"register"]);
Route::post("login",[AuthController::class,"login"]);
//journaling
Route::apiResource('/journaling', App\Http\Controllers\Api\MoodJournalingController::class);
Route::get('/mood-summary', [App\Http\Controllers\Api\MoodJournalingController::class, 'getMoodSummary']);

//photos
Route::apiResource('/journaling/photos', App\Http\Controllers\Api\PhotoGalleryController::class);

//self-assessment
Route::apiResource('/self-assess', App\Http\Controllers\Api\SelfAssessController::class);

Route::get('/profiles', [ProfileController::class, 'index']);
Route::put('/profiles/{id}', [ProfileController::class, 'update']);

