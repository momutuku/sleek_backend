<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Property;
use App\Models\PropertyImage;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class PropertyController extends Controller
{
    public function index()
    {
        return Property::with('images', 'owner')
    ->where('active', 1)
    ->get();
    }

    
    public function show($id)
    {
        $property = Property::with('images', 'owner')->find($id);

        if (!$property) {
            return response()->json(['error' => 'Property not found'], 404);
        }

        return $property;
    }

    
    public function userProperties()
    {
        $user = Auth::user();
        return Property::with('images')->where('owner_id', $user->id)->get();
    }

    
    public function store(Request $request)
    {
         $validation = Validator::make($request->all(), [
            'name' => 'required|string',
            'gpslocation' => 'required|string',
            'description' => 'nullable|string',
            'amenities' => 'nullable|string',
            'cost' => 'required|numeric',
            'location' => 'required|string',
            // 'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'image'=>'required|string',
            'extra_images' => 'nullable|array',
            'extra_images.*' => 'nullable|url',
        ]);
        if ($validation->fails()) {
    return response()->json([
        'success' => false,
        'errors' => $validation->errors(),
    ], 422);
}

        $user = Auth::user();

        
        $propertyData = $request->only(['name', 'gpslocation', 'description', 'amenities', 'cost', 'location']);
        $propertyData['owner_id'] = $user->id;

        if ($request->hasFile('image')) {
            $propertyData['image'] = $request->file('image')->store('properties');
        }

        $property = Property::create($propertyData);

        
        if ($request->has('extra_images')) {
            foreach ($request->extra_images as $imageLink) {
                PropertyImage::create([
                    'property_id' => $property->id,
                    'image' => $imageLink,
                ]);
            }
        }
        return response()->json($property->load('images'), 201);
    }
    
    public function update(Request $request, $id)
    {
        $property = Property::find($id);

        if (!$property || $property->owner_id != Auth::id()) {
            return response()->json(['error' => 'Property not found or unauthorized'], 403);
        }

        $validation = Validator::make($request->all(), [
            'name' => 'required|string',
            'gpslocation' => 'required|string',
            'description' => 'nullable|string',
            'amenities' => 'nullable|string',
            'cost' => 'required|numeric',
            'location' => 'required|string',
            // 'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'image'=>'required|string',
            'extra_images' => 'nullable|array',
            'extra_images.*' => 'nullable|url',
        ]);

        
        $property->update($request->only(['name', 'gpslocation', 'description', 'amenities', 'cost', 'location']));

        if ($request->hasFile('image')) {
            $property->image = $request->file('image')->store('properties');
            $property->save();
        }

        
        if ($request->has('extra_images')) {
            $property->images()->delete(); 
            foreach ($request->extra_images as $imageLink) {
                PropertyImage::create([
                    'property_id' => $property->id,
                    'image' => $imageLink,
                ]);
            }
        }

        return response()->json($property->load('images'));
    }

    
    public function destroy($id)
    {
        $property = Property::find($id);

        if (!$property || $property->owner_id != Auth::id()) {
            return response()->json(['error' => 'Property not found or unauthorized'], 403);
        }

        $property->delete();
        return response()->json(['message' => 'Property deleted'], 200);
    }
}
