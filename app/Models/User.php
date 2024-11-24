<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'idUser',
        'namaDpn',
        'namaBlkg',
        'passUrs',
        'birthYear',
        'email',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'passUsr',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'passUsr' => 'hashed',
        ];
    }

    public function kegiatanUsers()
    {
        return $this->hasMany(kegiatanUser::class, 'idUser');
    }

    public function moodJournalings()
    {
        return $this->hasMany(moodJournaling::class, 'idUser');
    }

    public function sesiAssessments()
    {
        return $this->hasMany(sesiAssessment::class, 'idUser');
    }
    
    public function sesiChat()
    {
        return $this->hasMany(sesiChat::class, 'idUser');
    }
}
