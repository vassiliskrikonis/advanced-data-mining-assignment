/****************************************************************
 *                                                              *
 * Event Recognition for Maritime Surveillance           	*
 *                                                              *
 *                                                              *
 * Implemented in YAP						*
 * Manolis Pitsikalis						*
 *								*
 ****************************************************************/


/********************************************************************** DECLARATIONS *******************************************************************************
 -Declare the entities of the event description: events, simple and statically determined fluents.
 -For each entity state if it is input or output (simple fluents are by definition output entities).
 -For each input/output entity state its index.
 -For input entities/statically determined fluents state whether the intervals will be collected into a list or built from time-points.
 -Declare the groundings of the fluents and output entities/events.
 -Declare the order of caching of output entities.
 *******************************************************************************************************************************************************************/

:- dynamic grounding/1.

%Input Entities
% coord(MMSI,Lon,Lat)
event(coord(_,_,_)).			        inputEntity(coord(_,_,_)).			index(coord(Vessel,_,_), Vessel).
% proximity(Vessel1,Vessel2)=true
sDFluent(proximity(_,_)=true).			inputEntity(proximity(_,_)=true).		index(proximity(Vessel,_)=true,Vessel).

% velocity(MMSI,Speed,CoG,TrHeading)
event(velocity(_,_,_,_)).	         	inputEntity(velocity(_,_,_,_)).			index(velocity(Vessel,_,_,_), Vessel).

%Output Entities
simpleFluent(stopped(_) = true).		outputEntity(stopped(_) = true).		index(stopped(Vessel) = true, Vessel).
simpleFluent(lowSpeed(_) = true).		outputEntity(lowSpeed(_) = true).		index(lowSpeed(Vessel) = true, Vessel).
simpleFluent(underWay(_) = true).               outputEntity(underWay(_) = true).               index(underWay(Vessel) = true,Vessel).
sDFluent(travelSpeed(_)=true).		        outputEntity(travelSpeed(_)=true).		index(travelSpeed(Vessel)=true, Vessel).

% for input entities/statically determined fluents state whether
% the intervals will be collected into a list or built from given time-points

collectIntervals(proximity(_,_)=true).

% define the groundings of the fluents and output entities/events

grounding(proximity(Vessel1,Vessel2) = true)          :- vessel(Vessel1),vessel(Vessel2), Vessel1\=Vessel2.
grounding(stopped(Vessel) = true)                     :- vessel(Vessel).
grounding(lowSpeed(Vessel) = true)                    :- vessel(Vessel).
grounding(underWay(Vessel) = true)                    :- vessel(Vessel).
grounding(travelSpeed(Vessel) = true)                 :- vessel(Vessel).

% cachingOrder should be defined for all output entities

cachingOrder(stopped(_) = true).
cachingOrder(lowSpeed(_) = true).
cachingOrder(underWay(_) = true).
cachingOrder(travelSpeed(_) = true).
