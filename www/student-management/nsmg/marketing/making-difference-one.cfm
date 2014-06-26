
<Cfquery name="repInfo" datasource="#application.dsn#">
select firstname, lastname, email, phone
from smg_users
where userid = #client.userid#
</cfquery>
<Cfquery name="regionSite" datasource="#application.dsn#">
select url
from smg_regions
where regionid = #client.regionid#
</cfquery>
<cfdocument format="PDF" margintop=".25" marginbottom=".25" marginright=".25" marginleft=".25" backgroundvisible="yes" overwrite="no" fontembed="yes" bookmark="false" localurl="no" saveasname="Making-Difference-One.pdf" >

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>ISE Making a Difference</title>

</head>

<body>
<Cfoutput>
<div style="height: 3235px; width: 2500px; display: block; background-image:url(making-difference-1.jpg); background-repeat:no-repeat; background-position:center;">
<div style="width: 800px; background-color: ##fff; display: block; margin-top: 2750px; margin-left: 140px;">

<p style="font-family: sans-serif; font-size: 50px; text-align: center; color: ##000; line-height:65px;"><strong>#repInfo.firstname# #repInfo.lastname#</strong><br />
          P: #repInfo.phone#<br />
           #repInfo.email#<br>
           #regionSite.url#</p>

      </div>
    </div>
    </Cfoutput>
</body>
</html>
</cfdocument>
