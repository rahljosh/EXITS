
<Cfquery name="missingActivation" datasource="#application.dsn#">
select distinct s.studentid, s.firstname as StudentFirst, s.familylastname as StudentLast, 
s.sevis_activated as ActiveBatch, sevis.received, program.programName,
flight.dep_date
from smg_students s
left join smg_sevis sevis on sevis.batchid = s.sevis_activated
left join smg_sevis_history on smg_sevis_history.studentid = s.studentid
left join smg_flight_info flight on flight.studentid = s.studentid
left join smg_programs program on program.programid = s.programid
and flight.flight_type = 'arrival'
AND flight.dep_date <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
AND s.active = 1
AND sevis.received = 'no'
AND program.active = 1
limit 25
</Cfquery>

<Cfdump var="#missingActivation#">

