<?php

namespace App\Http\Controllers\Admin;

use App\Models\Booking;
use App\Http\Controllers\Controller; 

class BookingController extends Controller
{
    public function index()
    {
        $title = [
            'title' => 'Bookings'
        ];
        
        $bookings = Booking::select([
            'bookings.id',
            'students.id AS student_id',
            'students.name AS student_name',
            'rooms.name AS room_name',
            'bookings.check_in',
            'bookings.check_out',
            'bookings.created_at',
        ])
        ->join('rooms', 'rooms.id', 'bookings.room_id') 
        ->join('students', 'students.id', 'bookings.student_id')
        ->orderBy('created_at', 'DESC')->get();

        return view('admin.booking.index', $title, compact('bookings'));
    }

    public function view_booking_details($student_id)
    {
        $title = [
            'title' => 'Booking'
        ];

        $bookingData = Booking::select([
            'students.id',
            'students.name AS student_name',
            'rooms.name AS room_name',
            'student_profiles.class',
            'student_profiles.phone',
            'student_profiles.emergency_number',
            'bookings.check_in',
            'bookings.check_out',
            'bookings.created_at',
        ])
        ->join('rooms', 'rooms.id', 'bookings.room_id')
        ->join('student_profiles', 'student_profiles.student_id', 'bookings.student_id')
        ->join('students', 'students.id', 'bookings.student_id')
        ->where('bookings.student_id', $student_id)
        ->orderBy('created_at', 'DESC')->get();

        if ($bookingData) {
            return view('admin.booking.details', $title, compact('bookingData'));
        }
    }

    public function studentsPayments()
    {
        $title = [
            'title' => 'Payments'
        ];

        $studentsPayments = Booking::join('students', 'bookings.student_id', 'students.id')
            ->join('rooms', 'bookings.room_id', 'rooms.id')
            ->join('payments', 'bookings.student_id', 'payments.student_id')
            ->distinct()->select([
                'students.name AS student_name',
                'rooms.name AS room_name',
                'payments.transaction_number',
                'payments.amount',
                'payments.payment_mode',
                'payments.created_at',
                'bookings.check_in',
                'bookings.check_out',
            ])->get();

        return view('admin.booking.payments', $title, compact('studentsPayments'));
    }
}