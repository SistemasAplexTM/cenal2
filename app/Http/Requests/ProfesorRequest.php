<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ProfesorRequest extends FormRequest
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
            'apellidos' => 'required',
            'correo' => 'required|email|unique:users,email',
            'user_id' => 'required',
        ];
    }
    public function messages()
    {
        return [
            'nombre.required' => 'El :attribute es obligatorio',
            'apellidos.required' => 'Los :attribute son obligatorios',
            'correo.required' => 'El :attribute es obligatorio',
            'user_id.required' => 'El :attribute es obligatorio',
        ];
    }
    public function attributes()
    {
        return [
            'nombre' => 'nombre',
            'apellidos' => 'apellidos',
            'correo' => 'correo',
            'user_id' => 'usuario',
        ];
    }
}
