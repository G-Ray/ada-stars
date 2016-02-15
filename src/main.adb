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
with Ada.Real_Time; use Ada.Real_Time;
with Config;
with Timer;
with State;
with SDL_SDL_h;

procedure Main is
   Collision_Task : Collision.T;
   Move_Task : Move.T;
   Time_Task : Timer.T;
   procedure Game is
      Pause : Boolean := False;
      Space : Boolean := False;
      Period : constant Time_Span := Ada.Real_Time.Milliseconds (Config.Period_Move);
      Activation : Time;

   begin
      Asteroid.Init_Asteroids;
      SpaceCraft.Init_SpaceCraft;
      Move_Task.Pause;
      Collision_Task.Pause;
      Time_Task.Pause;
      Pause := True;
      Activation := Clock;

      --Move_Task.Resume;
      loop

         if State.Terminated then
            return;
         end if;

         if SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_SPACE) and not Space then
            if Pause then
               Move_Task.Resume;
               Collision_Task.Resume;
               Time_Task.Resume;
               Pause := False;
            else
               Move_Task.Pause;
               Collision_Task.Pause;
               Time_Task.Pause;
               Pause := True;
            end if;
            Space := True;
         elsif not SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_SPACE) then
            Space := false;
         end if;

         Activation := Activation + Period;
         delay until Activation;
      end loop;
   end Game;

begin

   SDL_Helper.Set_Loop_Cbk (Scene.Draw'Access);
   SDL_Helper.Set_Projection_Cbk (Scene.Set_Projection'Access);
   SDL_Helper.Start_SDL_Task (800, 600, "Asteroid");

   --while not SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_SPACE) loop null; end loop;

   --start the game
   Game;
   abort Time_Task;
   abort Move_Task;
   abort Collision_Task;
   SDL_SDL_h.SDL_Quit; -- peut lever un  STORAGE_ERROR

exception
   when others => put_line("Erreur!");
end Main;
