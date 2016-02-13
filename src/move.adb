with SpaceCraft; use SpaceCraft;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Interfaces.C.Extensions; use Interfaces.C;
with SDL_SDL_keysym_h; use SDL_SDL_keysym_h;
with SDL_Helper; use SDL_Helper;
with Config;

package body Move is

   task body T is
      Period : constant Time_Span := Ada.Real_Time.Milliseconds (Config.Period_Move);
      Activation : Time := Clock;

   begin
      loop
         if SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_LEFT) and
           SC.Get_X > -Config.Max_Speed_X_Y
         then
            SC.set_X (SC.Get_X - Config.Speed_Step);
         elsif SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_RIGHT) and
           SC.Get_X < Config.Max_Speed_X_Y
         then
            SC.set_X (SC.Get_X + Config.Speed_Step);
         else -- simulate inertia
            if (SC.Get_X > 0.0) then
               SC.Set_X(SC.Get_X - Config.Speed_Step);
               if (SC.Get_X < 0.0) then SC.Set_X (0.0); end if;
            elsif (SC.Get_X < 0.0) then
               SC.Set_X(SC.Get_X + Config.Speed_Step);
               if (SC.Get_X > 0.0) then SC.Set_X (0.0); end if;
            end if;
         end if;

         if SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_UP) and SC.Get_Y < Config.Max_Speed_X_Y then
            SC.set_Y (SC.Get_Y +Config.Speed_Step);
         elsif SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_DOWN) and SC.Get_Y > -Config.Max_Speed_X_Y then
            SC.set_Y (SC.Get_Y - Config.Speed_Step);
         else -- simulate inertia
            if (SC.Get_Y > 0.0) then
               SC.Set_Y(SC.Get_Y - Config.Speed_Step);
               if (SC.Get_Y < 0.0) then SC.Set_Y (0.0); end if;
            elsif (SC.Get_Y < 0.0) then
               SC.Set_Y(SC.Get_Y + Config.Speed_Step);
               if (SC.Get_Y > 0.0) then SC.Set_Y (0.0); end if;
            end if;
         end if;

         --Put_Line(double'Image(SC.Get_Z));
         Activation := Activation + Period;
         delay until Activation;
      end loop;
   end T;

end Move;
