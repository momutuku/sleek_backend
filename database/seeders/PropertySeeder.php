<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Property;
use App\Models\User;
use Faker\Factory as Faker;

class PropertySeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = Faker::create();

        $userIds = User::pluck('id')->toArray();

        for ($i = 0; $i < 10; $i++) {
            Property::create([
                'name' => $faker->word ,
                'owner_id' => $faker->randomElement($userIds),
                'gpslocation' => $faker->latitude . ', ' . $faker->longitude,
                'description' => $faker->sentence(10),
                'amenities' => implode(', ', $faker->words(5)),
                'image' => $faker->imageUrl(640, 480, 'buildings', true, 'Property'),
                'cost' => $faker->randomFloat(2, 10000, 50000),
                'location' => $faker->city,
                'active' => $faker->boolean,
            ]);
        }
    }
}
