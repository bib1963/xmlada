with GNAT.Command_Line;  use GNAT.Command_Line;
with Ada.Text_IO;        use Ada.Text_IO;
with Debug_Readers;      use Debug_Readers;
with Input_Sources.File; use Input_Sources.File;
with Sax.Readers;        use Sax.Readers;

procedure TestSAX is
   Read       : File_Input;
   My_Reader  : Debug_Reader;
   Name_Start : Natural;
begin
   declare
      S : constant String := Get_Argument;
   begin
      if S'Length > 0 then
         --  Base file name should be used as the public Id
         Name_Start := S'Last;
         while Name_Start >= S'First  and then S (Name_Start) /= '/' loop
            Name_Start := Name_Start - 1;
         end loop;
         Set_Public_Id (Read, S (Name_Start + 1 .. S'Last));
         Set_System_Id (Read, S);
         Open (S, Read);

      else
         Put_Line ("First argument should be xml_file_name");
         raise Invalid_Parameter;
      end if;
   end;

   --  If True, xmlns:* attributes will be reported in Start_Element
   Set_Feature (My_Reader, Namespace_Prefixes_Feature, False);
   Set_Feature (My_Reader, Validation_Feature, True);

   Parse (My_Reader, Read);
   Close (Read);

exception
   when XML_Fatal_Error =>
      Close (Read);
end TestSAX;