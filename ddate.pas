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

{$i d:types.inc}
{$i d:fastwrit.inc}
{$i d:dos.inc}
{$i d:dostime.inc}

const
    StringSize = 8;
   
var i, j, Returned : integer;
    Day, Month, Year, BissextYear: integer;
    temporary, CommandEntry: string[StringSize];
    version: TMSXDOSVersion;
    Date: TDate;

procedure Discordian (Date: TDate);
const
    CurseOfGreyFace = -1166;
type
    DiscordianSeasonText = (Chaos,Discord,Confusion,Bureaucracy,TheAftermath);
    DiscordianWeek = (Sweetmorn,Boomtime,Pungenday,PricklePrickle,SettingOrange);
    DiscordianWeekDays = (Sweet,Boom,Pungent,Prickle,Orange);
    
var
    BissextYear: boolean;
    Factor, DayOfTheYear: integer;
    DiscordianYear, DiscordianSeason, DiscordianDay: integer;
    DiscordianDayOfTheWeek: integer;
    i: byte;
    DayText, SeasonText: string[15];

begin
    DayOfTheYear := 0;
    SeasonText := ' ';
    BissextYear := false;
    Factor := 0;
    DiscordianYear := Date.nYear - CurseOfGreyFace;

    if (Year mod 4 = 0) then
        BissextYear := true;

    for i := 1 to (Date.nMonth - 1) do
    begin
        case i of
            1: Factor := 31;
            2: if (Date.nYear mod 4 = 0) then
                    Factor := 29
                else
                    Factor := 28;
            3: Factor := 31;
            4: Factor := 30;
            5: Factor := 31;
            6: Factor := 30;
            7: Factor := 31;
            8: Factor := 31;
            9: Factor := 30;
            10: Factor := 31;
            11: Factor := 30;
            12: Factor := 31;
        end;
        DayOfTheYear := DayOfTheYear + Factor;
    end;
    DayOfTheYear := DayOfTheYear + Date.nDay;
    
    DiscordianSeason := (DayOfTheYear div 73);
    case DiscordianSeason of
        0: SeasonText := 'Chaos';
        1: SeasonText := 'Discord';
        2: SeasonText := 'Confusion';
        3: SeasonText := 'Bureaucracy';
        4: SeasonText := 'The Aftermath';
    end;
    
    DiscordianDay := (DayOfTheYear - DiscordianSeason * 73);
    
    if DiscordianDay = 0 then
        DiscordianDay := 1;

    DiscordianDayOfTheWeek := (DayOfTheYear mod 5);

    if (BissextYear = true) and (Month > 2) then
    begin
        DiscordianDay := DiscordianDay - 1;
        DiscordianDayOfTheWeek := ((DayOfTheYear - 1) mod 5);
    end;
    
    case DiscordianDayOfTheWeek of
        1: DayText := 'Sweetmorn';
        2: DayText := 'Boomtime';
        3: DayText := 'Pungenday';
        4: DayText := 'Prickle-Prickle';
        0: DayText := 'Setting Orange';
    end;

    if (BissextYear = true) and (Month = 2) and (Day = 29) then
            DayText := 'St. Tibs Day'; 
    
    writeln('Day in the year: ',DayOfTheYear);
    writeln('Discordian Year: ',DiscordianYear);
    writeln('Discordian Season: ',SeasonText);
    writeln('Discordian Day: ',DiscordianDay);
    writeln('Discordian Day of the Week: ',DayText);
end;

procedure CommandHelp;
begin
    fastwriteln(' Usage: ddate <day> <month> <year>.');
    fastwriteln(' convert Gregorian dates to Discordian dates.');
    fastwriteln(' ');
    fastwriteln(' If called with no arguments, ddate will get the ');
    fastwriteln(' current system date, convert this to the Discordian ');
    fastwriteln(' date format and print this on the standard  output.');
    fastwriteln(' Alternatively, a Gregorian date may be specified on ');
    fastwriteln(' the command line, in the form of a numerical day, ');
    fastwriteln(' month and year.');
    fastwriteln(' ');
    fastwriteln(' Arguments: ');
    fastwriteln(' /h or /help      - Show this help and exits.');
    fastwriteln(' /v or /version   - Show info about version and exits.');
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
    clrscr;
    
    FillChar(CommandEntry, StringSize, byte( ' ' ));
    
(*  Testa se é DOS 2. Se não for, mensagem de erro e fim. *)
    
    GetMSXDOSVersion (version);

    if (version.nKernelMajor < 2) then
    begin
        fastwriteln('MSX-DOS 1.x not supported. Sorry pal.');
        halt;
    end;
    
(* Se tiver três parametros, aí temos jogo. Pega as Dates e vamos trabalhar. *)
    if paramcount = 3 then
        begin
            Val (paramstr(1), Day, Returned);
            Val (paramstr(2), Month, Returned);
            Val (paramstr(3), Year, Returned);
            
            if (Day < 1) or (Day > 31) or
                (Month < 1) or (Month > 12) or
                (Year < 0) or (Year > maxint) or
                ((Year mod 4 <> 0) and (Day = 29)) then
                begin
                    fastwriteln(' Invalid date -- out of range');
                    halt;
                end
            else
                begin
                    Date.nDay := Day;
                    Date.nMonth := Month;
                    Date.nYear := Year;
                    Discordian (Date);
                    writeln(Date.nDay,'/',Date.nMonth,'/',Date.nYear);
                    halt;
                end;
        end;

(* Se tiver dois parametros, está errado. Joga o help na tela e cai fora. *)
    if paramcount = 2 then
        CommandHelp;

(* Se tiver apenas um parametro, pode ser que seja /h ou /v. Primeiro leia
* os parametros e os joga num vetor. Depois, passe os parametros para 
* maiusculas. Se for, apresenta os resultados e cai fora. *)
        
    if paramcount = 1 then
    begin
        temporary := paramstr(1);
        for j := 1 to StringSize do
            CommandEntry[j] := UpCase(temporary[j]);
            
        if (CommandEntry[1] = '/') then
            case CommandEntry[2] of
                'H': CommandHelp;
                'h': CommandHelp;
                'V': CommandVersion;
                'v': CommandVersion;
            end;
    end;

(* Se não tiver parametro algum, pega a Date do sistema e faz sua mágica. *)
    
    if paramcount = 0 then
    begin
        fastwriteln(' Let the magic begins...');
        DosGetDate (Date);
        writeln(Date.nDay,'/',Date.nMonth,'/',Date.nYear);
        Discordian (Date);
        halt;
    end;
END.

