with SDL_Helper; use SDL_Helper;
with GL_glu_h; use GL_glu_h;
with System;
with GL_gl_h; use GL_gl_h;

package  body Test is

   Quadric : System.Address := gluNewQuadric; -- besoin de reserver un espace

   procedure Test is
   begin
      GL_gl_h.glMatrixMode (GL_MODELVIEW);
      glPushMatrix;
      glTranslated (0.0, 0.0, GLdouble(-100.0));

      glColor3d (0.0, 0.0, 1.0);
      gluSphere
        (qobj => Quadric,
         radius => GLdouble (20.0),
         slices => 40,
         stacks => 40);
      glPopMatrix;
   end Test;

   procedure Set_Projection (Width: Integer;
                             Height: Integer) is
      Ratio : GLdouble := GLdouble (Width / Height);
   begin
      glMatrixMode (GL_PROJECTION);
      glLoadIdentity;
      gluPerspective (70.0, Ratio, 1.0, 2000.0);
      glViewport (0, 0, GLsizei (Width), GLsizei (Height));
      glMatrixMode (GL_MODELVIEW);
--      Set_Perspective_Projection (Width, Height);
   end Set_Projection;

end Test;
