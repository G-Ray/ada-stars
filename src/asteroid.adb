with Ada.Numerics.Discrete_Random;
with Interfaces.C.Extensions; use Interfaces.C;

package body Asteroid is

   subtype Asteroid_Range_X_Y is Integer range -30 .. 30;
   subtype Asteroid_Range_Z is Integer range -200 .. -20;
   subtype Asteroid_Range_Radius is Integer range 3 .. 10;
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
   begin
      RandomAsteroid_X_Y.Reset (Gen => G_X_Y);
      RandomAsteroid_Z.Reset (Gen => G_Z);
      RandomAsteroid_Radius.Reset (Gen => G_Radius);

      for A of Asteroids loop
         A.X := Float (RandomAsteroid_X_Y.Random (Gen => G_X_Y));
         A.Y := Float (RandomAsteroid_X_Y.Random (Gen => G_X_Y));
         A.Z := Float (RandomAsteroid_Z.Random (Gen => G_Z));
         A.R := 1.0;
         A.Radius := Float (RandomAsteroid_Radius.Random (Gen => G_Radius));
      end loop;

--        Asteroids(1).X := 0.0;
--        Asteroids(1).Y := 0.0;
--        Asteroids(1).Z := -200.0;
--        Asteroids(1).R := 1.0;
--        Asteroids(1).Radius := 5.0;
--
--        Asteroids(2).X := 30.0;
--        Asteroids(2).Y := 30.0;
--        Asteroids(2).Z := -100.0;
--        Asteroids(2).G := 1.0;
--        Asteroids(2).Radius := 5.0;
--
--        Asteroids(3).X := 15.0;
--        Asteroids(3).Y := -15.0;
--        Asteroids(3).Z := -50.0;
--        Asteroids(3).B := 1.0;
--        Asteroids(3).Radius := 5.0;
   end Init_Asteroids;

end Asteroid;
