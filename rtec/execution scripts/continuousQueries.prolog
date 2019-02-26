:- ['../utils/data\ loader/stream_loader.prolog'].
:- ['../../../src/RTEC.prolog'].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes: 
% DatasetFile is the input dataset file,
% OutputFile records recognised CEs
% TimesFile records the event recognition times,
% InputFile records the number of input events per window,
% InitPoint is where recognition starts,
% WM is the window size,
% Step is the recognition step,
% LastTime is where recognition ends.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

continuousER(DatasetFile, OutputFile, TimesFile, InputFile, InitPoint, LastTime, WM, Step) :-
  open(DatasetFile, read, DatasetStream),
  open(OutputFile, write, OutputStream),
  stream_property(Stream,position(Position)),
  Positions = [Position],
  open(TimesFile, write, TimesStream),
  open(InputFile, write, InputStream),
  initialiseRecognition(ordered, nopreprocessing, 1),
  InitWin is InitPoint + WM,
  InitWinPlus1 is InitWin +1 ,
  WMPlus1 is WM+1, 
  % the first event recognition time should not be counted
  % because there are no old input facts being retracted
  CurrentTime is InitWin,
  ERStartTime is InitWin - InitWinPlus1,
  write('ER: '),write('('),write(ERStartTime),write(', '), write(InitWin), write(']'), nl,
  loadManySDE([DatasetStream],InitPoint,InitWin,Positions,NewPositions),
  statistics(cputime, [S1,T1]),
  dynamicGrounding, 
  eventRecognition(InitWin, InitWinPlus1),
  findall((F=V,L), (outputEntity(F=V),holdsFor(F=V,L),L\=[]), CC),  
  statistics(cputime, [S2,T2]), T is T2-T1, S is S2-S1, %S=T2,
  writeCEs(CC,OutputStream,ERStartTime,InitWin),
  write(TimesStream, S),
  NewCurrentTime is CurrentTime+Step,
  findall((A,B), happensAtIE(A,B), SDEList),
  length(SDEList, SDEL),
  findall((A,B), holdsAtIE(A,B), InputList), 
  length(InputList, InputL),
  Input is SDEL+InputL,
  write(InputStream, Input),
  querying(DatasetStream,OutputStream,TimesStream, InputStream, WM, Step, NewCurrentTime, LastTime, [S], WorstCase, [Input], InputSum, NewPositions),
  % calculate average query time
  sum_list(WorstCase, Sum),
  length(WorstCase, L),
  AvgTime is Sum/L,
  nl(TimesStream), write(TimesStream, AvgTime),
  % calculate max query time
  max_list(WorstCase, Max),
  nl(TimesStream), write(TimesStream, Max),
  % calculate avg input facts
  sum_list(InputSum, ISum),
  AvgInput is ISum/L,
  nl(InputStream), write(InputStream, AvgInput),
  close(DatasetFile),
  close(OutputFile),
  close(TimesStream),
  close(InputStream), !.

querying(_DatasetStream,_OutputStream,_TimesStream, _InputStream, _WM, _Step, CurrentTime, LastTime, WorstCase, WorstCase, InputSum, InputSum, Positions) :-
   streamsFinished(Positions),nl,
   !.

querying(_DatasetStream,_OutputStream,_TimesStream, _InputStream, _WM, _Step, CurrentTime, LastTime, WorstCase, WorstCase, InputSum, InputSum, _Positions) :-
  CurrentTime >= LastTime, !.

querying(DatasetStream,OutputStream, TimesStream, InputStream, WM, Step, CurrentTime, LastTime, InitWorstCase, WorstCase, InitInput, InputSum, Positions) :-
  OldCurrentTime is CurrentTime-Step,
  loadManySDE([DatasetStream],OldCurrentTime,CurrentTime,Positions,NewPositions),
  Diff is CurrentTime-WM,
  write('ER: '),write('('),write(Diff),write(', '), write(CurrentTime), write(']'), nl,
  statistics(cputime,[S1,T1]),
  dynamicGrounding, 
  eventRecognition(CurrentTime, WM),
  findall((F=V,L), (outputEntity(F=V),holdsFor(F=V,L)), CC),
  statistics(cputime,[S2,T2]),
  writeCEs(CC,OutputStream,Diff,CurrentTime),
  T is T2-T1, S is S2-S1, %S=T2,
  writeResult(S, TimesStream),
  NewCurrentTime is CurrentTime+Step,
  findall((A,B), happensAtIE(A,B), SDEList),
  length(SDEList, SDEL),
  findall((A,B), holdsAtIE(A,B),InputList),
  length(InputList, InputL),
  Input is SDEL+InputL,
  writeResult(Input, InputStream),
  querying(DatasetStream,OutputStream,TimesStream, InputStream, WM, Step, NewCurrentTime, LastTime, [S|InitWorstCase], WorstCase, [Input|InitInput], InputSum, NewPositions).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I/O Utils
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writeResult(Time, Stream):-
  write(Stream,'+'), write(Stream,Time).


writeCEs(CC,OutputStream, Start, End):-
    write(OutputStream,'ER: ('),
    write(OutputStream,Start),
    write(OutputStream,', '),
    write(OutputStream,End),
    write(OutputStream,']'),
    nl(OutputStream),
    writeCEsInner(CC,OutputStream,Start,End),
    nl(OutputStream).

writeCEsInner([],OutputStream,_Start,_End):-
    nl(OutputStream).

writeCEsInner([(F=V,L)|R],OutputStream,Start,End):-
    L=[],
    writeCEsInner(R,OutputStream,Start,End).

writeCEsInner([(F=V,L)|R],OutputStream,Start,End):-
    L\=[],F =.. Att,
    intersect_all([L,[(Start,End)]],Li),
    append(Att,[V],CE_info),
    writeCEinLines(OutputStream,CE_info,Li),
    writeCEsInner(R,OutputStream,Start,End).

writeCEinLines(_OutputStream,_CE,[]).
writeCEinLines(OutputStream,CE,[(A,B)|L]):-
    append(CE,[A,B],CEpInt),
    writeElementsSeparated(OutputStream,CEpInt),
    writeCEinLines(OutputStream,CE,L).

writeElementsSeparated(OutputStream,[]).
writeElementsSeparated(OutputStream,[E]):-
    write(OutputStream,E),nl(OutputStream).
writeElementsSeparated(OutputStream,[E|L]):-
    write(OutputStream,E),
    write(OutputStream,'|'),
    writeElementsSeparated(OutputStream,L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update SDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%updateSDE(Start, End) :-
	%findall(Start, updateSDE(movement, Start, End), _),
	%findall(Start, updateSDE(appearance, Start, End), _).


%updateManySDE(Start, End) :-
	%Diff is End-Start,
	%Diff =< 1000,
	%!,
	%updateSDE(Start, End).	

%updateManySDE(Start, End) :-
	%Diff is End-Start,
	%Diff > 1000,
	%NewStart is Start + 1000,
	%updateSDE(Start, NewStart),
	%updateManySDE(NewStart, End).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Streams finished
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
streamsFinished([end_of_file|[]]).

streamsFinished([end_of_file|OtherPositions]) :-
    streamsFinished(OtherPositions).
