<?php

namespace App\Http\Controllers\Admin;

use App\Models\Student;
use App\Http\Controllers\Controller;

class StudentController extends Controller
{
    public function index()
    {
        $title = [
            'title' => 'Students'
        ];
        $students = Student::select([
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
            ->orderBy('students.id', 'DESC')->get();

        return view('admin.student.index', $title, compact('students'));
    }

    public function view_student_details($student_id)
    {
        $title = [
            'title' => 'Student details'
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
            ->where('students.id', $student_id)->get();

        if ($studentData) {
            return view('admin.student.details', $title, compact('studentData'));
        }
    }

    public function destroy($student_id)
    {
        $student = Student::findOrFail($student_id);

        if ($student) {

            $student->delete();

            return redirect()->route('students')->with('success', 'Student has been deleted successfully!');
        }
    }
}
