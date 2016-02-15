with Ada.Numerics.Discrete_Random;
with Interfaces.C.Extensions; use Interfaces.C;
with Ada.Numerics.Float_Random;

package body Asteroid is

   subtype Asteroid_Range_X_Y is Integer range -Config.Level_Radius .. Config.Level_Radius;
   subtype Asteroid_Range_Z is Integer range -Config.Level_Distance_Far .. -Config.Level_Distance_Start;
   subtype Asteroid_Range_Radius is Integer range Config.Asteroid_Min_Radius .. Config.Asteroid_Max_Radius;
   subtype Asteroid_Range_Color is Float range 0.0 .. 1.0;

   package RandomAsteroid_X_Y is
     new  Ada.Numerics.Discrete_Random (Result_Subtype => Asteroid_Range_X_Y);
   package RandomAsteroid_Z is
     new  Ada.Numerics.Discrete_Random (Result_Subtype => Asteroid_Range_Z);
    package RandomAsteroid_Radius is
     new  Ada.Numerics.Discrete_Random (Result_Subtype => Asteroid_Range_Radius);

   procedure Init_Asteroids is
      G_X_Y  : RandomAsteroid_X_Y.Generator;
      G_Z : RandomAsteroid_Z.Generator;
      G_Radius : RandomAsteroid_Radius.Generator;
      G_Color : Ada.Numerics.Float_Random.Generator;
   begin
      RandomAsteroid_X_Y.Reset (Gen => G_X_Y);
      RandomAsteroid_Z.Reset (Gen => G_Z);
      RandomAsteroid_Radius.Reset (Gen => G_Radius);
      Ada.Numerics.Float_Random.Reset (Gen => G_Color);

      --Generate all asteroids
      for A of Asteroids loop
         --Set position
         A.X := Float (RandomAsteroid_X_Y.Random (Gen => G_X_Y));
         A.Y := Float (RandomAsteroid_X_Y.Random (Gen => G_X_Y));
         A.Z := Float (RandomAsteroid_Z.Random (Gen => G_Z));
         --Set colors
         A.R := Ada.Numerics.Float_Random.Random (Gen => G_Color);
         A.G := Ada.Numerics.Float_Random.Random (Gen => G_Color);
         A.B := Ada.Numerics.Float_Random.Random (Gen => G_Color);
         --Set radius
         A.Radius := Float (RandomAsteroid_Radius.Random (Gen => G_Radius));
      end loop;
   end Init_Asteroids;

end Asteroid;
