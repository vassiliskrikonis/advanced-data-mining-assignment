initiatedAt(stopped(_131135)=true, _131153, _131120, _131155) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131153=<_131120,_131120<_131155,
     _131144<0.5.

initiatedAt(lowSpeed(_131135)=true, _131162, _131120, _131164) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131162=<_131120,_131120<_131164,
     _131144>=0.5,
     _131144<5.0.

initiatedAt(underWay(_131135)=true, _131159, _131120, _131161) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131159=<_131120,_131120<_131161,
     _131144>=2.7,
     _131144<50.

terminatedAt(stopped(_131135)=true, _131153, _131120, _131155) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131153=<_131120,_131120<_131155,
     _131144>=0.5.

terminatedAt(lowSpeed(_131135)=true, _131153, _131120, _131155) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131153=<_131120,_131120<_131155,
     _131144<0.5.

terminatedAt(lowSpeed(_131135)=true, _131153, _131120, _131155) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131153=<_131120,_131120<_131155,
     _131144>=5.0.

terminatedAt(underWay(_131135)=true, _131153, _131120, _131155) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131153=<_131120,_131120<_131155,
     _131144<2.7.

terminatedAt(underWay(_131135)=true, _131150, _131120, _131152) :-
     happensAtIE(velocity(_131135,_131144,_131145,_131146),_131120),_131150=<_131120,_131120<_131152,
     _131144>=50.

holdsForSDFluent(travelSpeed(_131135)=true,_131120) :-
     holdsForProcessedSimpleFluent(_131168,underWay(_131135)=true,_131141),
     holdsForProcessedSimpleFluent(_131180,lowSpeed(_131135)=true,_131152),
     relative_complement_all(_131141,[_131152],_131120).

cachingOrder2(_131119, stopped(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, lowSpeed(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, underWay(_131119)=true) :-
     vessel(_131119).

cachingOrder2(_131119, travelSpeed(_131119)=true) :-
     vessel(_131119).

collectIntervals2(_131119, proximity(_131119,_131120)=true) :-
     vessel(_131119),vessel(_131120),_131119\=_131120.

