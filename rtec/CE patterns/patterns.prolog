:-dynamic maxDurationUE/3.
%--------------- gap ---------------%
initiatedAt(gap(Vessel,Lon,Lat) = Status, T):-
    happensAt(gap_start(Vessel), T),
    happensAt(coord(Vessel,Lon,Lat),T),
    portDistance(Lon,Lat,Status).

terminatedAt(gap(Vessel) = _Status, T):-
    happensAt(gap_end(Vessel), T).

happensAt(gap_init(Vessel),T):-
    happensAt(start(gap(Vessel,_,_) = nearPort), T).
happensAt(gap_init(Vessel),T):-
    happensAt(start(gap(Vessel,_,_) = farFromPorts), T).


%-------------- stopped ------------%
initiatedAt(stopped(Vessel) = Status, T) :-
    happensAt(stop_start(Vessel),T),
    happensAt(coord(Vessel,Lon,Lat),T),
    portDistance(Lon,Lat,Status).

terminatedAt(stopped(Vessel) = Status, T) :-
    happensAt(stop_end(Vessel), T).

terminatedAt(stopped(Vessel) = _Status, T) :-
    happensAt(gap_init(Vessel), T).


%-------------- lowspeed -----------%
initiatedAt(lowSpeed(Vessel) = true, T) :-
    happensAt(slow_motion_start(Vessel), T).

terminatedAt(lowSpeed(Vessel) = true, T) :-
    happensAt(slow_motion_end(Vessel), T).

terminatedAt(lowSpeed(Vessel) = true, T) :-
    happensAt(gap_init(Vessel), T).


%----------- changingSpeed ---------%
initiatedAt(changingSpeed(Vessel) = true, T) :-
    happensAt(change_in_speed_start(Vessel), T).

terminatedAt(changingSpeed(Vessel) = true, T) :-
    happensAt(change_in_speed_end(Vessel), T).

terminatedAt(changingSpeed(Vessel) = true, T) :-
    happensAt(gap_init(Vessel), T).


%----------- withinArea ------------%
initiatedAt(withinArea(Vessel, Area) = true, T) :-
    happensAt(entersArea(Vessel, Area), T).

terminatedAt(withinArea(Vessel, Area) = true, T) :-
    happensAt(leavesArea(Vessel, Area), T).

terminatedAt(withinArea(Vessel, _Area) = true, T) :-
    happensAt(gap_start(Vessel), T).


%---------- underWay ---------------%
initiatedAt(underWay(Vessel) = true , T):-
    happensAt(velocity(Vessel, Speed, Heading,_),T),
    \+happensAt(gap_start(Vessel),T),
    thresholds(underWayMin,UnderWayMin),
    thresholds(underWayMax,UnderWayMax),
    Speed > UnderWayMin,
    Speed < UnderWayMax.

terminatedAt(underWay(Vessel) = true, T):-
    happensAt(velocity(Vessel, Speed, Heading,_),T),
    thresholds(underWayMax,UnderWayMax),
    Speed >= UnderWayMax.

terminatedAt(underWay(Vessel) = true, T):-
    happensAt(velocity(Vessel, Speed, Heading,_),T),
    thresholds(underWayMin,UnderWayMin),
    Speed =< UnderWayMin.

terminatedAt(underWay(Vessel) = true, T):-
    happensAt(gap_init(Vessel),T).


%---------- highSpeedNearCoast -------------%
initiatedAt(highSpeed(Vessel)=true,T):-
    happensAt(velocity(Vessel, Speed, Heading,_),T),
    holdsAt(withinArea(Vessel,Area)=true,T),
    areaType(Area,nearCoast),
    thresholds(hcNearCoastMax,HcNearCoastMax),
    Speed > HcNearCoastMax.

terminatedAt(highSpeed(Vessel)=true,T):-
    happensAt(velocity(Vessel, Speed, Heading,_),T),
    holdsAt(withinArea(Vessel,Area)=true,T),
    areaType(Area,nearCoast),
    thresholds(hcNearCoastMax,HcNearCoastMax),
    Speed =< HcNearCoastMax.

terminatedAt(highSpeed(Vessel)=true,T):-
    happensAt(end(withinArea(Vessel,Area)=true),T),
    areaType(Area,nearCoast).

terminatedAt(highSpeed(Vessel)=true,T):-
    happensAt(gap_init(Vessel), T).


%------- anchored or moored --------%
holdsFor(atAnchorOrMoored(Vessel)=true,I):-
    holdsFor(stopped(Vessel) = farFromPorts, Istfp),
    holdsFor(withinArea(Vessel,Area) = true, Ia),
    areaType(Area,anchorage),
    intersect_all([Istfp,Ia],Ista),
    holdsFor(stopped(Vessel)=nearPort,Istnp),
    union_all([Ista,Istnp],Ii),
    thresholds(aOrMTime,AOrMTime),
    intDurGreater(Ii,AOrMTime,I).


%--------- speedLTMin --------%
initiatedAt(speedLTMin(Vessel) = true, T):-
    happensAt(velocity(Vessel, Speed, Heading,_), T),
    vesselType(Vessel,Type),
    typeSpeed(Type,Min,_Max,_Avg),
    Speed < Min.

terminatedAt(speedLTMin(Vessel) = true, T):-
    happensAt(velocity(Vessel, Speed, Heading,_), T),
    vesselType(Vessel,Type),
    typeSpeed(Type,Min,_Max,_Avg),
    Speed >= Min.

terminatedAt(speedLTMin(Vessel) = true, T):-
    happensAt(gap_init(Vessel),T).


%---- Movement ability affected ----%
holdsFor(maa(Vessel) = true, I ):-
    holdsFor(speedLTMin(Vessel) = true, Islm),
    holdsFor(atAnchorOrMoored(Vessel) = true, Iam),
    holdsFor(withinArea(Vessel,Area)=true,Inc),
    areaType(Area,nearCoast),
    relative_complement_all(Islm,[Iam,Inc],Ii),
    thresholds(maaTime,MaaTime),
    intDurGreater(Ii,MaaTime,I).

%---------- adrift   ---------------%
initiatedAt(adrift(Vessel) = true, T):-
    happensAt(velocity(Vessel,_Speed,CourseOverGround,TrueHeading),T),
    TrueHeading =\= 511.0,
    holdsAt(underWay(Vessel)=true,T),
    absoluteAngleDiff(CourseOverGround,TrueHeading,AngleDiff),
    thresholds(adriftAngThr,AdriftAngThr),
    AngleDiff > AdriftAngThr.

terminatedAt(adrift(Vessel) = true, T):-
    happensAt(velocity(Vessel,_Speed,CourseOverGround,TrueHeading),T),
    TrueHeading =\= 511.0,
    holdsAt(underWay(Vessel)=true,T),
    absoluteAngleDiff(CourseOverGround,TrueHeading,AngleDiff),
    thresholds(adriftAngThr,AdriftAngThr),
    AngleDiff < AdriftAngThr.

terminatedAt(adrift(Vessel) = true, T):-
    happensAt(velocity(Vessel,_Speed,_CourseOverGround,TrueHeading),T),
    TrueHeading = 511.0.

terminatedAt(adrift(Vessel) = true, T):-
    happensAt(gap_init(Vessel), T).

terminatedAt(adrift(Vessel) = true, T):-
    happensAt(end(underWay(Vessel)=true),T).


%---------- rendezVous -------------%
holdsFor(rendezVous(Vessel1, Vessel2) = true, I) :-
    holdsFor(proximity(Vessel1, Vessel2) = true, Ip),
    \+vesselType(Vessel1,tug),
    \+vesselType(Vessel2,tug),
    \+vesselType(Vessel1,pilotvessel),
    \+vesselType(Vessel2,pilotvessel),
    holdsFor(lowSpeed(Vessel1) = true, Il1),
    holdsFor(lowSpeed(Vessel2) = true, Il2),
    holdsFor(stopped(Vessel1) = farFromPorts, Is1),
    holdsFor(stopped(Vessel2) = farFromPorts, Is2),
    holdsFor(withinArea(Vessel1,Area1)=true,Iw1),
    holdsFor(withinArea(Vessel2,Area2)=true,Iw2),
    areaType(Area1,nearCoast),
    areaType(Area2,nearCoast),
    union_all([Il1, Is1], I1b),
    union_all([Il2, Is2], I2b),
    relative_complement_all(I1b,[Iw1],I1),
    relative_complement_all(I2b,[Iw2],I2),
    intersect_all([I1, I2, Ip], If),
    thresholds(rendezvousTime,RendezvousTime),
    intDurGreater(If,RendezvousTime,I).
