-----------------------------------------------------------------------
--                XML/Ada - An XML suite for Ada95                   --
--                                                                   --
--                       Copyright (C) 2002-2003                     --
--                            ACT-Europe                             --
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

with Unicode;
with Unicode.CES;

package Input_Sources.Http is

   Http_Error : exception;

   type Http_Input is new Input_Source with private;
   type Http_Input_Access is access all Http_Input'Class;
   --  A special implementation of a reader, that reads from http location.

   procedure Open
     (Hostname : String;
      Port     : Positive := 80;
      Filename : String;
      Input    : out Http_Input);
   --  Open a new file for reading from http://Hostname:Port/Filename.
   --  Raise Http_Error if the URL could not be parsed.

   procedure Open (URL : String; Input : out Http_Input);
   --  Same as above, but processes directly a URL

   procedure Close (Input : in out Http_Input);
   --  Free the memory

   procedure Next_Char
     (From : in out Http_Input;
      C    : out Unicode.Unicode_Char);
   --  Return the next character in the buffer.

   function Eof (From : Http_Input) return Boolean;
   --  True if From is past the last character in the buffer.

private
   type Http_Input is new Input_Source with record
      Index  : Natural;
      Buffer : Unicode.CES.Byte_Sequence_Access;
   end record;
end Input_Sources.Http;
