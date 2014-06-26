
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

<cfdocument format="PDF" margintop=".25" marginbottom=".25" marginright=".25" marginleft=".25" backgroundvisible="yes" overwrite="no" fontembed="yes" bookmark="false" localurl="no" saveasname="Making-Difference-Two.pdf" >

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>ISE Making a Difference International</title>

</head>

<body>
<Cfoutput>
<div style="height: 3235px; width: 2500px; display: block; background-image:url(making-difference-2.jpg); background-repeat:no-repeat; background-position:center; border: 1px ##FFF solid;">
<div style="width: 2100px; display: block; margin: 3100px auto 0; ">

<p style="font-family: sans-serif; font-size: 60px; text-align:  center; color: ##fff;"><strong>#repInfo.firstname# #repInfo.lastname#</strong> -
        #repInfo.phone# -
           #repInfo.email# - #regionSite.url#</p>

      </div>
    </div>
    </Cfoutput>
</body>
</html>
</cfdocument>
