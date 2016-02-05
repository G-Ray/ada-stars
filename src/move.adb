with SpaceCraft; use SpaceCraft;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Interfaces.C.Extensions; use Interfaces.C;

package body Move is

   task body T is
      Period : constant Time_Span := Ada.Real_Time.Milliseconds (1000); --target 60fps
      Activation : Time := Clock;
   begin
      loop
         SC.set_Z (SC.Get_Z - 0.001);
         --Put_Line(double'Image(SC.Get_Z));
         Activation := Activation + Period;
         delay until Activation;
      end loop;
   end T;

end Move;
