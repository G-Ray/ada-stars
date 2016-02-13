with Config;
package Asteroid is

   type Asteroid_T is record
      X_Pos : Float;
      X, Y, Z : Float;
      R, G, B : Float;
      Radius : Float;
   end record;

   type Asteroid_Array is array (Integer range <>) of Asteroid_T;

   Asteroids : Asteroid_Array(1 .. Config.Asteroid_Number);

   procedure Init_Asteroids;

end Asteroid;
