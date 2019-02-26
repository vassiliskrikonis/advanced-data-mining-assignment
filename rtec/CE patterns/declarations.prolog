:- dynamic grounding/1.

/********************************************************************** DECLARATIONS *******************************************************************************
 -Declare the entities of the event description: events, simple and statically determined fluents.
 -For each entity state if it is input or output (simple fluents are by definition output entities).
 -For each input/output entity state its index.
 -For input entities/statically determined fluents state whether the intervals will be collected into a list or built from time-points.
 -Declare the groundings of the fluents and output entities/events.
 -Declare the order of caching of output entities.
 *******************************************************************************************************************************************************************/

/**************************************************************** NOTICE FOR RELATIONAL FLUENTS ********************************************************************
 In order to correctly detect relational fluents with dynamic grounding, provided that those are grounded on the proximity vessel pairs you have
 to use vp(Vessel1,Vessel2) as index (e.g., see the index of proximity/rendezVous).
********************************************************************************************************************************************************************/

%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%
event(change_in_speed_start(_)).	inputEntity(change_in_speed_start(_)).		index(change_in_speed_start(Vessel), Vessel).
event(change_in_speed_end(_)).		inputEntity(change_in_speed_end(_)).		index(change_in_speed_end(Vessel), Vessel).
event(change_in_heading(_)).		inputEntity(change_in_heading(_)).		index(change_in_heading(Vessel), Vessel).
event(stop_start(_)).			inputEntity(stop_start(_)).			index(stop_start(Vessel), Vessel).
event(stop_end(_)).			inputEntity(stop_end(_)).			index(stop_end(Vessel), Vessel).
event(slow_motion_start(_)).		inputEntity(slow_motion_start(_)).		index(slow_motion_start(Vessel), Vessel).
event(slow_motion_end(_)).		inputEntity(slow_motion_end(_)).		index(slow_motion_end(Vessel), Vessel).
event(gap_start(_)).			inputEntity(gap_start(_)).			index(gap_start(Vessel), Vessel).
event(gap_end(_)).			inputEntity(gap_end(_)).			index(gap_end(Vessel), Vessel).
event(entersArea(_,_)).			inputEntity(entersArea(_,_)).			index(entersArea(Vessel,_), Vessel).
event(leavesArea(_,_)).			inputEntity(leavesArea(_,_)).			index(leavesArea(Vessel,_), Vessel).
event(coord(_,_,_)).			inputEntity(coord(_,_,_)).			index(coord(Vessel,_,_), Vessel).
event(velocity(_,_,_,_)).		inputEntity(velocity(_,_,_,_)).			index(velocity(Vessel,_,_,_), Vessel).
sDFluent(proximity(_,_)=true).		inputEntity(proximity(_,_)=true).		index(proximity(Vessel1,Vessel2)=true,vp(Vessel1,Vessel2)).


%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%
simpleFluent(gap(_,_,_)=nearPort).			outputEntity(gap(_,_,_)=nearPort).			index(gap(Vessel,_,_)=nearPort, Vessel).
simpleFluent(gap(_,_,_)=farFromPorts).		outputEntity(gap(_,_,_)=farFromPorts).		index(gap(Vessel,_,_)=farFromPorts, Vessel).
event(gap_init(_)).				outputEntity(gap_init(_)).			index(gap_init(Vessel), Vessel).

simpleFluent(stopped(_) = nearPort).		outputEntity(stopped(_) = nearPort).		index(stopped(Vessel) = nearPort, Vessel).
simpleFluent(stopped(_) = farFromPorts).	outputEntity(stopped(_) = farFromPorts).	index(stopped(Vessel) = farFromPorts, Vessel).

simpleFluent(lowSpeed(_) = true).		outputEntity(lowSpeed(_) = true).		index(lowSpeed(Vessel) = true, Vessel).

simpleFluent(changingSpeed(_) = true).		outputEntity(changingSpeed(_) = true).		index(changingSpeed(Vessel) = true, Vessel).

simpleFluent(withinArea(_,_)=true).		outputEntity(withinArea(_,_)=true).		index(withinArea(Vessel,_)=true, Vessel).

simpleFluent(underWay(_)=true).			outputEntity(underWay(_)=true).			index(underWay(Vessel)=true, Vessel).

simpleFluent(highSpeed(_)=true).	outputEntity(highSpeed(_)=true).	index(highSpeed(Vessel)=true, Vessel).

simpleFluent(adrift(_)=true).			outputEntity(adrift(_)=true).			index(adrift(Vessel)=true, Vessel).

sDFluent(atAnchorOrMoored(_) = true).		outputEntity(atAnchorOrMoored(_) = true).	index(atAnchorOrMoored(Vessel) = true, Vessel).

simpleFluent(speedLTMin(_)=true).		outputEntity(speedLTMin(_)=true).		index(speedLTMin(Vessel)=true, Vessel).

sDFluent(maa(_)=true).				outputEntity(maa(_)=true).			index(maa(Vessel)=true, Vessel).

sDFluent(rendezVous(_,_)=true).			outputEntity(rendezVous(_,_)=true).		index(rendezVous(Vessel1,Vessel2)=true, vp(Vessel1,Vessel2)).

sDFluent(maa(_)=true).				outputEntity(maa(_)=true).			index(maa(Vessel)=true, Vessel).



% for input entities/statically determined fluents state whether
% the intervals will be collected into a list or built from given time-points

collectIntervals(proximity(_,_)=true).

% define the groundings of the fluents and output entities/events

grounding(proximity(Vessel1,Vessel2) = true)                :- vpair(Vessel1,Vessel2).
grounding(gap(Vessel,Lon,Lat) = PortStatus)                 :- vessel(Vessel),portStatus(PortStatus).
grounding(gap_init(Vessel))                                 :- vessel(Vessel).
grounding(stopped(Vessel) = PortStatus)                     :- vessel(Vessel),portStatus(PortStatus).
grounding(lowSpeed(Vessel) = true)                          :- vessel(Vessel).
grounding(changingSpeed(Vessel) = true)                     :- vessel(Vessel).
grounding(withinArea(Vessel,AreaType) = true)               :- vessel(Vessel).
grounding(underWay(Vessel) = true)                          :- vessel(Vessel).
grounding(highSpeed(Vessel) = true)                         :- vessel(Vessel).
grounding(adrift(Vessel) = true)                            :- vessel(Vessel).
grounding(atAnchorOrMoored(Vessel) = true)                  :- vessel(Vessel).
grounding(speedLTMin(Vessel) = true)                        :- vessel(Vessel).
grounding(rendezVous(Vessel1,Vessel2) = true)               :- vpair(Vessel1,Vessel2).
grounding(maa(Vessel) = true)                               :- vessel(Vessel).

% cachingOrder should be defined for all output entities

cachingOrder(gap(_,_,_) = nearPort).
cachingOrder(gap(_,_,_) = farFromPorts).
cachingOrder(gap_init(_)).
cachingOrder(stopped(_) = nearPort).
cachingOrder(stopped(_) = farFromPorts).
cachingOrder(lowSpeed(_) = true).
cachingOrder(changingSpeed(_) = true).
cachingOrder(withinArea(_,_) = true).
cachingOrder(underWay(_) = true).
cachingOrder(highSpeed(_) = true).
cachingOrder(atAnchorOrMoored(_) = true).
cachingOrder(adrift(_) = true).
cachingOrder(speedLTMin(_) = true).
cachingOrder(maa(_) = true).
cachingOrder(rendezVous(_,_) = true).

needsGrounding(_, _, _) :- fail.
buildFromPoints(_) :- fail.
