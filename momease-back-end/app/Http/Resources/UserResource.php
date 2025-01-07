<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'idUser' => $this->idUser,
            'namaDpn' => $this->namaDpn,
            'namaBlkg' => $this->namaBlkg,
            'tglLahir' => $this->tglLahir,
            'passUsr' => $this->passUsr,
            'email' => $this->email,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
