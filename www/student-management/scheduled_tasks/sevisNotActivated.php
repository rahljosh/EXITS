<Cfquery name="missingActivation" datasource="#appliation.dsn#">
select distinct s.studentid, s.firstname as StudentFirst, s.familylastname as StudentLast, 
s.sevis_activated as ActiveBatch, sevis.received,
flight.dep_date
from smg_students s
left join smg_sevis sevis on sevis.batchid = s.sevis_activated
left join smg_sevis_history on smg_sevis_history.studentid = s.studentid
left join smg_flight_info flight on flight.studentid = s.studentid
where s.studentid = 35443
and flight.flight_type = 'arrival'
AND flight.dep_date <= '2013-09-16'
AND s.active = 1
AND sevis.received = 'no'

</Cfquery>

<Cfdump var="#missingActivation#">

