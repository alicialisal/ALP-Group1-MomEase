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
//posts
Route::apiResource('/journaling', App\Http\Controllers\Api\MoodJournalingController::class);

Route::get('/profiles', [ProfileController::class, 'index']);
Route::put('/profiles/{id}', [ProfileController::class, 'update']);

