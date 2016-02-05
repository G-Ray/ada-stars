with SpaceCraft; use SpaceCraft;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Interfaces.C.Extensions; use Interfaces.C;
with SDL_SDL_keysym_h; use SDL_SDL_keysym_h;
with SDL_Helper; use SDL_Helper;

package body Move is

   task body T is
      Period : constant Time_Span := Ada.Real_Time.Milliseconds (10);
      Activation : Time := Clock;
      KeyLeft: Boolean := false;
      KeyRight : Boolean := false;
   begin
      loop
         if SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_LEFT) and not keyLeft then
            SC.set_X (-0.1);
         elsif SDL_Helper.Is_Key_Pressed (SDL_SDL_keysym_h.SDLK_RIGHT) and not keyRight then
            SC.set_X (0.1);
         else SC.Set_X(0.0);
         end if;
         --Put_Line(double'Image(SC.Get_Z));
         Activation := Activation + Period;
         delay until Activation;
      end loop;
   end T;

end Move;
