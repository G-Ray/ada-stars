with SDL_SDL_h; use SDL_SDL_h;
with Interfaces.C; use Interfaces.C;
with Ada.Text_IO; use Ada.Text_IO;
with SDL_SDL_stdinc_h;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with System; use System;
with SDL_SDL_video_h; use SDL_SDL_video_h;
with GL_gl_h; use GL_gl_h;
with GL_glu_h; use GL_glu_h;
with SDL_SDL_ttf_h; use SDL_SDL_ttf_h;
with SDL_SDL_timer_h; use SDL_SDL_timer_h;
with Ada.Real_Time;
with GNAT.OS_Lib;
with Ada.Task_Identification;
with Ada.Exceptions;
use Ada.Exceptions;
with Ada.Task_Termination; use Ada.Task_Termination;
with GNAT.Traceback.Symbolic; use GNAT.Traceback.Symbolic;
with SDL_SDL_events_h; use SDL_SDL_events_h;
with SDL_SDL_keysym_h; use SDL_SDL_keysym_h;

package body SDL_Helper is

   Window_Width  : Integer;
   Window_Height : Integer;

   Stop          : Boolean := False;
   Loop_User_Cbk : User_Callback_T;
   Projection_User_Cbk : Projection_User_Callback_T;

   bpp           : constant Interfaces.C.int := 32;
   flags         : constant Interfaces.C.unsigned := SDL_OPENGL + SDL_HWSURFACE + SDL_RESIZABLE;
   surface       : access SDL_Surface;


   function Get_Window_Width return Integer is
   begin
      return Window_Width;
   end Get_Window_Width;


   function Get_Window_Height return Integer is
   begin
      return Window_Height;
   end Get_Window_Height;


   -----------
   -- Check --
   -----------

   procedure Check (Ret : Int) is
   begin
      if Ret /= 0 then
         raise Display_Error;
      end if;
   end Check;

   procedure Init_SDL is
   begin
      --  SDL is comprised of 8 subsystems. Here we initialize the video
      if SDL_Init (SDL_INIT_VIDEO) < 0 then
         Put_Line ("Error initializing SDL");
         SDL_SDL_h.SDL_Quit;
      end if;
   end Init_SDL;


   -------------------
   -- Set_SDL_Video --
   -------------------

   procedure Set_SDL_Video (Window_Width : Integer; Window_Height : Integer) is
      vidInfo : access SDL_VideoInfo;

   begin
      --  To center a non-fullscreen window we need to set an environment
      --  variable

      Check (SDL_SDL_stdinc_h.SDL_putenv (New_String ("SDL_VIDEO_CENTERED=center")));

      --  the video info structure contains the current video mode. Prior to
      --  calling setVideoMode, it contains the best available mode
      --  for your system. Post setting the video mode, it contains
      --  whatever values you set the video mode with.
      --  First we point at the SDL structure, then test to see that the
      --  point is right. Then we copy the data from the structure to
      --  the safer vidInfo variable.

      declare
         ptr  : System.Address := SDL_GetVideoInfo;
         for ptr'Address use vidInfo'Address;
      begin
         if ptr = System.Null_Address then
            Put_Line ("Error querying video info");
            SDL_SDL_h.SDL_Quit;
            return;
         end if;
      end;

      --  according to the SDL documentaion, the flags parameter passed to setVideoMode
      --  affects only the 2D SDL surface, not the openGL. To set their properties
      --  use the syntax below. We enable vsync because we are running the loop
      --  unfettered and we don't want the loop redrawing the buffer
      --  while it is being written to screen

      Check (SDL_GL_SetAttribute (SDL_GL_SWAP_CONTROL, 1)); --enable vsync
      Check (SDL_GL_SetAttribute (SDL_GL_RED_SIZE, 8));
      Check (SDL_GL_SetAttribute (SDL_GL_GREEN_SIZE, 8));
      Check (SDL_GL_SetAttribute (SDL_GL_BLUE_SIZE, 8));
      Check (SDL_GL_SetAttribute (SDL_GL_DEPTH_SIZE, 16));
      Check (SDL_GL_SetAttribute (SDL_GL_MULTISAMPLEBUFFERS, 1));
      Check (SDL_GL_SetAttribute (SDL_GL_MULTISAMPLESAMPLES, 2));
      Check (SDL_GL_SetAttribute (SDL_GL_DOUBLEBUFFER, 1));

      --  the setVideoMode function returns the current frame buffer as an
      --  SDL_Surface. Again, we grab a pointer to it, then place its
      --  content into the non pointery surface variable. I say 'non-pointery',
      --  but this SDL variable must have a pointer in it because it can
      --  access the current pixels in the framebuffer.

      surface := SDL_SetVideoMode (int (Window_Width), int (Window_Height), bpp, flags);

      if surface = null then
         Put_Line ("Error setting the video mode");
         SDL_SDL_h.SDL_Quit;
         return;
      end if;
   end Set_SDL_Video;


   ---------------------------------
   -- Set_Orthographic_Projection --
   ---------------------------------

   procedure Set_Orthographic_Projection (Screen_Width  : Integer;
                                          Screen_Height : Integer;
                                          Near_Clipping : Float;
                                          Far_Clipping  : Float) is
      Ratio : GLdouble := GLdouble (Screen_Width) / GLdouble (Screen_Height);
   begin
      glMatrixMode (GL_PROJECTION);
      glLoadIdentity;

      if Screen_Width > Screen_Height then
         glOrtho (-100.0 * Ratio, 100.0 * Ratio, -100.0, 100.0, GLDouble (Near_Clipping), GLDouble (Far_Clipping));
      else
         glOrtho (-100.0, 100.0, -100.0 / Ratio, 100.0 / Ratio, GLDouble (Near_Clipping), GLDouble (Far_Clipping));
      end if;

      glViewport (0, 0, GLsizei (Screen_Width), GLsizei (Screen_Height));

      glMatrixMode (GL_MODELVIEW);

   end Set_Orthographic_Projection;

   --------------------------------
   -- Set_Perspective_Projection --
   --------------------------------

   procedure Set_Perspective_Projection (Screen_Width : Integer ; Screen_Height : Integer) is
      Ratio : GLdouble := GLdouble (Screen_Width) / GLdouble (Screen_Height);
   begin
      glMatrixMode (GL_PROJECTION);
      glLoadIdentity;

      gluPerspective (70.0, Ratio, 1.0, 80000.0);

      glViewport (0, 0, GLsizei (Screen_Width), GLsizei (Screen_Height));

      glMatrixMode (GL_MODELVIEW);

   end Set_Perspective_Projection;



   ---------------------------
   -- Set_Default_Projection --
   ---------------------------

   procedure Set_Default_Projection (Screen_Width : Integer ; Screen_Height : Integer) is
   begin

      Set_Orthographic_Projection (Screen_Width, Screen_Height, -100.0, 300.0);
   end Set_Default_Projection;

   ----------------
   -- Set_OpenGL --
   ----------------

   procedure Set_OpenGL (Screen_Width : Integer ; Screen_Height : Integer) is
      type GLFloat_Array is array (Natural range <>) of aliased GLfloat;
      light_diffuse : aliased GLFloat_Array
        := (1.0, 1.0, 1.0, 1.0);
      light_position : aliased GLFloat_Array
        := (100.0, 100.0, 1.0, 1.0);

   begin
       if Projection_User_Cbk /= null then
         Projection_User_Cbk.all(Screen_Width, Screen_Width);
      else
         Set_Default_Projection (Screen_Width, Screen_Width);
      end if;


      glClearColor (0.0, 0.0, 0.0, 0.0);

      glLightfv (GL_LIGHT0, GL_DIFFUSE, light_diffuse (0)'Access);
      glLightfv (GL_LIGHT0, GL_POSITION, light_position (0)'Access);
      --glLightf (GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.0);
      -- glLightf (GL_LIGHT0, GL_LINEAR_ATTENUATION, 0.0025);
      --      glLightModeli (GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
      --     glLightf (GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.00000625);

      -- glLightf (GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.0001);
      --    glLightf (GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.0);
      --  glLightf (GL_LIGHT0, GL_LINEAR_ATTENUATION, 10.0);
      glFrontFace (GL_CW);
      glEnable (GL_LIGHTING);
      glEnable (GL_LIGHT0);
      glEnable (GL_DEPTH_TEST);
      glEnable (GL_COLOR_MATERIAL);
      glEnable (GL_NORMALIZE);
      glEnable (GL_TEXTURE_2D);
      glDepthFunc (GL_LESS);

      glMatrixMode (GL_MODELVIEW);

      --        gluLookAt (0.0, 0.0, 100.0,
      --                   0.0, 0.0, 0.0,
      --                   0.0, 1.0, 0.0);
   end Set_OpenGL;



   procedure Init (Window_Width         : Integer;
                   Window_Height        : Integer;
                   Window_Title         : String := "Default") is
   begin
      Init_SDL;

      Set_SDL_Video (Window_Width, Window_Height);

      SDL_WM_SetCaption (Title => New_String (Window_Title), Icon  => Null_Ptr);

      --  openGL is not part of SDL, rather it runs in a window handled
      --  by SDL. here we set up some openGL state

      Set_OpenGL (Window_Width, Window_Height);

      Check (TTF_Init);

   end Init;

   procedure Reshape_Window (W : Integer; H : Integer) is
      Ratio : GLdouble;

   begin
      Window_Width := W;
      Window_Height := H;

      SDL_FreeSurface (surface);
      surface := SDL_SetVideoMode (int (W), int (H), bpp, flags);

      if surface = null then
         Put_Line ("Error setting the video mode");
         SDL_SDL_h.SDL_Quit;
         return;
      end if;

      glMatrixMode (GL_PROJECTION);
      glLoadIdentity;

      Ratio := GLdouble (w) / GLdouble (h);

      if Projection_User_Cbk /= null then
         Projection_User_Cbk.all(Window_Width, Window_Height);
      else
         Set_Default_Projection (Window_Width, Window_Height);
      end if;

   end Reshape_Window;



   type Active_Key_Array_T is array (SDLK_FIRST .. SDLK_LAST) of Boolean;
   Active_Key_Array :  Active_Key_Array_T := (others => False);

   function Is_Key_Pressed (Key : SDLKey) return Boolean is
   begin
      return Active_Key_Array (Key);
   end Is_Key_Pressed;


   procedure Poll_Events is
      Evt : aliased SDL_Event;

   begin
      while SDL_PollEvent (Evt'Unchecked_Access) /= 0 loop
         case unsigned (Evt.c_type) is
            when SDL_SDL_events_h.SDL_Quit =>
               Stop := True;
            when SDL_KEYDOWN =>
               Ada.Text_IO.Put_Line ("Key DOWN sym =" & Integer'Image (Integer (Evt.Key.Keysym.Sym)));
               Active_Key_Array (Evt.Key.Keysym.Sym) := True;

               if Evt.Key.Keysym.Sym = SDLK_ESCAPE then
                  Stop := True;
               end if;

            when SDL_KEYUP =>
               Active_Key_Array (Evt.Key.Keysym.Sym) := False;

            when SDL_VIDEORESIZE =>
               Reshape_Window (Integer (Evt.resize.w), Integer (Evt.resize.h));

               --              when SDL_MOUSEBUTTONDOWN =>
               --                 declare
               --                    Pos : Mouse_Position := No_Mouse_Position;
               --                 begin
               --                    if Window_Width > Window_Height then
               --                       Pos.Y :=
               --                         -Float (Evt.motion.y) / Float (Window_Height)
               --                         * 200.0 + 100.0;
               --
               --                       Pos.X :=
               --                         (Float (Evt.motion.x) - (Float (Window_Width) / 2.0))
               --                         / Float (Window_Height) * 200.0;
               --                    else
               --                       Pos.X :=
               --                         Float (Evt.motion.x) / Float (Window_Width)
               --                         * 200.0 - 100.0;
               --
               --                       Pos.Y :=
               --                         -(Float (Evt.motion.y) - (Float (Window_Height) / 2.0))
               --                         / Float (Window_Width) * 200.0;
               --                    end if;
               --
               --                    if Evt.button.button = 1 then
               --                       Pos.Button := Left;
               --                    elsif Evt.button.button = 3 then
               --                       Pos.Button := Right;
               --                    end if;
               --
               --                    Data_Manager.Set_Last_Mouse_Position (Pos);
               --                 end;

            when others =>
               null;
         end case;
      end loop;
   end Poll_Events;


















   protected  Sync is
      entry Wait_Start;
      procedure Start (Window_Width : Integer; Window_Height : Integer; Window_Title : String);

      function Get_Window_Width return Integer;
      function Get_Window_Height return Integer;
      function Get_Window_Title return access String;

   private

      Start_Requested : Boolean := False;
      Window_Width    : Integer;
      Window_Height   : Integer;
      Window_Title  : access String;

   end Sync;


   protected body Sync is
      entry Wait_Start when Start_Requested is
      begin
         null;
      end Wait_Start;

      function Get_Window_Width return Integer is
      begin
         return Window_Width;
      end Get_Window_Width;

      function Get_Window_Height return Integer is
      begin
         return Window_Height;
      end Get_Window_Height;

      function Get_Window_Title return access String is
      begin
         return Window_Title;
      end Get_Window_Title;

      procedure Start (Window_Width  : Integer;
                       Window_Height : Integer;
                       Window_Title  : String) is
      begin
         Sync.Window_Width := Window_Width;
         Sync.Window_Height := Window_Height;
         Sync.Window_Title := new String'(Window_Title);
         Start_Requested := True;
      end Start;
   end Sync;


   procedure Start_SDL_Task (Window_Width  : Integer;
                             Window_Height : Integer;
                             Window_Title  : String) is
   begin
      Sync.Start (Window_Width, Window_Height, Window_Title);
   end Start_SDL_Task;

   -------------
   -- SDL_Task --
   -------------

   procedure Set_Loop_Cbk (Cbk : User_Callback_T) is
   begin
      Loop_User_Cbk := Cbk;
   end Set_Loop_Cbk;


   procedure Set_Projection_Cbk (Cbk : Projection_User_Callback_T) is
   begin
      Projection_User_Cbk := Cbk;
   end Set_Projection_Cbk;


   task type SDL_Task_T;


   task body SDL_Task_T is
      use Ada.Real_Time;
      Next_Time     : Time := Clock;
      Loop_Period   : Integer := 10;
   begin
      Ada.Text_IO.Put_Line ("Starting SDL_Task");
      Sync.Wait_Start;

      Init (Window_Width  => Sync.Get_Window_Width,
            Window_Height => Sync.Get_Window_Height,
            Window_Title         => Sync.Get_Window_Title.all);



      Ada.Text_IO.Put_Line ("After Wait_Start ");
      Next_Time := Clock;
      while not Stop loop
         delay until Next_Time;
         Poll_Events;
         glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

         if Loop_User_Cbk /= null then
            Loop_User_Cbk.all;
         end if;


         glFlush;
         SDL_GL_SwapBuffers;
         Next_Time := Next_Time + Milliseconds (Loop_Period);
      end loop;

      TTF_Quit;
      SDL_SDL_h.SDL_Quit;
      GNAT.OS_Lib.OS_Exit (0);
   end SDL_Task_T;

   -------------------------
   -- Exception_Reporting --
   -------------------------

   protected Exception_Reporting is
      procedure Report
        (Cause : Cause_Of_Termination;
         T     : Ada.Task_Identification.Task_Id;
         X     : Ada.Exceptions.Exception_Occurrence);
   end Exception_Reporting;

   -------------------------
   -- Exception_Reporting --
   -------------------------

   protected body Exception_Reporting is

      procedure Report
        (Cause : Cause_Of_Termination;
         T     : Ada.Task_Identification.Task_Id;
         X     : Ada.Exceptions.Exception_Occurrence) is
         pragma Unreferenced (Cause, T);
      begin
         Put_Line ("=== UNCAUGHT EXCEPTION ===");
         Put_Line (Exception_Information (X));

         Put_Line (Symbolic_Traceback (X));

         GNAT.OS_Lib.OS_Exit (1);
      end Report;

   end Exception_Reporting;


   -- Starting the SDL task
   SDL_Task : SDL_Task_T;



begin
   Set_Dependents_Fallback_Handler (Exception_Reporting.Report'Access);
   Set_Specific_Handler
     (Ada.Task_Identification.Current_Task,
      Exception_Reporting.Report'Access);
end SDL_Helper;
