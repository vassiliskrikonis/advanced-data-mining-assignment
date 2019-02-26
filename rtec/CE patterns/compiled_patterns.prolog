initiatedAt(gap(_131135,_131136,_131137)=_131123, _131160, _131120, _131162) :-
     happensAtIE(gap_start(_131135),_131120),_131160=<_131120,_131120<_131162,
     happensAtIE(coord(_131135,_131136,_131137),_131120),_131160=<_131120,_131120<_131162,
     portDistance(_131136,_131137,_131123).

initiatedAt(stopped(_131135)=_131123, _131158, _131120, _131160) :-
     happensAtIE(stop_start(_131135),_131120),_131158=<_131120,_131120<_131160,
     happensAtIE(coord(_131135,_131152,_131153),_131120),_131158=<_131120,_131120<_131160,
     portDistance(_131152,_131153,_131123).

initiatedAt(lowSpeed(_131135)=true, _131141, _131120, _131143) :-
     happensAtIE(slow_motion_start(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

initiatedAt(changingSpeed(_131135)=true, _131141, _131120, _131143) :-
     happensAtIE(change_in_speed_start(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

initiatedAt(withinArea(_131135,_131136)=true, _131143, _131120, _131145) :-
     happensAtIE(entersArea(_131135,_131136),_131120),
     _131143=<_131120,
     _131120<_131145.

initiatedAt(underWay(_131135)=true, _131178, _131120, _131180) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131178=<_131120,_131120<_131180,
     \+ (happensAtIE(gap_start(_131135),_131120),_131178=<_131120,_131120<_131180),
     thresholds(underWayMin,_131162),
     thresholds(underWayMax,_131168),
     _131144>_131162,
     _131144<_131168.

initiatedAt(highSpeed(_131135)=true, _131174, _131120, _131176) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131174=<_131120,_131120<_131176,
     holdsAtProcessedSimpleFluent(_131208,withinArea(_131135,_131158)=true,_131120),
     areaType(_131158,nearCoast),
     thresholds(hcNearCoastMax,_131170),
     _131144>_131170.

initiatedAt(speedLTMin(_131135)=true, _131164, _131120, _131166) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131164=<_131120,_131120<_131166,
     vesselType(_131135,_131152),
     typeSpeed(_131152,_131158,_131159,_131160),
     _131144<_131158.

initiatedAt(adrift(_131135)=true, _131183, _131120, _131185) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131183=<_131120,_131120<_131185,
     _131146=\=511.0,
     holdsAtProcessedSimpleFluent(_131220,underWay(_131135)=true,_131120),
     absoluteAngleDiff(_131145,_131146,_131173),
     thresholds(adriftAngThr,_131179),
     _131173>_131179.

terminatedAt(gap(_131135)=_131123, _131141, _131120, _131143) :-
     happensAtIE(gap_end(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(stopped(_131135)=_131123, _131141, _131120, _131143) :-
     happensAtIE(stop_end(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(stopped(_131135)=_131123, _131141, _131120, _131143) :-
     happensAtProcessed(_131146,gap_init(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(lowSpeed(_131135)=true, _131141, _131120, _131143) :-
     happensAtIE(slow_motion_end(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(lowSpeed(_131135)=true, _131141, _131120, _131143) :-
     happensAtProcessed(_131146,gap_init(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(changingSpeed(_131135)=true, _131141, _131120, _131143) :-
     happensAtIE(change_in_speed_end(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(changingSpeed(_131135)=true, _131141, _131120, _131143) :-
     happensAtProcessed(_131146,gap_init(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(withinArea(_131135,_131136)=true, _131143, _131120, _131145) :-
     happensAtIE(leavesArea(_131135,_131136),_131120),
     _131143=<_131120,
     _131120<_131145.

terminatedAt(withinArea(_131135,_131136)=true, _131142, _131120, _131144) :-
     happensAtIE(gap_start(_131135),_131120),
     _131142=<_131120,
     _131120<_131144.

terminatedAt(underWay(_131135)=true, _131156, _131120, _131158) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131156=<_131120,_131120<_131158,
     thresholds(underWayMax,_131152),
     _131144>=_131152.

terminatedAt(underWay(_131135)=true, _131156, _131120, _131158) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131156=<_131120,_131120<_131158,
     thresholds(underWayMin,_131152),
     _131144=<_131152.

terminatedAt(underWay(_131135)=true, _131141, _131120, _131143) :-
     happensAtProcessed(_131146,gap_init(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(highSpeed(_131135)=true, _131174, _131120, _131176) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131174=<_131120,_131120<_131176,
     holdsAtProcessedSimpleFluent(_131208,withinArea(_131135,_131158)=true,_131120),
     areaType(_131158,nearCoast),
     thresholds(hcNearCoastMax,_131170),
     _131144=<_131170.

terminatedAt(highSpeed(_131135)=true, _131153, _131120, _131155) :-
     happensAtProcessedSimpleFluent(_131164,end(withinArea(_131135,_131149)=true),_131120),_131153=<_131120,_131120<_131155,
     areaType(_131149,nearCoast).

terminatedAt(highSpeed(_131135)=true, _131141, _131120, _131143) :-
     happensAtProcessed(_131146,gap_init(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(speedLTMin(_131135)=true, _131164, _131120, _131166) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131164=<_131120,_131120<_131166,
     vesselType(_131135,_131152),
     typeSpeed(_131152,_131158,_131159,_131160),
     _131144>=_131158.

terminatedAt(speedLTMin(_131135)=true, _131141, _131120, _131143) :-
     happensAtProcessed(_131146,gap_init(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(adrift(_131135)=true, _131183, _131120, _131185) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131183=<_131120,_131120<_131185,
     _131146=\=511.0,
     holdsAtProcessedSimpleFluent(_131220,underWay(_131135)=true,_131120),
     absoluteAngleDiff(_131145,_131146,_131173),
     thresholds(adriftAngThr,_131179),
     _131173<_131179.

terminatedAt(adrift(_131135)=true, _131153, _131120, _131155) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131153=<_131120,_131120<_131155,
     _131146=511.0.

terminatedAt(adrift(_131135)=true, _131141, _131120, _131143) :-
     happensAtProcessed(_131146,gap_init(_131135),_131120),
     _131141=<_131120,
     _131120<_131143.

terminatedAt(adrift(_131135)=true, _131146, _131120, _131148) :-
     happensAtProcessedSimpleFluent(_131154,end(underWay(_131135)=true),_131120),
     _131146=<_131120,
     _131120<_131148.

holdsForSDFluent(atAnchorOrMoored(_131135)=true,_131120) :-
     holdsForProcessedSimpleFluent(_131210,stopped(_131135)=farFromPorts,_131141),
     holdsForProcessedSimpleFluent(_131222,withinArea(_131135,_131158)=true,_131152),
     areaType(_131158,anchorage),
     intersect_all([_131141,_131152],_131170),
     holdsForProcessedSimpleFluent(_131241,stopped(_131135)=nearPort,_131180),
     union_all([_131170,_131180],_131191),
     thresholds(aOrMTime,_131201),
     intDurGreater(_131191,_131201,_131120).

holdsForSDFluent(maa(_131135)=true,_131120) :-
     holdsForProcessedSimpleFluent(_131201,speedLTMin(_131135)=true,_131141),
     holdsForProcessedSDFluent(_131213,atAnchorOrMoored(_131135)=true,_131152),
     holdsForProcessedSimpleFluent(_131225,withinArea(_131135,_131169)=true,_131163),
     areaType(_131169,nearCoast),
     relative_complement_all(_131141,[_131152,_131163],_131182),
     thresholds(maaTime,_131192),
     intDurGreater(_131182,_131192,_131120).

holdsForSDFluent(rendezVous(_131135,_131136)=true,_131120) :-
     holdsForProcessedIE(vp(_131332,_131333),proximity(_131135,_131136)=true,_131142),
     \+vesselType(_131135,tug),
     \+vesselType(_131136,tug),
     \+vesselType(_131135,pilotvessel),
     \+vesselType(_131136,pilotvessel),
     holdsForProcessedSimpleFluent(_131361,lowSpeed(_131135)=true,_131186),
     holdsForProcessedSimpleFluent(_131373,lowSpeed(_131136)=true,_131197),
     holdsForProcessedSimpleFluent(_131385,stopped(_131135)=farFromPorts,_131208),
     holdsForProcessedSimpleFluent(_131397,stopped(_131136)=farFromPorts,_131219),
     holdsForProcessedSimpleFluent(_131409,withinArea(_131135,_131236)=true,_131230),
     holdsForProcessedSimpleFluent(_131422,withinArea(_131136,_131248)=true,_131242),
     areaType(_131236,nearCoast),
     areaType(_131248,nearCoast),
     union_all([_131186,_131208],_131266),
     union_all([_131197,_131219],_131276),
     relative_complement_all(_131266,[_131230],_131287),
     relative_complement_all(_131276,[_131242],_131296),
     intersect_all([_131287,_131296,_131142],_131304),
     thresholds(rendezvousTime,_131316),
     intDurGreater(_131304,_131316,_131120).

happensAtEv(gap_init(_131129),_131120) :-
     happensAtProcessedSimpleFluent(_131146,start(gap(_131129,_131140,_131141)=nearPort),_131120).

happensAtEv(gap_init(_131129),_131120) :-
     happensAtProcessedSimpleFluent(_131146,start(gap(_131129,_131140,_131141)=farFromPorts),_131120).

cachingOrder2(_131119, gap(_131119,_131120,_131121)=nearPort) :-
     vessel(_131119),portStatus(nearPort).

cachingOrder2(_131119, gap(_131119,_131120,_131121)=farFromPorts) :-
     vessel(_131119),portStatus(farFromPorts).

cachingOrder2(_131116, gap_init(_131116)) :-
     vessel(_131116).

cachingOrder2(_131119, stopped(_131119)=nearPort) :-
     vessel(_131119),portStatus(nearPort).

cachingOrder2(_131119, stopped(_131119)=farFromPorts) :-
     vessel(_131119),portStatus(farFromPorts).

cachingOrder2(_131119, lowSpeed(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, changingSpeed(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, withinArea(_131119,_131120)=true) :-
     vessel(_131119).

cachingOrder2(_131119, underWay(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, highSpeed(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, atAnchorOrMoored(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, adrift(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, speedLTMin(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, maa(_131119)=true) :-
     vessel(_131119).

cachingOrder2(vp(_131119,_131120), rendezVous(_131119,_131120)=true) :-
     vpair(_131119,_131120).

collectIntervals2(vp(_131119,_131120), proximity(_131119,_131120)=true) :-
     vpair(_131119,_131120).

