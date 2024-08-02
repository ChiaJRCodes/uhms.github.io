<?php

namespace App\Models;

use App\Models\Room;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Dormitory extends Model
{
    use HasFactory;

    protected $table = 'dormitories';
    protected $fillable = [
        'name',
        'description'
    ];

    public function rooms(){
        return $this->hasMany(Room::class);
    }
}
