with Config;
package body SpaceCraft is

   protected body  SpaceCraft_T is
      --Setters
      procedure Set_Z(Z : double) is
      begin
         SpaceCraft_T.Z := Z;
      end Set_Z;

      procedure Set_X(X : double) is
      begin
         SpaceCraft_T.X := X;
      end Set_X;

      procedure Set_Y(Y : double) is
      begin
         SpaceCraft_T.Y := Y;
      end Set_Y;

      procedure Set_X_Pos(X : double) is
      begin
         SpaceCraft_T.X_Pos := X;
      end Set_X_Pos;

      procedure Set_Y_Pos(Y : double) is
      begin
         SpaceCraft_T.Y_Pos := Y;
      end Set_Y_Pos;

      procedure Set_Z_Pos(Z : double) is
      begin
         SpaceCraft_T.Z_Pos := Z;
      end Set_Z_Pos;

      procedure Set_Radius (Radius : double) is
      begin
         SpaceCraft_T.Radius := Radius;
      end Set_Radius;
      --End setters

      --Getters
      function Get_Z return double is
      begin
         return Z;
      end Get_Z;

      function Get_X return double is
      begin
         return X;
      end Get_X;

      function Get_Y return double is
      begin
         return Y;
      end Get_Y;

      function Get_X_Pos return double is
      begin
         return X_Pos;
      end Get_X_Pos;

      function Get_Y_Pos return double is
      begin
         return Y_Pos;
      end Get_Y_Pos;

      function Get_Z_Pos return double is
      begin
         return Z_Pos;
      end Get_Z_Pos;

      function Get_Radius return double is
      begin
         return Radius;
      end Get_Radius;
   end SpaceCraft_T;
   --End getters

   procedure Init_SpaceCraft is
   begin
      SC.Set_Z (Config.Speed);
      SC.Set_X (0.0);
      SC.Set_Y (0.0);
      SC.Set_X_Pos (0.0);
      SC.Set_Y_Pos (0.0);
      SC.Set_Z_Pos (0.0);
      SC.Set_Radius (Config.SpaceCraft_Radius);
   end Init_SpaceCraft;

end SpaceCraft;
