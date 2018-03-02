<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UserRequest extends FormRequest
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
            'identification_card' => 'required|unique:users,identification_card',
            'name' => 'required',
            'last_name' => 'required',
            'email' => 'required|email|unique:users,email',
            'sede' => 'required',
        ];
    }
    public function messages()
    {
        return [
            'identification_card.required' => 'El :attribute es obligatorio',
            'name.required' => 'El :attribute es obligatorio',
            'last_name.required' => 'Los :attribute son obligatorios',
            'email.required' => 'El :attribute es obligatorio',
            'sede.required' => 'La :attribute es obligatoria',
        ];
    }
    public function attributes()
    {
        return [
            'identification_card' => 'documento',
            'name' => 'nombre',
            'last_name' => 'apellidos',
            'email' => 'correo',
        ];
    }
}
