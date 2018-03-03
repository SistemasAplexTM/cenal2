<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SalonRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
     {
        return [
            'sede_id' => 'required',
            'codigo' => 'required',
            'capacidad' => 'required'
        ];
    }
    public function messages()
    {
        return [
            'sede_id.required' => 'La :attribute es obligatoria',
            'codigo.required' => 'El :attribute es obligatorio',
            'capacidad.required' => 'La :attribute es obligatoria'
        ];
    }
    public function attributes()
    {
        return [
            'sede_id' => 'sede',
            'codigo' => 'código',
            'capacidad' => 'capacidad'
        ];
    }
}
