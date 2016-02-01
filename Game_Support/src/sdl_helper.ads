with SDL_SDL_keysym_h; use SDL_SDL_keysym_h;
package SDL_Helper is


   Display_Error : exception;

   procedure Init (Window_Width  : Integer;
                   Window_Height : Integer;
                   Window_Title         : String := "Default");

   type User_Callback_T is access procedure;
   type Projection_User_Callback_T is access procedure (Width : Integer;
                                                        Height : Integer);

   procedure Set_Loop_Cbk (Cbk : User_Callback_T);
   procedure Set_Projection_Cbk (Cbk : Projection_User_Callback_T);
   procedure Start_SDL_Task (Window_Width  : Integer;
                             Window_Height : Integer;
                             Window_Title  : String);

   procedure Set_Perspective_Projection (Screen_Width : Integer ; Screen_Height : Integer);

   function Get_Window_Width return Integer;
   function Get_Window_Height return Integer;

   function Is_Key_Pressed (Key : SDL_SDL_keysym_h.SDLKey) return Boolean;


end SDL_Helper;
