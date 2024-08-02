<?php

namespace App\Http\Controllers\Front;

use Throwable;
use App\Models\Room;
use Omnipay\Omnipay;
use App\Models\Booking;
use App\Models\Payment;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;

class PaymentController extends Controller
{
    private $gateway;

    public function __construct()
    {
        $this->gateway = Omnipay::create('PayPal_Rest');
        $this->gateway->setClientId(env('PAYPAL_CLIENT_ID'));
        $this->gateway->setSecret(env('PAYPAL_CLIENT_SECRET'));
        $this->gateway->setTestMode(true);
    }

    public function pay(Request $request)
    {
        try {
            $booking = new Booking();

            $booking->student_id = Auth::guard('student')->user()->id;
            $booking->room_id = $request->room_id;
            $booking->check_in = $request->from_date;
            $booking->check_out = $request->to_date;

            $booking->save();

            $roomStatus = Room::findOrFail($request->room_id);
            $roomStatus->status = false;
            $roomStatus->update();

            $response = $this->gateway->purchase([
                'amount' => $request->price,
                'currency' => env('PAYPAL_CURRENCY'),
                'returnUrl' => url('success'),
                'cancelUrl' => url('error')
            ])->send();

            if ($response->isRedirect()) {
                $response->redirect();
            } else {
                return $response->getMessage();
            }
        } catch (Throwable $e) {
            return $e->getMessage();
        }
    }

    public function success(Request $request)
    {
        $transaction_number = Str::random(10);

        if ($request->paymentId && $request->PayerID) {
            $transaction = $this->gateway->completePurchase([
                'payer_id' => $request->PayerID,
                'transactionReference' => $request->paymentId
            ]);

            $response = $transaction->send();

            if ($response->isSuccessful()) {
                $arr = $response->getData();

                $payment = new Payment();
                $payment->student_id = Auth::guard('student')->user()->id;
                $payment->transaction_number = $transaction_number . '-' . now();
                $payment->amount = $arr['transactions'][0]['amount']['total'];
                $payment->payment_mode = 'PayPal';
                $payment->is_paid = true;

                $payment->save(); 

                $body = "Payment has been successfully completed. 
                Transaction number: " . $payment->transaction_number . 
                    " Amount paid: " . $payment->amount . ' USD.';
                
                $current_date = now()->format('d-m-Y') . ', ' . now()->format('H:i:s'); 

                Mail::send(
                    'student-dashboard.student.payment-verification',
                    ['body' => $body, 'current_date' => $current_date],

                    function ($message) {
                        $message->from('hostel@uaut.ac.tz', 'Hostel Management System');
                        $message->to(Auth::guard('student')->user()->email)
                            ->subject('Hostel Fee Payment');
                    }
                );

                return redirect()->route('studentDashboard')->with('success', "Booking has been completed successfully!");
            } else {
                return $response->getMessage();
            }
        }
    }
    public function error()
    {
        return redirect()->back()->with('error', 'You have cancelled the payment proccess');
    }
}
