{
   ddate.pas
   
   Copyright 2020 Ricardo Jurczyk Pinheiro <ricardo@aragorn>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}


program ddate;

const
    

var i : byte;


procedure CommandHelp;
begin
    fastwriteln(' Usage: ddate <day> <month <year>.');
    fastwriteln(' convert Gregorian dates to Discordian dates.');
    fastwriteln(' ');
    fastwriteln(' If called with no arguments, ddate will get the ');
    fastwriteln(' current system date, convert this to the Discordian ');
    fastwriteln(' date format and print this on the standard  output.');
    fastwriteln(' Alternatively, a Gregorian date may be specified on ');
    fastwriteln(' the command line, in the form of a numerical day, ');
    fastwriteln(' month and year.');
    fastwriteln(' ');
    halt;
end;

procedure CommandVersion;
begin
    fastwriteln('ddate version 0.1'); 
    fastwriteln('Copyright (c) 2020 Brazilian MSX Crew.');
    fastwriteln('Some rights reserved.');
    fastwriteln('This software claims to be distributed due to the GPL v3 license.');
    fastwriteln(' ');
    fastwriteln('Notas de versao: ');
    fastwriteln('In this moment, this utility does this date conversion.'); 
    fastwriteln('Nothing else. I have done it in a Saturday sleepless night.');
    fastwriteln('So... Take it easy.');
    fastwriteln(' ');
    halt;
end;



BEGIN
    
    GetMSXDOSVersion (version);

    if (version.nKernelMajor < 2) then
    begin
        fastwriteln('MSX-DOS 1.x not supported. Sorry pal.');
        halt;
    end;
    
    for b := 1 to 4 do 
        CommandEntryList[b] := paramstr(b);


	
	
END.

