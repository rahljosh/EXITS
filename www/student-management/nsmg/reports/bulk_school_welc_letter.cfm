<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" >
<head>

	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />

    <style media="screen" type="text/css">
		.page-break {page-break-after: always}
    /* <!-- */
    /* General styles */
    body {
        margin:0;
        padding:0;
        border:0;			/* This removes the border around the viewport in old versions of IE */
        width:100%;
        background:#fff;
        min-width:600px;    /* Minimum width of layout - remove line if not required */
							/* The min-width property does not work in old versions of Internet Explorer */
		font-size:90%;
    }
	a {
    	color:#369;
	}
	a:hover {
		color:#fff;
		background:#369;
		text-decoration:none;
	}
    h1, h2, h3 {
        margin:.8em 0 .2em 0;
        padding:0;
    }
    p {
        margin:.4em 0 .8em 0;
        padding:0;
    }
	img {
		margin:10px 0 5px;
	}
	/* Header styles */
    #header {
        clear:both;
        float:left;
        width:100%;
    }
	#header {
		border-bottom:1px solid #000;
	}
	#header p,
	#header h1,
	#header h2 {
	    padding:.4em 15px 0 15px;
        margin:0;
	}
	#header ul {
	    clear:left;
	    float:left;
	    width:100%;
	    list-style:none;
	    margin:10px 0 0 0;
	    padding:0;
	}
	#header ul li {
	    display:inline;
	    list-style:none;
	    margin:0;
	    padding:0;
	}
	#header ul li a {
	    display:block;
	    float:left;
	    margin:0 0 0 1px;
	    padding:3px 10px;
	    text-align:center;
	    background:#eee;
	    color:#000;
	    text-decoration:none;
	    position:relative;
	    left:15px;
		line-height:1.3em;
	}
	#header ul li a:hover {
	    background:#369;
		color:#fff;
	}
	#header ul li a.active,
	#header ul li a.active:hover {
	    color:#fff;
	    background:#000;
	    font-weight:bold;
	}
	#header ul li a span {
	    display:block;
	}
	/* 'widths' sub menu */
	#layoutdims {
		clear:both;
		background:#eee;
		border-top:4px solid #000;
		margin:0;
		padding:6px 15px !important;
		text-align:right;
	}
	/* column container */
	.colmask {
	    position:relative;		/* This fixes the IE7 overflow hidden bug */
	    clear:both;
	    float:left;
        width:100%;			/* width of whole page */
		overflow:hidden;	/* This chops off any overhanging divs */
	}
	/* common column settings */
	.colright,
	.colmid,
	.colleft {
		float:left;
		width:100%;
		position:relative;
	}
	.col1,
	.col2,
	.col3 {
		float:left;
		position:relative;
		padding:0 0 1em 0;
		overflow:hidden;
	}
	/* Full page settings */
	.fullpage {
		background:#fff;		/* page background colour */
	}
	.fullpage .col1 {
		width:96%;				/* page width minus left and right padding */
		left:2%;				/* page left padding */
	}
	/* Footer styles */
	#footer {
        clear:both;
        float:left;
        width:100%;
		border-top:1px solid #000;
    }
    #footer p {
        padding:10px;
        margin:0;
    }
    /* --> */
    </style>
</head>
<body>
<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_studentss" datasource="mysql">
	SELECT s.studentid, s.familylastname, s.firstname, s.arearepid, s.regionassigned, s.hostid, s.dateplaced, 
		s.schoolid, s.grades, s.countryresident, s.sex, s.dateplaced,
		h.hostid, h.familylastname AS h_lastname, h.address AS h_address, h.address2 AS h_address2, h.city AS h_city, h.state AS h_state, h.zip AS h_zip, h.phone as h_phone,
		sc.schoolid, sc.schoolname, sc.principal, sc.address AS sc_address, sc.address2 AS sc_address2, sc.city AS sc_city, sc.state AS sc_state, sc.zip AS sc_zip, sc.phone AS sc_phone,
		ar.userid, ar.lastname AS ar_lastname, ar.firstname AS ar_firstname, ar.address AS ar_address, ar.address2 AS ar_address2, ar.city AS ar_city, 
		ar.state AS ar_state, ar.zip AS ar_zip, ar.phone AS ar_phone,
		c.countryname,
		p.programname, p.startdate, p.enddate
	FROM smg_students s
	INNER JOIN smg_hosts h ON s.hostid = h.hostid
	INNER JOIN smg_schools sc ON s.schoolid = sc.schoolid
	INNER JOIN smg_users ar ON s.arearepid = ar.userid
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.active = '1'
    AND
		<cfif CLIENT.companyID EQ 5>
        	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,12" list="yes"> )
      	<cfelse>
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
        AND s.hostid != '0'
		AND s.host_fam_approved <= '4'
		<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
			AND (s.dateplaced between #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#) 
		</cfif>
     <cfif LEN(FORM.regionID)>
        AND 
            s.regionAssigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
    </cfif>
	AND 
        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
	ORDER BY s.familylastname, s.firstname	
</cfquery>

<cfoutput query="get_studentss">


<div class="colmask fullpage">


<!--- School info --->
<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<Tr>
		<td colspan=4>
		<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left"></td>	
	<td valign="top" align="right"> 
		
		#companyshort.companyname#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif>
	</td></tr>		
</table>

				<hr width=585 align="center">
		</td>
	</Tr>

	<tr>
		<td align="left">
			#principal#<br>
			#schoolname#<br>
			#sc_address#<br>
			<Cfif sc_address2 is ''><cfelse>#sc_address2#<br></cfif>
			#sc_city#, #sc_state# #sc_zip#<br>
		</td>
		<td align="right" valign="top">
			Program: #programname#<br>
			From: #DateFormat(startdate, 'mmm dd, yyyy')# to #DateFormat(enddate, 'mmm dd, yyyy')#	
		</td>
	</tr>
	<tr><td align="right" colspan="2"><cfif dateplaced LTE '2007-07-30'>#DateFormat(dateplaced, 'dddd, mmmm dd, yyyy')#<cfelse>#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</cfif></td></tr>

<tr><td><b>Student: #firstname# #familylastname# from #countryname#</b></td></tr>

	<tr>
		<td align="left">
			<b>Host Family:</b><br>
			#h_lastname# Family<br>
			#h_address#<br>
			<Cfif h_address2 is ''><cfelse>#h_address2#<br></Cfif>
			#h_city#, #h_state# #h_zip#<br>
			<Cfif h_phone is ''><cfelse>Phone: &nbsp; #h_phone#<br></Cfif>
		</td>
		<td align="right">
			<b>Area Representative:</b><br>
			#ar_firstname# #ar_lastname#<br>
			#ar_address#<br>
			<Cfif ar_address2 is ''><cfelse>#ar_address2#<br></Cfif>
			#ar_city#, #ar_state# #ar_zip#<br>
			<Cfif ar_phone is ''><cfelse>Phone: &nbsp; #ar_phone#<br></Cfif>
		</td>
	</tr>

	<tr>
		<td align="justify" colspan = 2>
            <p>
            #companyshort.companyname# would like to thank you for allowing #get_letter_info.firstname# #get_letter_info.lastName#
            to attend your school. <cfif client.companyid NEQ 14>#companyshort.companyshort_nocolor# has issued a #CLIENT.DSFormName# for #get_letter_info.firstname# and 
            #get_letter_info.firstname# is now in the process of securing a <cfif client.companyID EQ 15>F-1 <cfelse>J1</cfif>visa. Upon arrival #get_letter_info.firstname# will have 
            received a visa from the US consulate.</cfif>
            </p>
			
			<p>We have asked the #h_lastname# family to help #firstname# in enrolling and registering
			in your school.
			</p>
			
			<p>We wish to let you know that #firstname# is being supervised by #ar_firstname# 
			#ar_lastname#, <cfif companyshort.companyid is 4>a <cfelse>an </cfif>#companyshort.companyshort_nocolor# Area Representative. 
			#companyshort.companyshort_nocolor# Area Representatives act as a counselor to assist the student, school and host family should there be any
			concerns during #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> stay in the US.
			</p>
			
			<p>Please feel free to contact #ar_firstname# #ar_lastname# anytime you feel it would be appropriate.
			In addition, the #companyshort.companyshort_nocolor# Student Services Department, at #companyshort.toll_free#, is available to your school,
			host family and student should there ever be a serious concern with the host family, student or area representative.
			</p>
			
			<!--- GRADUATE STUDENTS - COUNTRY 49 = COLOMBIA / COUNTRY 237 = VENEZUELA --->
			<cfif grades EQ 12 OR (grades EQ 11 AND (countryresident EQ '49' OR countryresident EQ '237'))>
			<p>We hope that #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
			help to increase global understanding and friendship in your school and community. We would like to note that #firstname#
			will have completed secondary school in <cfif sex EQ 'male'>his<cfelse>her</cfif> native country upon arrival. Please let us know if we can assist you at 
			any time during #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
			</p>
			<cfelse>
			<p>We hope that #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
			help to increase global understanding and friendship in your school and community. Please let us know if we can assist you at 
			any time during #firstname#'<cfif #right(firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
			</p>
			</cfif>
			
			<p>Very truly yours,<br>
			#companyshort.lettersig#<br>
			#companyshort.companyname#<br>
			</p>
			

</td>
</Tr>
</table>

</div>

<DIV style="page-break-after:always"></DIV>

</cfoutput>

</body>
</html>
