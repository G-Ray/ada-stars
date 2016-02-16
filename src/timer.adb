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
with State;

package body Timer is

   task body T is
      Timer : constant Time_Span := Ada.Real_Time.Milliseconds (Config.Timer);
      Debut : Time := Clock;
      Fin : Time := Clock;
      Clock_Pause : Time := Clock;
      END_TIMER : exception;
      Running : Boolean := True;
   begin
      Fin := Debut + Timer;

      --Pause/resume
      loop
         <<Selection>>
         select
            accept Pause do
               Clock_Pause := Clock;
               Running := False;
            end;
         or
            accept Resume do
               Fin := Fin + (Clock - Clock_Pause);
               Running := True;
            end;
         else
            null;
         end select;

         if not Running then
            delay 0.1;
            goto Selection;
         end if;
         --End Pause/resume

         --delay until Activation;
         if Fin <= Clock then
            raise END_TIMER;
         end if;

         delay 0.1;
      end loop;

      exception
      when END_TIMER => put_line("=====================Fin du timer. Vous avez gagné ! Bravo !=====================");
         State.Terminated := True;
      when others    => put_line("Erreur!");
   end T;

end Timer;
