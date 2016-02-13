with SDL_Helper; use SDL_Helper;
with GL_glu_h; use GL_glu_h;
with System;
with GL_gl_h; use GL_gl_h;
with Scene;
with Ada.Text_IO; use Ada.Text_IO;
with SDL_SDL_keysym_h; use SDL_SDL_keysym_h;
with Asteroid;
with SpaceCraft;
with Move;
with Collision;

procedure Main is
   Collision_Task : Collision.T;
begin
   Asteroid.Init_Asteroids;
   SpaceCraft.Init_SpaceCraft;

   SDL_Helper.Set_Loop_Cbk (Scene.Draw'Access);
   SDL_Helper.Set_Projection_Cbk (Scene.Set_Projection'Access);
   SDL_Helper.Start_SDL_Task (800, 600, "Asteroid");

   loop
      null;
   end loop;

end Main;
