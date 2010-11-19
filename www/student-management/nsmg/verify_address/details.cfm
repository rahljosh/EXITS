<head>
<LINK href="pics/favicon.ico" type=image/x-icon rel="shortcut icon">
<LINK href="pics/bricks.css" type=text/css rel=stylesheet>
<style type="text/css">
<!--
body {
	background-color: #000000;
}
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #FFFFFF;
	font-weight: bold;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.style3 {
	font-size: 16px;
	font-weight: bold;
	color: #666666;
}
.style6 {font-size: 16px; font-weight: bold; color: #666666; font-family: Verdana, Arial, Helvetica, sans-serif; }
.thin-border{ border: 1px solid #000000;}
-->
</style></HEAD>
<BODY>



<cfquery name="listing_details" datasource="bricks">
select *
from listings_residential
where mls = #url.mls#
</cfquery>

<cfquery name="agent" datasource="bricks">
select * from users
where agentmlsid = #listing_details.agent#
</cfquery>

<table align="center" bgcolor="white" cellpadding=0 cellspacing="0" >
	
	<tr>	
		<td colspan=2><img src="pics/top-details.jpg" />	<br /><br />
	</tr>
	
	<tr>
		<td valign="top" width=50% >


<TABLE cellSpacing=0 cellPadding=0 width=760 align=center bgColor=#000000 
border=0>
  <TBODY>
  <TR>
    <TD><TABLE class=red_outline cellSpacing=0 cellPadding=10 width="100%" 
      align=center bgColor=white>
        <TBODY>
        <TR>
          <TD width="100%" valign="top">
		  
              <SCRIPT>
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
    if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}
              </SCRIPT>
			  

<cfdirectory directory="/var/www/html/bricks-sticks/details/pics/" action="list" name="house_images" filter="POCATELLO#url.mls#*.jpg" recurse="no"> 

<cfoutput>

            <table width="100%" border="0" cellspacing="0" cellpadding="0" valign="top">
              <tr>
                <td width="44%" valign="top" heignt=10%>
				
				
				<table width="50%" border="0" align="center" cellpadding="4" cellspacing="0" bgcolor="##661500">
                  <tr>
                    <td><img 
            src="details/pics/POCATELLO#url.mls#.jpg" 
            width=250></td>
                  </tr>
                  <tr>
                    <td><div align="center"><span class="style1">#LSCurrencyFormat(listing_details.asking_price,'local')#</span></div></td>
                  </tr>
                </table> 
				<br>
				<table width="80%" border="0" align="center" cellpadding="2" cellspacing="0">
				    <tr>
                    <td><span class="style2"><span class="style3">Details</span></span></td>
                  </tr>
                  <tr>
                    <td><span class="style2">&nbsp; #listing_details.bedrooms# Bedrooms</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2">&nbsp; #listing_details.full_baths# Full Bath</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2">&nbsp; #listing_details.half_baths# Half 
                      Bath</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2">&nbsp; #listing_details.total_sqr# Sqr ft</span></td>
                  </tr>
                  <tr>
                    <td height="30"><hr width="80%" color="##F4E3E3"></td>
                  </tr>
                  <tr>
                    <td><span class="style2"><span class="style3">Location</span></span></td>
                  </tr>
                  <tr>
                    <td><span class="style2"><strong>&nbsp; City:</strong> #listing_details.city#</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2"><strong>&nbsp; Area: </strong>#listing_details.area#</span></td>
                  </tr>
                  <tr>
                    <td height="30"><hr width="80%" color="##F4E3E3"></td>
                  </tr>
                  <tr>
                    <td><span class="style6">Details</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2"><strong>&nbsp; Heat Type:</strong> #listing_details.primary_heat_type#</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2"><strong>&nbsp; Heat Source</strong>: #listing_details.primary_heat_source#</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2"><strong>&nbsp; A/C:</strong> #listing_details.ac#</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2"><strong>&nbsp; Elementery School:</strong> #listing_details.elem_school#</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2"><strong>&nbsp; Middle School:</strong> #listing_details.middle_school#</span></td>
                  </tr>
                  <tr>
                    <td><span class="style2"><strong>&nbsp; High 
                      School:</strong>#listing_details.high_schools#</span></td>
                  </tr>
                </table>
				
				
				
				
				
				                 
                  </td>
                <td width="56%" rowspan="2" valign="top"><TABLE width="100%" border=0 align=center cellpadding="2" cellspacing="0" bordercolor="##661500" valign="top">
                  <Table class="thin-border">
		
                    <TR>
                      <TD height="20" colspan="4" align=middle  bgcolor="##661500" ><div align="center" class="style1">
                        <div align="left">&nbsp; Additional Pictures: </div>
                      </div>                        <div align="center"></div>                        <div align="center"></div>                        <div align="center"></div></TD>
                      </TR>
				<cfif house_images.recordcount eq 0>
				<tr>
					<TD width="25%" align=middle bordercolor="##FFFFFF">
					<img src="pics/no_house.gif">
					</TD>
				</tr>	
				<cfelse>  
					 <TR>
					  <TD bordercolor="##FFFFFF" align="center">
					  <Cfloop query="house_images">
						<img src="details/pics/#name#" width="125">
						
					</cfloop>
				</cfif>
                  </TBODY>
                </TABLE>
			
                 <br>
                  <table width="95%" border="0" align="center" cellpadding="2" cellspacing="2" bgcolor="##661500">
                    <tr>
                      <td width="21%" rowspan="2"><img src="pics/#agent.userid#.gif" 
            align=left></td>
                      <td width="79%"><div align="center"><span class="style1">#agent.firstname# #agent.lastname#</span></div></td>
                    </tr>
                    <tr>
                      <td bgcolor="##FFFFFF"><span class="style2"><strong>&nbsp; Direct Phone:</strong> #agent.directline#<br>
                              <strong>&nbsp; Email:</strong> <a 
            href="mailto:#agent.email#">#agent.email#</a></span></td>
                    </tr>
                  </table>
				  </td>
              </tr>
			  
               
              <tr>
                <td valign="top">
				
				<!-----Details went here---->
				
				
				
				
				
				</td>
              </tr>
            </table>
            </TD></TR>
					  <cfif listing_details.public_remarks is not ''>
					                   <tr>
                    <td><span class="style6">Additional Info</span></td>
                  </tr>
				  	<tr>
						<td colspan=10>#listing_details.public_remarks#</td>
					</tr>
				 </cfif></TBODY></TABLE></TD></TR>
	
			
			
			</TBODY></TABLE>
			
				
</cfoutput>
</BODY></HTML>
