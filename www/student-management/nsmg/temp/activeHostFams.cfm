<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Active Host Families</title>
</head>

<body>
<Cfquery name="activeHost" datasource="mysql">
select distinct s.hostId, r.regionname, h.familylastname, h.email, p.programname, c.companyid, c.companyshort, s.studentid
from smg_students s
left join smg_hosts h on h.hostid = s.hostid
left join smg_programs p on p.programid = s.programid
left join smg_companies c on c.companyid = s.companyid
left join smg_regions r on r.regionid = s.regionassigned
where s.active = 1 and (s.companyid = 1 or s.companyid = 2 or s.companyid = 3 or s.companyid = 4 or s.companyid = 5 or s.companyid = 10 or s.companyid = 12)
and h.email <> ''
order by companyshort, regionname
</cfquery>
Company Short, Region, Program, Student ID, Host ID, Family Last Name, Email<Br />
<Cfoutput>
<cfloop query="activeHost">
#companyshort#, #regionname#, #programname#, #studentid#, #hostid#, #familylastname#, #email#<br />
</cfloop> 
</Cfoutput>
</body>
</html>
