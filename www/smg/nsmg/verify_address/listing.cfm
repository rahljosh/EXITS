<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
<style type="text/css">
<!--
.style9 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFFFF; font-weight: bold; }
.style14 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; }
.style16 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold; }
.thin-border{ border: 1px solid #000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
-->
</style>

</head>
<body>
<cfparam name="url.text" default="0">
<cfparam name="low_price" default="0">
<cfparam name="high_price" default="0">
<cfparam name="beds" default="0">
<cfparam name="baths" default="0">
<cfparam name="city" default="any">
<cfparam name="area" default="any">



<script type="text/javascript" src="wz_tooltip.js"></script>



<table align="center" bgcolor="white" cellpadding=0 cellspacing="0" >
	
	<tr>	
		<td colspan=2><img src="pics/top_search.jpg" />	<br /><br />
	</tr>
	<tr>
		<td valign="top" width=50%>
<cfquery name="city" datasource="bricks">
select distinct city from listings_residential
where
listing_office_name = 350001857
order by city
</cfquery>

<cfquery name="area" datasource="bricks">
select distinct area from listings_residential
where
listing_office_name = 350001857
order by area
</cfquery>
		
<cfquery name="listings" datasource="bricks">
select *
from listings_residential
where listing_office_name = 350001857
<cfif isDefined('url.agent')>
and agent = #url.agent#
</cfif>
order by asking_price
</cfquery>
<cfoutput>

<table  bgcolor="##FFFFCC" cellpadding=4>
	<Tr>
		<Td>
<strong>Price:</strong>
<select name="low_price" style="width:100px;">
	<option selected="selected" value="0">No Minimum</option>
	<option value="500">$500</option>
	<option value="1000">$1,000</option>
	<option value="1500">$1,500</option>

	<option value="2000">$2,000</option>
	<option value="5000">$5,000</option>
	<option value="10000">$10,000</option>
	<option value="20000">$20,000</option>
	<option value="30000">$30,000</option>
	<option value="40000">$40,000</option>

	<option value="45000">$45,000</option>
	<option value="50000">$50,000</option>
	<option value="55000">$55,000</option>
	<option value="60000">$60,000</option>
	<option value="70000">$70,000</option>
	<option value="75000">$75,000</option>

	<option value="100000">$100,000</option>
	<option value="125000">$125,000</option>
	<option value="150000">$150,000</option>
	<option value="175000">$175,000</option>
	<option value="200000">$200,000</option>
	<option value="225000">$225,000</option>

	<option value="250000">$250,000</option>
	<option value="275000">$275,000</option>
	<option value="300000">$300,000</option>
	<option value="325000">$325,000</option>
	<option value="350000">$350,000</option>
	<option value="400000">$400,000</option>

	<option value="450000">$450,000</option>
	<option value="500000">$500,000</option>
	<option value="550000">$550,000</option>
	<option value="600000">$600,000</option>
	<option value="650000">$650,000</option>
	<option value="700000">$700,000</option>

	<option value="750000">$750,000</option>
	<option value="800000">$800,000</option>
	<option value="850000">$850,000</option>
	<option value="900000">$900,000</option>
	<option value="1000000">$1,000,000+</option>


</select></Td><td> to </td><td>
<select name="high_price" style="width:120px;">
	<option selected="selected" value="0">No Minimum</option>
	<option value="500">$500</option>
	<option value="1000">$1,000</option>
	<option value="1500">$1,500</option>

	<option value="2000">$2,000</option>
	<option value="5000">$5,000</option>
	<option value="10000">$10,000</option>
	<option value="20000">$20,000</option>
	<option value="30000">$30,000</option>
	<option value="40000">$40,000</option>

	<option value="45000">$45,000</option>
	<option value="50000">$50,000</option>
	<option value="55000">$55,000</option>
	<option value="60000">$60,000</option>
	<option value="70000">$70,000</option>
	<option value="75000">$75,000</option>

	<option value="100000">$100,000</option>
	<option value="125000">$125,000</option>
	<option value="150000">$150,000</option>
	<option value="175000">$175,000</option>
	<option value="200000">$200,000</option>
	<option value="225000">$225,000</option>

	<option value="250000">$250,000</option>
	<option value="275000">$275,000</option>
	<option value="300000">$300,000</option>
	<option value="325000">$325,000</option>
	<option value="350000">$350,000</option>
	<option value="400000">$400,000</option>

	<option value="450000">$450,000</option>
	<option value="500000">$500,000</option>
	<option value="550000">$550,000</option>
	<option value="600000">$600,000</option>
	<option value="650000">$650,000</option>
	<option value="700000">$700,000</option>

	<option value="750000">$750,000</option>
	<option value="800000">$800,000</option>
	<option value="850000">$850,000</option>
	<option value="900000">$900,000</option>
	<option value="1000000">$1,000,000+</option>

</select></td>

<td>
<strong>City*:</strong></td><td>
<select name="city" >
	<option selected="selected" value="any">Any</option>
	<cfloop query="city">
	<option value="#city#">#city#</option>
	</cfloop>


</select>

</td>
<td><strong>Area*:</strong></td><td>
<select name="area" >
	<option selected="selected" value="any">Any</option>
	<cfloop query="area">
	<option value="#area#">#area#</option>
	</cfloop>


</select></td>

</Tr><tr>
<td> <b>Beds:</b> 
<select name="rooms" >
	<option selected="selected" value="0">Any</option>
	<option value="1">1+ Beds</option>
	<option value="2">2+ Beds</option>
	<option value="3">3+ Beds</option>
	<option value="4">4+ Beds</option>

	<option value="5">5+ Beds</option>

</select>
</td>
<td></td>
<td>
<b>Baths:</b> <select name="ctl00$ctl00$cphC$cphM$sw$bathddl" id="ctl00_ctl00_cphC_cphM_sw_bathddl" class="hs-SelFld" style="width:80px;">
	<option selected="selected" value="0">Any</option>
	<option value="1">1+ Baths</option>
	<option value="2">2+ Baths</option>
	<option value="3">3+ Baths</option>
	<option value="4">4+ Baths</option>

</select>
</td>

</Tr>
<br />
<Tr><Td colspan=8>*indicates that an item is limited to what is currently active in the database.</Td></Tr>
</table>
                       
                
</cfoutput>


























<br />

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="thin-border-bottom">
	<tr>
		<td><a href="?curdoc=details/listing&text=0"><img src="pics/pics<cfif url.text eq 0>2</cfif>.png" border=0/></a><a href="?curdoc=details/listing&text=1"><img src="pics/text.png"  border=0/></a><a href="?curdoc=details/listing&text=2"><img src="pics/map.png" border=0 /></a></td>
	</tr>
</table>
<br />

<cfif url.text eq 1> 
<table width=100% align="center">
	<tr>
		<td>MLS#</td>
		<td>Price</td>
		<Td>Area</Td>
		<td></td>
		<td>City</td>
		<td>Bedroom</td>
		<td>Full Baths</td>
		<td>Half Baths</td>
		<td>Sqr Foot</td>
	</tr>
<cfoutput query="listings">
<span id="#mls#"><img src="details/pics/POCATELLO#mls#.jpg" width=175 /></span> 

	<tr>
		<td><A href="index.cfm?curdoc=details/details&mls=#mls#" onmouseover="TagToTip('#mls#')">#mls#</A></td>
		<Td> #LSCurrencyFormat(asking_price,'local')#</Td>
		<td> #area#</td>
		<Td></Td>
		<td>#city#</td>
		<td>#total_bedrooms#</td><td>#total_full_baths#</td><td>#total_half_bath#</td><td>#total_sqr#</td> 
	</tr>
</cfoutput>

	</table>
	
	
	<!-------------End of page------->
	</td></tr></table>
<cfelse>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<cfoutput query="listings">
  <tr>

    <td>

			<table width="97%" border="0" align="center" cellpadding="5" cellspacing="0" bordercolor="##661500">
			  <tr>
				<td width="36%" rowspan="4" bordercolor="##661500" bgcolor="##661500"><div align="center">
			
				<cfdirectory directory="/var/www/html/bricks-sticks/details/pics" name="file" filter="POCATELLO#mls#.jpg">
				<Cfif file.recordcount>
					<a href="?curdoc=details/details&mls=#mls#"><img src="details/pics/POCATELLO#mls#.jpg" width="160" height="119" border="1" /></a>
				<cfelse>
					<img src="pics/no_house.gif" />
				</cfif>
				</div></td>
				<td width="33%" bgcolor="##661500"><span class="style9"><a href="?curdoc=details/details&mls=#mls#"><font color="white"><u>MLS## #mls#</u></a></span></td>
				<td width="31%" bgcolor="##661500"><p class="style9">Price: $#asking_price#</p></td>
			  </tr>
			  <tr>
				<td bordercolor="##FFFFFF"><p class="style14"><strong>&nbsp; Area:</strong> #area#</p></td>
				<td bordercolor="##FFFFFF"><span class="style14"><strong>Bedroom:</strong> #bedrooms# </span></td>
			  </tr>
			  <tr>
				<td bordercolor="##FFFFFF" bgcolor="##F3EBEB"><span class="style16">&nbsp; City: </span><span class="style14">#city#</span></td>
				<td bordercolor="##FFFFFF" bgcolor="##F3EBEB"><span class="style14"><strong>Full Baths:</strong> #full_baths# </span></td>
			  </tr>
			  <tr>
				<td bordercolor="##FFFFFF"><span class="style14"><strong>&nbsp; Sqr Foot:</strong> #total_sqr#</span></td>
				<td bordercolor="##FFFFFF"><span class="style14"><strong>Half Baths:</strong> #total_half_bath# </span></td>
			  </tr>
			</table>
	
	</td>
 

  </tr>
  <tr>
  	<td>&nbsp:
	</td>
  </tr>
  	</cfoutput>
</table>

</cfif>

<br />
</body>
</html>
