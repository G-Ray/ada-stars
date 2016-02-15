with Interfaces.C;
use Interfaces.C;

package Config is
   Max_Speed_X_Y : double := 1.0;
   Speed : double := -0.3;
   Speed_Step : double := 0.01;
   Period_Move : Integer := 10; --milliseconds
   Period_Collision : Integer := 10; --milliseconds
   Distance_visibility : double := 100.0;
   Sphere_detail : int := 40;
   Level_Radius : double := 30.0;
   Level_Distance : double := 1000.0;
   Asteroid_Number : Integer := 500;
   Timer : Integer := 10000; -- 10 seconds
end Config;
