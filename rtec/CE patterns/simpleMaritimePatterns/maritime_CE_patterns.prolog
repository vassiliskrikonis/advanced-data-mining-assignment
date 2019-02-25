
/*********************************************************************************************************************************
This file represents the event decription written by the user.

Available predicates:
-happensAt(E, T) represents a time-point T in which an event E occurs. 
-holdsFor(U, L) represents the list L of the maximal intervals in which a U holds. 
-holdsAt(U, T) representes a time-point in which U holds. holdsAt may be used only in the body of a rule.
-initially(U) expresses the value of U at time 0. 
-initiatedAt(U, T) states the conditions in which U is initiated. initiatedAt may be used only in the head of a rule.
-terminatedAt(U, T) states the conditions in which U is terminated. terminatedAt may be used only in the head of a rule.

For backward compatibility the following predicates are also allowed:

-initiates(E, U, T) states that the occurrence of event E at time T initiates a period of time for which U holds. initiates may be used only in the head of a rule.
-terminates(E, U, T) states that the occurrence of event E at time T terminates a period of time for which U holds. terminates may be used only in the head of a rule.

NOTE:
-The optimisation checks in the statically determined fluent definitions are optional.
**********************************************************************************************************************************/

/*********************************** MARITIME CE DEFINITIONS *************************************/

/****************************************
 *		  STOPPED 		*
 ****************************************/

initiatedAt(stopped(Vessel)=true,T):-
    happensAt(velocity(Vessel,Speed,_CoG,_TrHeading),T),
    Speed < 0.5.  %knots

terminatedAt(stopped(Vessel)=true,T):-
    happensAt(velocity(Vessel,Speed,_CoG,_TrHeading),T),
    Speed >= 0.5. %knots


/****************************************
 *	         LOWSPEED		*
 ****************************************/

initiatedAt(lowSpeed(Vessel)=true,T):-
    happensAt(velocity(Vessel,Speed,_CoG,_TrHeading),T),
    Speed >= 0.5,  %knots
    Speed < 5.0.   %knots

terminatedAt(lowSpeed(Vessel)=true,T):-
    happensAt(velocity(Vessel,Speed,_CoG,_TrHeading),T),
    Speed < 0.5.  %knots

terminatedAt(lowSpeed(Vessel)=true,T):-
    happensAt(velocity(Vessel,Speed,_CoG,_TrHeading),T),
    Speed >= 5.0.     %knots

/****************************************
 *		 UNDERWAY		*
 ***************************************/

initiatedAt(underWay(Vessel)=true,T):-
    happensAt(velocity(Vessel,Speed,_CoG,_TrHeading),T),
    Speed >= 2.7,  %knots
    Speed < 50.   %knots

terminatedAt(underWay(Vessel)=true,T):-
    happensAt(velocity(Vessel,Speed,_CoG,_TrHeading),T),
    Speed < 2.7.  %knots

terminatedAt(underWay(Vessel)=true,T):-
    happensAt(velocity(Vessel,Speed,_CoG,_TrHeading),T),
    Speed >= 50.     %knots

/****************************************
 *		 TRAVELSPEED		*
 ***************************************/
holdsFor(travelSpeed(Vessel)=true,I):-
    holdsFor(underWay(Vessel)=true,Iu),
    holdsFor(lowSpeed(Vessel)=true,Il),
    relative_complement_all(Iu,[Il],I).




