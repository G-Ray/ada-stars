package body SpaceCraft is

   protected body  SpaceCraft_T is
      procedure Set_Z(Z : double) is
      begin
         SpaceCraft_T.Z := Z;
      end Set_Z;

      function Get_Z return double is
      begin
         return Z;
      end Get_Z;
   end SpaceCraft_T;

   procedure Init_SpaceCraft is
   begin
      SC.Set_Z(-1.0);
   end Init_SpaceCraft;

end SpaceCraft;
