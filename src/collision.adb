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
      COLLISION : exception;
      Period : constant Time_Span := Ada.Real_Time.Milliseconds (Config.Period_Collision);
      Activation : Time := Clock;
      Distance : double;
      Running : Boolean := True;

   begin
      loop
         --Pause/resume
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
         --End Pause/resume

         for A of Asteroids loop
            --Compute 1D distance along Z only
            Distance := - double (A.Z + A.Radius) - (SC.Get_Z_Pos - SC.Get_Radius);
            if Distance < SC.Get_Radius and Distance > 0.0 then --a collision could occur
               --Compute 3D distance between Asteroid and SC
               Distance := double (Sqrt ( Float ( (SC.Get_X_Pos - double(A.X))**2 +
                                   (SC.Get_Y_Pos - double(A.Y))**2 +
                                   (-SC.Get_Z_Pos - double(A.Z))**2) ) );

               if Distance <= (SC.Get_Radius + double(A.Radius)) then
                  --Collision detected!
                  raise COLLISION;
               end if;
            end if;
         end loop;

         Activation := Activation + Period;
         delay until Activation;
      end loop;

      exception
      when COLLISION => put_line("=====================Collision avec un asteroid ! Vous êtes mort!=====================");
         State.Terminated := True;
      when others    => put_line("Erreur!");
   end T;

end Collision;
