with SDL_Helper; use SDL_Helper;
with GL_glu_h; use GL_glu_h;
with System;
with GL_gl_h; use GL_gl_h;
with Test;

procedure Main is

begin

   SDL_Helper.Set_Loop_Cbk (Test.Test'Access);
   SDL_Helper.Set_Projection_Cbk (Test.Set_Projection'Access);
   SDL_Helper.Start_SDL_Task (800, 600, "Asteroid");

   loop
      --if SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_LEFT) then
        --Ada.Text_IO.
      --end if
      null;
   end loop;

end Main;
