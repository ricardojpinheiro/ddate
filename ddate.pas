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

procedure Discordian (Date: TDate; State: Boolean);

(* O início de tudo, no calendário discordiano. *)

const
    CurseOfGreyFace = -1166;
    
var
    BissextYear: boolean;
    Factor, DayOfTheYear: integer;
    DiscordianYear, DiscordianSeason, DiscordianDay: integer;
    DiscordianDayOfTheWeek: integer;
    i, j: byte;
    temporary, DayText, SeasonText: string[15];
    Holiday: string[30];
    Suffix: string[2];
    Phrase: string[60];

begin
    DayOfTheYear := 0;
    SeasonText := ' ';
    Holiday := ' ';
    Suffix := 'th';
    BissextYear := false;
    Factor := 0;
    
(* Ano no calendário discordiano *)    
    
    DiscordianYear := Date.nYear - CurseOfGreyFace;

(* Se é bissexto, liga a flag. *)

    if (Year mod 4 = 0) then
        BissextYear := true;

(* Aqui contamos quantos dias do ano se passaram. *)

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

(* Estação (mês) do ano no calendário discordiano. *)
    
    DiscordianSeason := (DayOfTheYear div 73);
    case DiscordianSeason of
        0: SeasonText := 'Chaos';
        1: SeasonText := 'Discord';
        2: SeasonText := 'Confusion';
        3: SeasonText := 'Bureaucracy';
        4: SeasonText := 'The Aftermath';
    end;

(* Dia do ano no calendário discordiano. *)
    
    DiscordianDay := (DayOfTheYear - DiscordianSeason * 73);

(* Não há dia zero. *)
    
    if DiscordianDay = 0 then
        DiscordianDay := 1;

(* Dia da semana, no calendário discordiano. *)

    DiscordianDayOfTheWeek := (DayOfTheYear mod 5);

(* Se for bissexto, tem que pular o dia extra - 29/2,
*  no nosso calendário. *)

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

(* Se for dia 29/2, é St. Tibs Day, que não conta pro calendário. *)

    if (BissextYear = true) and (Month = 2) and (Day = 29) then
            DayText := 'St. Tibs Day'; 

(* Aqui é um ajuste para o sufixo do ano, em inglês: 1st, 2nd, 3rd, 4th 
*  e segue adiante. *)
    
    i := (DiscordianDay div 10);
    j := (DiscordianDay - (i * 10));
    
    case j of
        1: Suffix := 'st';
        2: Suffix := 'nd';
        3: Suffix := 'rd';
    end;

(* Aqui, os feriados oficiais - que eu acrescentei por conta própria. 
*  Aninhei alguns cases. *)

    case DiscordianSeason of
        0:  case DiscordianDay of
                5: Holiday := '(Mungday)';
                50: Holiday := '(Chaoflux)';
            end;
        1:  case DiscordianDay of
                5: Holiday := '(Mojoday)';
                50: Holiday := '(Discoflux)';
            end;
        2: case DiscordianDay of
                5: Holiday := '(Syaday)';
                50: Holiday := '(Contuflux)';
            end;
        3: case DiscordianDay of
                5: Holiday := '(Zaraday)';
                50: Holiday := '(Bureflux)';
            end;
        4: case DiscordianDay of
                5: Holiday := '(Maladay)';
                50: Holiday := '(Afflux)';
            end;
    end;
    case DiscordianDay of
        27: Holiday := '(Sloth Day)';
        50: Holiday := '(Flux Day)';
        73: Holiday := '(Eye Day)';
    end;

(* Agora temos os feriados não-oficiais. Aí virou bagunça *)
    case DiscordianSeason of
        0:  case DiscordianDay of
                11: Holiday := '(Love Your Neighbor Day)';
                23: Holiday := '(Jake Day)';
            end;
        1:  case DiscordianDay of
                11: Holiday := '(Love Your Neighbor Day)';
                23: Holiday := '(Jake Day)';
                60: Holiday := '(Saint Camping''s Day)';
                70: Holiday := '(Eris Day)';
                72: Holiday := '(Towel Day)';
            end;
        2: case DiscordianDay of
                5: Holiday := '(Mid Year''s Day)';
                40: Holiday := '(X-Day)';
            end;
        3: case DiscordianDay of
                3: Holiday := '(Multiversal Underwear Day)';
                50: Holiday := '(Bureflux)';
            end;
        4: case DiscordianDay of
                5: Holiday := '(Maladay)';
                50: Holiday := '(Afflux)';
            end;
    end;


(* Aqui monta a sentença. Se a data foi informada, é false. Se não foi 
*  informada (usa-se a data do RTC do MSX), é true. *)

    if State = True then
    begin
        Str(DiscordianDay, temporary);
        Phrase := concat(DayText,', ',SeasonText,' ',temporary,', ');
        temporary := ' ';
        Str(DiscordianYear, temporary);
        Phrase := Phrase + concat(temporary, ' YOLD', ' ',Holiday);
    end
    else
    begin
        Str(DiscordianDay, temporary);
        Phrase := concat('Today is ', DayText, ', the ', temporary, Suffix, 
                    ' day of ', SeasonText, ' in the YOLD ');
        temporary := ' ';
        Str(DiscordianYear, temporary);
        Phrase := Phrase + concat(temporary, ' ', Holiday);
    end;

(* Imprime a data na tela. *)        

    writeln(Phrase);
end;

procedure CommandHelp;
begin

(* Help do comando. *)

    clrscr;
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

(* Versão do comando. *)

    clrscr;
    fastwriteln('ddate version 0.9'); 
    fastwriteln('Copyright (c) 2020 Brazilian MSX Crew.');
    fastwriteln('Some rights reserved.');
    fastwriteln('This software claims to be distributed due to the GPL v3 license.');
    fastwriteln(' ');
    fastwriteln('Version notes: ');
    fastwriteln('In this moment, this utility does this date conversion.'); 
    fastwriteln('Nothing else. I have done it in a Saturday sleepless night.');
    fastwriteln('So... Take it easy.');
    fastwriteln(' ');
    halt;
end;

BEGIN
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
                    writeln(' Invalid date -- out of range');
                    halt;
                end
            else
                begin
                    Date.nDay := Day;
                    Date.nMonth := Month;
                    Date.nYear := Year;
                    Discordian (Date, True);
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

(* Se não tiver parametro algum, pega a data do sistema e faz sua mágica. *)
    
    if paramcount = 0 then
    begin
        DosGetDate (Date);
        Discordian (Date, False);
        halt;
    end;
END.

