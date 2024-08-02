<?php

namespace App\Http\Controllers\Admin;

use App\Models\Dormitory;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\DormitoryRequest;

class DormitoryController extends Controller
{
    public function index()
    {
        $title = [
            'title' => 'Dormitories'
        ];

        $dormitories = Dormitory::orderBy('created_at', 'DESC')->get();
        return view('admin.dormitory.index', $title, compact('dormitories'));
    }

    public function add_new_dormitory()
    {
        $title = [
            'title' => 'Add dormitory'
        ];

        return view('admin.dormitory.create', $title);
    }

    public function save_dormitory(DormitoryRequest $request)
    {
        $data = $request->validated();

        $dormitory = new Dormitory();

        $dormitory->name = $data['name'];
        $dormitory->description = $data['description'];

        $dormitory->save();

        return redirect()->route('dormitories')->with('success', 'Dormitory has been saved successfully!');
    }

    public function edit_dormitory($dormitory_id)
    {
        $title = [
            'title' => 'Update dormitory'
        ];
        $dormitory = Dormitory::findOrFail($dormitory_id);

        return view('admin.dormitory.update', $title, compact('dormitory'));
    }

    public function update_dormitory(Request $request, $dormitory_id)
    {
        $rules = [
            'name' => 'required'
        ];

        $messages = [
            'name.required' => 'Dormitory name is required'
        ];

        $this->validate($request, $rules, $messages);

        $dormitory = Dormitory::findOrFail($dormitory_id);

        if ($dormitory) {
            $dormitory->name = $request->name;
            $dormitory->description = $request->description;

            $dormitory->update();

            return redirect()->route('dormitories')->with('success', 'Dormitory has been updated successfully!');
        }
    }

    public function destroy($dormitory_id)
    {
        $dormitory = Dormitory::findOrFail($dormitory_id);

        if ($dormitory) {
            $dormitory->delete();

            return redirect()->route('dormitories')->with('error', 'Dormitory has been deleted successfully!');
        }
    }
}
