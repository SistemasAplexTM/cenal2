<?php

namespace App;

use Laravel\Passport\HasApiTokens;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Spatie\Permission\Traits\HasRoles;
use App\Notifications\ResetPasswordCENAL;


class User extends Authenticatable
{
    use HasApiTokens, Notifiable;
    use HasRoles;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
         'identification_card', 'name', 'last_name', 'email', 'address', 'phone','sede_id' , 'cellphone', 'password','confirmation_code', 'code',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'remember_token',
    ];

    // public function sendPasswordResetNotification($token)
    // {
    //     $this->notify(new ResetPasswordCENAL($token));
    // }
}
