<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class FestivosRequest extends FormRequest
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
            'año' => 'required'
        ];
    }
    public function messages()
    {
        return [
            'año.required' => 'El :attribute es obligatorio.',
        ];
    }
    public function attributes()
    {
        return [
            'año' => 'año'
        ];
    }
}
