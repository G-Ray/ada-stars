with SpaceCraft; use SpaceCraft;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Interfaces.C.Extensions; use Interfaces.C;
with SDL_SDL_keysym_h; use SDL_SDL_keysym_h;
with SDL_Helper; use SDL_Helper;
with SpaceCraft; use SpaceCraft;
with Asteroid; use Asteroid;
with Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Config;

package body Timer is

   task body T is
      Timer : constant Time_Span := Ada.Real_Time.Milliseconds (Config.Timer);
      Activation : Time := Clock;
      END_TIMER : exception;
      --Running : Boolean := True;
   begin
      Activation := Activation + Timer;
      delay until Activation;
      raise END_TIMER;

      exception
      when END_TIMER => put_line("Fin du timer"); raise; --TODO : handle this
      when others    => put_line("Erreur!");
   end T;

end Timer;
