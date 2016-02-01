with SDL_Helper; use SDL_Helper;
with GL_glu_h; use GL_glu_h;
with System;
with GL_gl_h; use GL_gl_h;
with Asteroid; use Asteroid;
with Ada.Text_IO; use Ada.Text_IO;

package  body Scene is

   Quadric : System.Address := gluNewQuadric; -- besoin de reserver un espace

   procedure Draw is

   begin

      --glMatrixMode (GL_MODELVIEW);
      glClear(GL_COLOR_BUFFER_BIT);

      -- pour chaque asteroid
      for A of Asteroids loop
         glPushMatrix;
         glLoadIdentity;

         A.Z := A.Z + 1.0;
         Put_Line(Integer'Image(Integer(A.Z)));
         glTranslated (GLdouble(A.X), GLdouble(A.Y), GLdouble(A.Z));
         glColor3d (GLdouble(A.R), GLdouble(A.G), GLdouble(A.B));
         gluSphere
           (qobj => Quadric,
            radius => GLdouble (A.Radius),
            slices => 40,
            stacks => 40);
         glPopMatrix;

         delay Duration(0.01);
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
      glMatrixMode (GL_MODELVIEW);
      --      Set_Perspective_Projection (Width, Height);
   end Set_Projection;

end Scene;
