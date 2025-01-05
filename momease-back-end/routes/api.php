<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ChatbotController;
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
Route::post("logout",[AuthController::class,"logout"])->middleware('auth:sanctum');
//journaling
Route::apiResource('/journaling', App\Http\Controllers\Api\MoodJournalingController::class);
Route::get('/mood-summary', [App\Http\Controllers\Api\MoodJournalingController::class, 'getMoodSummary']);

//photos
Route::apiResource('/journaling/photos', App\Http\Controllers\Api\PhotoGalleryController::class);

//self-assessment
Route::apiResource('/self-assess', App\Http\Controllers\Api\SelfAssessController::class);
Route::get('/assess-summary', [App\Http\Controllers\Api\SelfAssessController::class, 'getSesiAssessSummary']);

Route::middleware('auth:sanctum')->get('/profile', function (Request $request) {
    return $request->user();
});

Route::middleware('auth:sanctum')->get('/profile', function (Request $request) {
    return $request->user();
});

//Chatbot API
Route::prefix('chatbot')->group(function () {
    Route::get('/', [ChatbotController::class, 'index']); // List all chat sessions
    Route::post('/', [ChatbotController::class, 'store']); // Create a new chat session
    Route::get('/{id}', [ChatbotController::class, 'show']); // Retrieve a specific chat session
    Route::post('/{id}/message', [ChatbotController::class, 'kirimPesan']); // Send a message to the chatbot
    Route::delete('/{id}', [ChatbotController::class, 'destroy']); // End a chat session
});