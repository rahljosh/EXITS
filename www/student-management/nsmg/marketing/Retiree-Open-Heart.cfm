
<Cfquery name="repInfo" datasource="#application.dsn#">
select firstname, lastname, email,  work_phone as phone
from smg_users
where userid = #client.userid#
</cfquery>

<Cfquery name="regionSite" datasource="#application.dsn#">
select url
from smg_regions
where regionid = #client.regionid#
</cfquery>

<cfdocument format="PDF" margintop=".25" marginbottom=".25" marginright=".25" marginleft=".25" backgroundvisible="yes" overwrite="no" fontembed="yes" bookmark="false" localurl="no" saveasname="Open-Heart-Home.pdf" >

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>ISE Open Your Heart and Home</title>

</head>

<body>
<Cfoutput>
<div style="height: 3235px; width: 2500px; display: block; background-image:url(Retiree-Open-house.jpg); background-repeat:no-repeat; background-position:center; border: 0px solid ##fff;">
<div style="width: 900px; display: block; margin-top: 1800px; margin-left: 1250px;">

<p style="font-family: sans-serif; font-size: 65px; text-align: center; color: ##fff; float: right; line-height:85px;"><strong>#repInfo.firstname# #repInfo.lastname#</strong><br />
          P: #repInfo.phone#<br />
           #repInfo.email#<br>
           #regionSite.url#</p>

      </div>
    </div>
    </Cfoutput>
</body>
</html>
</cfdocument>
