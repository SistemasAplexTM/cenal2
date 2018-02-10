<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ClasesRequest extends FormRequest
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
            'fecha_inicio' => 'required',
            'sede_id' => 'required',
            'modulo_id' => 'required',
            'salon_id' => 'required',
        ];
    }
}
