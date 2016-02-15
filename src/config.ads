with Interfaces.C;
use Interfaces.C;

package Config is
   Max_Speed_X_Y : double := 1.0;
   Speed : double := -0.3;
   Speed_Step : double := 0.01;
   Period_Move : Integer := 10; --milliseconds
   Period_Collision : Integer := 10; --milliseconds
   Distance_visibility : double := 100.0;
   Sphere_detail : int := 20;
   Level_Radius : Integer := 30;
   Level_Distance_Far : Integer := 1000;
   Level_Distance_Start : Integer := 50;
   Asteroid_Number : Integer := 500;
   Timer : Integer := 600000; -- 60 seconds
   Width :Integer := 800;
   Height : Integer := 600;
   Asteroid_Min_Radius : Integer := 3;
   Asteroid_Max_Radius : Integer := 10;
   SpaceCraft_Radius : double := 3.0;
end Config;
