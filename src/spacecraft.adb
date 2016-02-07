package body SpaceCraft is

   protected body  SpaceCraft_T is
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
   end SpaceCraft_T;

   procedure Init_SpaceCraft is
   begin
      SC.Set_Z (-0.1);
      SC.Set_X (0.0);
      SC.Set_Y (0.0);
   end Init_SpaceCraft;

end SpaceCraft;
