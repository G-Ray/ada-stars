with Interfaces.C;
use Interfaces.C;

package Config is

   --Window properties
   Width :Integer := 800;
   Height : Integer := 600;

   --Max speed along X and Y axis
   Max_Speed_X_Y : double := 1.0;
   --Speed over Z axis
   Speed : double := -0.3;
   --Acceleration step on x/y axis
   Speed_Step : double := 0.01;

   --Distance from where asteroids can be seen
   Distance_visibility : double := 100.0;
   --Detail of the spheres (number of vertices)
   Sphere_detail : int := 40;

   --Radius where asteroids are generated
   Level_Radius : Integer := 30;
   --Max Distance where asteroid can be generated
   Level_Distance_Far : Integer := 1000;
   --Min distance where asteroids can be generated
   Level_Distance_Start : Integer := 50;
   --Number of asteroids to generate
   Asteroid_Number : Integer := 500;

   --Time of the level
   Timer : Integer := 600000; -- 60 seconds

   --Min radius of a asteroid
   Asteroid_Min_Radius : Integer := 3;
   --Max radius of a asteroid
   Asteroid_Max_Radius : Integer := 10;
   --Radius of the Spacecraft (~= a sphere)
   SpaceCraft_Radius : double := 3.0;

   --delay periods
   Period_Move : Integer := 10; --milliseconds
   Period_Collision : Integer := 10; --milliseconds
end Config;
