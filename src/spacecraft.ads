with Interfaces.C; use Interfaces.C;
package SpaceCraft is

   protected type SpaceCraft_T is
      --Setters
      procedure Set_Z(Z : Interfaces.C.double);
      procedure Set_X(X : Interfaces.C.double);
      procedure Set_Y(Y : Interfaces.C.double);
      procedure Set_X_Pos(X : double);
      procedure Set_Y_Pos(Y : double);
      procedure Set_Z_Pos(Z : double);
      procedure Set_Radius(Radius : double);

      --Getters
      function Get_Z return double;
      function Get_X return double;
      function Get_Y return double;
      function Get_X_Pos return double;
      function Get_Y_Pos return double;
      function Get_Z_Pos return double;
      function Get_Radius return double;

   private
      --Speed vectors
      Z : double;
      X : double;
      Y : double;
      --Coordinates of the spacecraft
      X_Pos : double;
      Y_Pos : double;
      Z_Pos : double;
      --Radius
      Radius : double;
   end SpaceCraft_T;

   procedure Init_SpaceCraft;

   --The one and only spacecraft
   SC : SpaceCraft_T;
end SpaceCraft;
