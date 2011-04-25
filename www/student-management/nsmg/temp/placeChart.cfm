<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body><br />
<cfquery name="placed" datasource="mysql">
    select smg_students.firstname, smg_students.familylastname, smg_students.studentid, 
    smg_students.programid, smg_students.regionassigned, smg_students.dateplaced,
    smg_regions.regionname, smg_students.companyid
    from smg_students
    left join smg_regions on smg_regions.regionid = smg_students.regionassigned
    where smg_students.dateplaced between '2009-09-01' AND '2010-08-31'
	and (smg_students.companyid <= 5 or smg_students.companyid = 12)
    order by regionassigned, dateplaced
</cfquery>

<cfquery name="regions" dbtype="query">
select distinct regionassigned, regionname
from placed
order by regionassigned
</cfquery>


<cfoutput>
<table>
	<tr>
   		<td></td><td>Sept</td><td>Oct</td><td>Nov</td><td>Dec</td><td>Jan</td><td>Feb</td><td>Mar</td><td>Apr</td><td>May</td><td>Jun</td><td>Jul</td><td>Aug</td>
    </tr>
<cfloop query="regions">
	<tr>
    	<td>#regionname#</td>
	<cfloop list="09,10,11,12,01,02,03,04,05,06,07,08" index=m>
<cfquery name="placed" datasource="mysql">
    select count(studentid) as noStu
    from smg_students
    where smg_students.dateplaced between '2009-09-01' AND '2010-08-31'
    and month(dateplaced) = #m#
    and regionassigned = #regionassigned#
</cfquery>
   
		<td>#placed.noStu#</td>
     
	</cfloop>
	</tr>
    </cfloop>
</table>

</cfoutput>


<!----
<cfchart format="flash" xaxistitle="Region" yaxistitle = "Number Placements">
<cfchartseries type="bar" 
    query="month" 
    itemcolumn="regionname" 
    valuecolumn="noStu">
 
    <cfchartdata item="Facilities" value="35000">
    
    </cfchartseries>
</cfchart>
---->
</body>
</html>
