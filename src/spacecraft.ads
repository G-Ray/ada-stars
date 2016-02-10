with Interfaces.C; use Interfaces.C;
package SpaceCraft is

   protected type SpaceCraft_T is
      procedure Set_Z(Z : Interfaces.C.double);
      procedure Set_X(X : Interfaces.C.double);
      procedure Set_Y(Y : Interfaces.C.double);
      procedure Set_Z_Pos(Z : double);
      function Get_Z return double;
      function Get_X return double;
      function Get_Y return double;
      function Get_Z_Pos return double;

   private
      Z : double;
      X : double;
      Y : double;
      Z_Pos : double;
   end SpaceCraft_T;

   procedure Init_SpaceCraft;

   SC : SpaceCraft_T;
end SpaceCraft;
