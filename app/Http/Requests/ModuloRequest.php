<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ModuloRequest extends FormRequest
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
            'nombre' => 'required',
            'duracion' => 'required'
        ];
    }
    public function messages()
    {
        return [
            'nombre.required' => 'El :attribute es obligatorio.',
            'duracion.required' => 'La :attribute es obligatoria.',
        ];
    }
    public function attributes()
    {
        return [
            'nombre' => 'nombre'
        ];
    }
}