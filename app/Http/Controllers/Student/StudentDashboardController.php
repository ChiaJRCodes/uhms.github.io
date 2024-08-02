<?php

namespace App\Http\Controllers\Student;

use App\Models\Room;
use App\Models\Booking;
use App\Models\Student;
use Illuminate\Http\Request;
use App\Models\StudentProfile;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Database\QueryException;

class StudentDashboardController extends Controller
{
    public function studentDashboard()
    {
        $title = [
            'title' => 'Dashboard'
        ];

        return view('student-dashboard.dashboard', $title);
    }
    
    public function studentProfile()
    {
        $title = [
            'title' => 'Profile'
        ];

        $student_id = Auth::guard('student')->user()->id;

        $student = Booking::join('students', 'bookings.student_id', 'students.id')
            ->join('rooms', 'bookings.room_id', 'rooms.id')
            ->select([
                'students.name AS student_name',
                'rooms.name AS room_name',
                'bookings.check_in',
                'bookings.check_out'
            ])
            ->where('bookings.student_id', $student_id)->get();

        return view('student-dashboard.student.details', $title, compact('student'));
    }
    public function studentParticulars()
    {
        $title = [
            'title' => 'Particulars'
        ];

        $studentData = Student::select([
            'students.id',
            'students.name',
            'student_profiles.programme',
            'student_profiles.class',
            'student_profiles.academic_year',
            'student_profiles.phone',
            'student_profiles.emergency_number',
            'student_profiles.sex',
            ])
        ->join('student_profiles', 'students.id', 'student_profiles.student_id')
        ->where('students.id', Auth::guard('student')->user()->id)->get();

        if(count($studentData) == 0)

        return view('admin.student.blank-particulars', $title);

        else{
            return view('admin.student.particulars', compact('studentData'), $title);
        }
    }

    public function saveStudentParticulars(Request $request)
    {  
        try {
            StudentProfile::updateOrCreate([
                'student_id' => Auth::guard('student')->user()->id,
                'programme' => $request->programme,
                'class' =>  $request->class,
                'academic_year' => $request->year,
                'phone' =>  $request->phone,
                'emergency_number' => $request->emergency,
                'sex' => $request->sex
            ]);

            return redirect()->route('studentDashboard')->with('success', 'Your profile successfully updated');

        } catch (QueryException $e) {
            $errorCode = $e->errorInfo[1];
            if ($errorCode == 1062) {
                return redirect()->back()->with('error', 'Sorry, entered phone number is arleady in use.');
            }
        
        }
    
    }


    public function paymentsRecords()
    {
        $title = [
            'title' => 'Payments records'
        ];

        $student = Booking::join('students', 'bookings.student_id', 'students.id')
            ->join('rooms', 'bookings.room_id', 'rooms.id')
            ->join('payments', 'bookings.student_id', 'payments.student_id')
            ->distinct()->select([
                'students.name AS student_name',
                'rooms.name AS room_name',
                'payments.transaction_number',
                'payments.amount',
                'payments.payment_mode',
                'payments.created_at',
            ])
            ->where('payments.student_id', Auth::guard('student')->user()->id)->get();

        return view('student-dashboard.student.payments', $title, compact('student'));
    }

    public function checkStudentPassword(Request $request)
    {
        $studentData = $request->all();

        if (Hash::check($studentData['old_password'], Auth::guard('student')->user()->password)) {
            return 'true';
        } else {
            return 'false';
        }
    }

    public function updateStudentPassword(Request $request)
    {
        $title = [
            'title' => 'Update password'
        ];

        if ($request->isMethod('post')) {

            $data = $request->all();

            $rules = [
                'old_password' => 'required',
                'new_password' => 'required|min:8',
                'confirm_password' => 'required|min:8',
            ];

            $messages = [
                'old_password.required' => 'Old password is required',
                'new_password.required' => 'New password is required',
                'confirm_password.required' => 'Confirm password is required',
            ];

            $this->validate($request, $rules, $messages);

            if (Hash::check($request->old_password, Auth::guard('student')->user()->password)) {
                if ($request->new_password === $request->confirm_password) {
                    if (strlen($request->new_password) > 7) {
                        $student = Student::findorFail(Auth::guard('student')->user()->id);
                        if ($student) {
                            $student->password = Hash::make($request->new_password);
                            $student->update();
                            return redirect()->route('studentDashboard')->with('success', 'Your password successfully updated');
                        }
                    } else {
                        return redirect()->back()->with('error', 'New password should contains at least 8 characters');
                    }
                } else {
                    return redirect()->back()->with('error', 'New password does not match');
                }
            } else {
                return redirect()->back()->with('error', 'Current password is not correct');
            }

            return redirect()->route('studentDashboard');
        }

        $studentData = Student::where('email', Auth::guard('student')->user()->email)->get();


        return view('admin.auth.student.update-password', $title, compact('studentData'));
    }

    public function room_details($room_id)
    {
        $title = [
            'title' => 'Room details'
        ];
        
        if (Auth::guard('student')->user()->id) {

            $roomDetails = Room::where('id', $room_id)->get();

            $studentData = Student::select([
                'students.id',
                'students.name',
                'student_profiles.programme',
                'student_profiles.class',
                'student_profiles.academic_year',
                'student_profiles.phone',
                'student_profiles.emergency_number',
                'student_profiles.sex',
            ])
                ->join('student_profiles', 'students.id', 'student_profiles.student_id')
                ->where('students.id', Auth::guard('student')->user()->id)->get();

            if (count($studentData) == 0) {
                return view('blank-room-details', compact('studentData', 'roomDetails'), $title);
            } else {
                $roomDetails = Room::where('id', $room_id)->get();

                return view('room-details', compact('roomDetails'));
            }
        } 
    }

    public function studentLogout()
    {
        Auth::guard('student')->logout();
        return redirect()->route('login')->with('success', 'You have successfully logout');
    }

}
