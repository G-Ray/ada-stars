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

package  body Scene is

   Quadric : System.Address := gluNewQuadric; -- besoin de reserver un espace
   Frames : Integer := 0;
   CurrentTime : SDL_SDL_stdinc_h.Uint32;
   LastTime : SDL_SDL_stdinc_h.Uint32;
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
      glMatrixMode (GL_PROJECTION);
      gluLookAt(SC.Get_X, 0.0, SC.Get_Z, 0.0, 0.0, -1000.0, 0.0, 1.0, 0.0);
      glMatrixMode (GL_MODELVIEW);

      -- pour chaque asteroid
      for A of Asteroids loop
         glPushMatrix;
         glLoadIdentity;

         --A.Z := A.Z + 1.0;
         --Put_Line(Integer'Image(Integer(A.Z)));
         glTranslated (GLdouble(A.X), GLdouble(A.Y), GLdouble(A.Z));
         glColor3d (GLdouble(A.R), GLdouble(A.G), GLdouble(A.B));
         gluSphere
           (qobj => Quadric,
            radius => GLdouble (A.Radius),
            slices => 40,
            stacks => 40);
         glPopMatrix;

         --delay Duration(0.05);
      end loop;

   end Draw;

   procedure Set_Projection (Width: Integer;
                             Height: Integer) is
      Ratio : GLdouble := GLdouble (Width / Height);
   begin
      glMatrixMode (GL_PROJECTION);
      glLoadIdentity;
      gluPerspective (90.0, Ratio, 1.0, 2000.0);
      glViewport (0, 0, GLsizei (Width), GLsizei (Height));
      gluLookAt(0.0, 0.0, -1.0, 0.0, 0.0, -100.0, 0.0, 1.0, 0.0);
      glMatrixMode (GL_MODELVIEW);
      --      Set_Perspective_Projection (Width, Height);
   end Set_Projection;

end Scene;
