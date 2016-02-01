package body Asteroid is

   procedure Init_Asteroids is
   begin
      Asteroids(1).X := 0.0;
      Asteroids(1).Y := 0.0;
      Asteroids(1).Z := -200.0;
      Asteroids(1).R := 1.0;
      Asteroids(1).Radius := 5.0;

      Asteroids(2).X := 30.0;
      Asteroids(2).Y := 30.0;
      Asteroids(2).Z := -100.0;
      Asteroids(2).G := 1.0;
      Asteroids(2).Radius := 5.0;

      Asteroids(3).X := 15.0;
      Asteroids(3).Y := -15.0;
      Asteroids(3).Z := -50.0;
      Asteroids(3).B := 1.0;
      Asteroids(3).Radius := 5.0;
   end Init_Asteroids;

end Asteroid;
