with Interfaces.C; use Interfaces.C;
package SpaceCraft is

   protected type SpaceCraft_T is
      procedure Set_Z(Z : Interfaces.C.double);
      procedure Set_X(X : Interfaces.C.double);
      function Get_Z return double;
      function Get_X return double;

   private
      Z : double;
      X : double;
   end SpaceCraft_T;

   procedure Init_SpaceCraft;

   SC : SpaceCraft_T;
end SpaceCraft;
