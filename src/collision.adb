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

package body Collision is

   task body T is
      Period : constant Time_Span := Ada.Real_Time.Milliseconds (Config.Period_Collision);
      Activation : Time := Clock;
      Distance : double;
      COLLISION : exception;
      Running : Boolean := True;

   begin
      loop
         <<Selection>>
         select
            accept Pause do
               Running := False;
            end;
         or
            accept Resume do
               Running := True;
            end;
         else
            null;
         end select;

         if not Running then
            Activation := Activation + Period;
            delay until Activation;
            goto Selection;
         end if;

         for A of Asteroids loop
            Distance := - double (A.Z + A.Radius) - (SC.Get_Z_Pos - SC.Get_Radius); -- on prend en compte le radius
            if Distance < SC.Get_Radius and Distance > 0.0 then
               -- Put_Line ("....eval...");
               -- calcul de la distance entre 2 points
               Distance := double (Sqrt ( Float ( (SC.Get_X_Pos - double(A.X))**2 +
                                   (SC.Get_Y_Pos - double(A.Y))**2 + (-SC.Get_Z_Pos - double(A.Z))**2) ) );
               if Distance <= (SC.Get_Radius + double(A.Radius)) then
                  raise COLLISION;
               end if;
            end if;
         end loop;
         Activation := Activation + Period;
         delay until Activation;
      end loop;

      exception
      when COLLISION => put_line("Collision avec un asteroid ! Vous êtes mort!"); State.Terminated := True; --TODO : handle this
      when others    => put_line("Erreur!");
   end T;

end Collision;
