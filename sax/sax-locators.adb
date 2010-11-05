-----------------------------------------------------------------------
--                XML/Ada - An XML suite for Ada95                   --
--                                                                   --
--                       Copyright (C) 2001-2010, AdaCore            --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

with GNAT.Directory_Operations; use GNAT.Directory_Operations;
with Sax.Symbols;  use Sax.Symbols;

package body Sax.Locators is
   use Locators;

   procedure Allocate_If_Null (Loc : in out Locator);
   --  Allocate new memory for Loc if it is unset

   ----------------------
   -- Allocate_If_Null --
   ----------------------

   procedure Allocate_If_Null (Loc : in out Locator) is
      Tmp : Locators.Encapsulated_Access;
   begin
      if Get (Loc) = null then
         Tmp := new Locator_Record;
         Loc := Allocate (Tmp);
      end if;
   end Allocate_If_Null;

   ---------------------
   -- Get_Line_Number --
   ---------------------

   function Get_Line_Number (Loc : Locator) return Natural is
   begin
      if Get (Loc) = null then
         return 0;
      else
         return Get (Loc).Loc.Line;
      end if;
   end Get_Line_Number;

   -----------------------
   -- Get_Column_Number --
   -----------------------

   function Get_Column_Number (Loc : Locator) return Natural is
   begin
      if Get (Loc) = null then
         return 0;
      else
         return Get (Loc).Loc.Column;
      end if;
   end Get_Column_Number;

   -------------------
   -- Get_System_Id --
   -------------------

   function Get_System_Id (Loc : Locator) return Symbol is
   begin
      if Get (Loc) = null then
         return Empty_String;
      else
         return Get (Loc).Loc.System_Id;
      end if;
   end Get_System_Id;

   -------------------
   -- Get_Public_Id --
   -------------------

   function Get_Public_Id (Loc : Locator) return Symbol is
   begin
      if Get (Loc) = null then
         return Empty_String;
      else
         return Get (Loc).Loc.Public_Id;
      end if;
   end Get_Public_Id;

   -----------------------
   -- Set_Column_Number --
   -----------------------

   procedure Set_Column_Number (Loc : in out Locator; Column : Natural := 0) is
   begin
      Allocate_If_Null (Loc);
      Get (Loc).Loc.Column := Column;
   end Set_Column_Number;

   ----------------------------
   -- Increase_Column_Number --
   ----------------------------

   procedure Increase_Column_Number
     (Loc : in out Locator; Inc : Natural := 1) is
   begin
      Get (Loc).Loc.Column := Get (Loc).Loc.Column + Inc;
   end Increase_Column_Number;

   --------------------------
   -- Increase_Line_Number --
   --------------------------

   procedure Increase_Line_Number (Loc : in out Locator; Inc : Natural := 1) is
   begin
      Get (Loc).Loc.Line := Get (Loc).Loc.Line + Inc;
   end Increase_Line_Number;

   ---------------------
   -- Set_Line_Number --
   ---------------------

   procedure Set_Line_Number (Loc : in out Locator; Line : Natural := 0) is
   begin
      Allocate_If_Null (Loc);
      Get (Loc).Loc.Line := Line;
   end Set_Line_Number;

   ------------------
   -- Get_Location --
   ------------------

   function Get_Location (Loc : Locator) return Location is
   begin
      return Get (Loc).Loc;
   end Get_Location;

   ------------------
   -- Set_Location --
   ------------------

   procedure Set_Location (Loc : in out Locator; To : Location) is
   begin
      Allocate_If_Null (Loc);
      Get (Loc).Loc := To;
   end Set_Location;

   -------------------
   -- Set_Public_Id --
   -------------------

   procedure Set_Public_Id (Loc : in out Locator; Id : Symbol) is
   begin
      Allocate_If_Null (Loc);
      Get (Loc).Loc.Public_Id := Id;
   end Set_Public_Id;

   -------------------
   -- Set_System_Id --
   -------------------

   procedure Set_System_Id (Loc : in out Locator; Id : Symbol) is
   begin
      Allocate_If_Null (Loc);
      Get (Loc).Loc.System_Id := Id;
   end Set_System_Id;

   ---------------
   -- To_String --
   ---------------

   function To_String
     (Loc : Locator; Use_Basename : Boolean := False) return String
   is
   begin
      if Get (Loc) = null then
         return "";
      else
         return To_String (Get_Location (Loc), Use_Basename);
      end if;
   end To_String;

   ---------------
   -- To_String --
   ---------------

   function To_String
     (Loc : Location; Use_Basename : Boolean := False) return String
   is
      C    : constant Natural := Loc.Column;
      Line : constant String := Natural'Image (Loc.Line);
      Col  : constant String := Natural'Image (C);
      Public : constant Symbol := Loc.Public_Id;
   begin
      if Public = No_Symbol then
         return "";
      elsif C /= 0 then
         if Use_Basename then
            return (Base_Name (Get (Public).all) & ':'
                    & Line (Line'First + 1 .. Line'Last)
                    & ':' & Col (Col'First + 1 .. Col'Last));
         else
            return (Get (Public).all & ':'
                    & Line (Line'First + 1 .. Line'Last)
                    & ':' & Col (Col'First + 1 .. Col'Last));
         end if;
      else
         if Use_Basename then
            return
              (Base_Name (Get (Public).all)
               & ':' & Line (Line'First + 1 .. Line'Last));
         else
            return (Get (Public).all
                    & ':' & Line (Line'First + 1 .. Line'Last));
         end if;
      end if;
   end To_String;

end Sax.Locators;
