with SDL_Helper; use SDL_Helper;
with GL_glu_h; use GL_glu_h;
with System;
with GL_gl_h; use GL_gl_h;
with Asteroid; use Asteroid;
with Ada.Text_IO; use Ada.Text_IO;
with Interfaces.C.Extensions; use Interfaces.C;
with Ada.Real_Time; use Ada.Real_Time;
with SpaceCraft; use SpaceCraft;
with SDL_SDL_stdinc_h;
with SDL_SDL_timer_h; use SDL_SDL_timer_h;
with Config;

package  body Scene is

   Quadric : System.Address := gluNewQuadric; -- besoin de reserver un espace
   Frames : Integer := 0;
   CurrentTime : SDL_SDL_stdinc_h.Uint32;
   LastTime : SDL_SDL_stdinc_h.Uint32;
   Distance : double;
   type Light is array (Integer range <>) of GLfloat;
   Lightpos : Light (1 .. 4);
   Red : Float;
   --X : double;

   procedure Draw is

   begin
      CurrentTime :=  SDL_GetTicks;
      Frames := Frames + 1;
      --glMatrixMode (GL_MODELVIEW);
      --glClear(GL_COLOR_BUFFER_BIT);

      if CurrentTime - LastTime >= 1000 then
         Put(Integer'Image(Frames));
         Put("FPS");
         Put(Float'Image(Float(1000/Frames)));
         Put("ms/frame");
         New_Line;
         Frames := 0;
         LastTime := SDL_GetTicks;
      end if;

      --gluLookAt(SC.Get_X, SC.Get_Y, SC.Get_Z, 0.0, 0.0, SC.Get_Z_Pos + SC.Get_Z, 0.0, 1.0, 0.0); --regarde vers l'horizon
      SC.Set_X_Pos(SC.Get_X_Pos + SC.Get_X);
      SC.Set_Y_Pos(SC.Get_Y_Pos + SC.Get_Y);
      SC.Set_Z_Pos(SC.Get_Z_Pos - SC.Get_Z);
      --Put_Line(double'Image(SC.Get_X));

      if SC.Get_X_Pos > double(Config.Level_Radius) or SC.Get_X_Pos < double(-Config.Level_Radius) or
        SC.Get_Y_Pos > double(Config.Level_Radius) or SC.Get_Y_Pos < double(-Config.Level_Radius)
      then
         Red := Red + 0.005;
         if Red > 1.0 then Red := 1.0; end if;
         glClearColor(Red, 0.0, 0.0, 0.0);
      else
         Red := Red - 0.005;
         if Red < 0.0 then Red := 0.0; end if;
         glClearColor (Red, 0.0, 0.0, 0.0);
      end if;

      Lightpos(1) := 0.0;
      Lightpos(2) := 0.0;
      Lightpos(3) := 1.0;
      Lightpos(4) := 0.0;

      glLightfv (GL_LIGHT0, GL_POSITION, lightpos(1)'Unrestricted_Access);

--        glPushMatrix;
--        glTranslated (0.0, 0.0, -1000.0);
--        glColor4d(0.0, 1.0, 0.0, 1.0);
--        gluCylinder
--          (qobj       => Quadric,
--           baseRadius => 40.0,
--           topRadius  => 40.0,
--           height     => 1000.0,
--           slices     => 40,
--           stacks     => 40);
--        glPopMatrix;

      -- pour chaque asteroid
      for A of Asteroids loop
         Distance := - double (A.Z) - SC.Get_Z_Pos;
         --Put_Line(double'Image(Distance));
         if Distance <  Config.Distance_visibility and Distance > 0.0 then
            glPushMatrix;
            glTranslated (GLdouble(A.X), GLdouble(A.Y), GLdouble(A.Z));
            glColor3d (GLdouble(A.R), GLdouble(A.G), GLdouble(A.B));
            gluSphere
              (qobj => Quadric,
               radius => GLdouble (A.Radius),
               slices => Config.Sphere_detail,
               stacks => Config.Sphere_detail);
            glPopMatrix;
         end if;
         --delay Duration(0.05);
      end loop;

      glTranslated(-SC.Get_X, -SC.Get_Y, -SC.Get_Z);
   end Draw;

   procedure Set_Projection (Width: Integer;
                             Height: Integer) is
      Ratio : GLdouble := GLdouble (Width / Height);
   begin
      glMatrixMode (GL_PROJECTION);
      glLoadIdentity;
      gluPerspective (90.0, Ratio, 1.0, Config.Distance_visibility);
      Set_Perspective_Projection (Width, Height);
      glViewport (0, 0, GLsizei (Width), GLsizei (Height));
      --gluLookAt(0.0, 0.0, -1.0, 0.0, 0.0, -Config.Distance_visibility, 0.0, 1.0, 0.0);
      glMatrixMode (GL_MODELVIEW);
      glEnable (GL_BLEND);
      glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

      --glMatrixMode (GL_MODELVIEW);
   end Set_Projection;

end Scene;
