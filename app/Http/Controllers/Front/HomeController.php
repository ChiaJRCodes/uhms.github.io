<?php

namespace App\Http\Controllers\Front;

use App\Models\Room;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class HomeController extends Controller
{
    public function home()
    { 
        $rooms = Room::orderBy('created_at', 'ASC')->get()->take(6);

        return view('index', compact('rooms'));
    }

    public function rooms()
    {
        $rooms = Room::where('status', true)->get();
        return view('rooms', compact('rooms'));
    }

    public function availableRooms(Request $request)
    {
        $checkin_date = $request->from_date;

        $available_rooms = DB::SELECT("SELECT * FROM rooms WHERE id NOT IN (SELECT room_id FROM bookings WHERE '$checkin_date' BETWEEN check_in AND check_out)");

        return view('available-rooms', compact('available_rooms'));
    }
}
