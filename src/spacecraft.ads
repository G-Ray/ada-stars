with Interfaces.C; use Interfaces.C;
package SpaceCraft is

   protected type SpaceCraft_T is
      procedure Set_Z(Z : Interfaces.C.double);
      function Get_Z return double;

   private
      Z : double;
   end SpaceCraft_T;

   procedure Init_SpaceCraft;

   SC : SpaceCraft_T;
end SpaceCraft;
