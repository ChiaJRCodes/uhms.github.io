<?php

namespace App\Http\Controllers\Student;

use Carbon\Carbon;
use App\Models\Student;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller; 
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Database\QueryException;
use App\Http\Requests\Admin\StudentRequest;

class StudentAuthController extends Controller
{
    public function register()
    {
        $title = [
            'title' => 'Registration'
        ];

        return view('admin.auth.student.register', $title);
    }

    public function saveStudent(StudentRequest $request)
    {
        if ($request->password === $request->confirm_password) {
            if (strlen($request->password) > 7) {
                $data = $request->validated();

                $student = new Student();

                $student->name = $data['name'];
                $student->email = $data['email'];
                $student->password = Hash::make($data['password']);

                $student->save();

                return redirect()->back()->with('success', 'Registration completed. Login to book your room now!');
            } else {
                return redirect()->back()->with('error', 'Password should contains at least 8 characters');
            }
        } else {
            return redirect()->back()->with('error', 'Password does not match');
        }
    }

    public function get_forgot_password()
    {
        $title = [
            'title' => 'Password recovery'
        ];
        return view('admin.auth.student.forgot-password', $title);
    }

    public function post_forgot_password(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:students,email'
        ]);

        $token = Str::random(64);

        try {
            DB::table('password_resets')->insert([
                'email' => $request->email,
                'token' => $token,
                'created_at' => Carbon::now()
            ]);  
        } catch(QueryException $e){
            $errorCode = $e->errorInfo[1];
            if($errorCode == '1062'){ 
            return redirect()->route('login')->with('error', 'This request has been sent arleady!');
      
            }
        }

        $activation_link = route('studentResetPassword', [
            'token' => $token,
            'email' => $request->email,
        ]);
        $body = "Reset your password by clicking the link below";

        Mail::send(
            'admin.auth.student.email-verification',
            ['activation_link' => $activation_link, 'body' => $body],
            function ($message) use ($request) {
                $message->from('hostelmanagers@gmail.com', 'Hostel Management System');
                $message->to($request->email, $request->name)
                    ->subject('Reset Password');
            }
        );

        return redirect()->back()->with('success', 'Recovery link sent to your email');
    }

    public function reset_password(Request $request, $token = null)
    {
        return view('admin.auth.student.reset-password')->with(['token' => $token, 'email' => $request->email]);
    }

    public function update_password(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:students,email',
            'password' => 'required|min:8',
            'repeat_password' => 'required|same:password'
        ]);

        $verified_token = DB::table('password_resets')->where([
            'email' => $request->email,
            'token' => $request->token
        ])->first();

        if (!$verified_token) {
            return back()->withInput()->with('error', 'Activation link is arleady expired!');
        } else {
            Student::where('email', $request->email)->update([
                'password' => Hash::make($request->password)
            ]);

            DB::table('password_resets')->where([
                'email' => $request->email
            ])->delete();

            return redirect()->route('login')->with('success', 'Password changed. Login with new credentials');
        }
    }
    
}
