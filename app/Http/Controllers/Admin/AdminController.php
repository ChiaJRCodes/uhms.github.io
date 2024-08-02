<?php

namespace App\Http\Controllers\Admin;

use Carbon\Carbon;
use App\Models\Room;
use App\Models\Admin;
use App\Models\Booking;
use App\Models\Payment;
use App\Models\Dormitory;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Database\QueryException;

class AdminController extends Controller
{
    public function login(Request $request)
    {
        $title = [
            'title' => 'Login'
        ];

        if ($request->isMethod('post')) {

            $data = $request->all();

            $rules = [
                'email' => 'email|required',
                'password' => 'required',
            ];

            $messages = [
                'email.required' => 'Email address is required',
                'email.email' => 'Valid email address is required',
                'password.required' => 'Password is required',
            ];

            $this->validate($request, $rules, $messages);

            if (Auth::guard('admin')->attempt([
                'email' => $data['email'],
                'password' => $data['password']
            ]))
                return redirect()->route('adminDashboard');
            else {

                if (Auth::guard('student')->attempt([
                    'email' => $data['email'],
                    'password' => $data['password']
                ]))

                    return redirect()->route('home');

                else {
                    return redirect()->back()->with('error', 'Invalid email or password');
                }

                return redirect()->back()->with('error', 'Invalid email or password');
            }
        }

        return view('admin.auth.login', $title);
    }

    public function adminDashboard()
    {
        $title = [
            'title' => 'Dashboard'
        ];

        $payments = Payment::all()->count();
        $bookings = Booking::all()->count();
        $rooms = Room::all()->count();
        $dormitories = Dormitory::all()->count();

        return view('admin.dashboard', $title, compact('payments', 'bookings', 'rooms', 'dormitories'));
    }

    public function checkAdminPassword(Request $request)
    {
        $adminData = $request->all();

        if (Hash::check($adminData['old_password'], Auth::guard('admin')->user()->password)) {
            return 'true';
        } else {
            return 'false';
        }
    }

    public function updateAdminPassword(Request $request)
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

            if (Hash::check($request->old_password, Auth::guard('admin')->user()->password)) {
                if ($request->new_password === $request->confirm_password) {
                    if (strlen($request->new_password) > 7) {
                        $admin = Admin::findorFail(Auth::guard('admin')->user()->id);
                        if ($admin) {
                            $admin->password = Hash::make($request->new_password);
                            $admin->update();
                            return redirect()->route('adminDashboard')->with('success', 'Your password successfully  updated');
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

            return redirect()->route('adminDashboard');
        }

        $adminData = Admin::where('email', Auth::guard('admin')->user()->email)->get();

        return view('admin.auth.update-password', $title, compact('adminData'));
    }

    public function adminLogout()
    {
        Auth::guard('admin')->logout();
        return redirect()->route('login')->with('success', 'You have successfully logout');
    }

    public function get_forgot_password()
    {
        $title = [
            'title' => 'Password recovery'
        ];
        return view('admin.auth.forgot-password', $title);
    }

    public function post_forgot_password(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:admins,email'
        ]);

        $token = Str::random(64);
        try {
            DB::table('password_resets')->insert([
                'email' => $request->email,
                'token' => $token,
                'created_at' => Carbon::now()
            ]);
        } catch (QueryException $e) {
            $errorCode = $e->errorInfo[1];
            if ($errorCode == '1062') {
                return redirect()->route('login')->with('error', 'This request has been sent arleady!');
            }
        }

        $activation_link = route('adminResetPassword', [
            'token' => $token,
            'email' => $request->email,
        ]);
        $body = "Click the link below to reset your password";

        Mail::send(
            'admin.auth.email-verification',
            ['activation_link' => $activation_link, 'body' => $body],
            function ($message) use ($request) {
                $message->from('hostelmanagers@gmail.com', 'Hostel Management System');
                $message->to($request->email, $request->name)
                    ->subject('Reset Password');
            }
        );

        return redirect()->back()->with('success', 'Recovery link has been sent to your email');
    }

    public function reset_password(Request $request, $token = null)
    {
        return view('admin.auth.reset-password')->with(['token' => $token, 'email' => $request->email]);
    }

    public function update_password(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:admins,email',
            'password' => 'required|min:8',
            'repeat_password' => 'required|same:password'
        ]);

        $verified_token = DB::table('password_resets')->where([
            'email' => $request->email,
            'token' => $request->token
        ])->first();

        if (!$verified_token) {
            return back()->withInput()->with('error', 'Link expired!');
        } else {
            Admin::where('email', $request->email)->update([
                'password' => Hash::make($request->password)
            ]);

            DB::table('password_resets')->where([
                'email' => $request->email
            ])->delete();

            return redirect()->route('login')->with('success', 'You can now login with new password');
        }
    }
}
