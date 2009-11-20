<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Host Family Welcome Letter</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>
<div class="page-break">

<style type="text/css" media="print">
	.page-break {page-break-after: always}
</style>
<cfinclude template="../querys/get_company_short.cfm">


	<cfif form.print_form is "hf">
            
            <cfinclude template="host_fam_letter_template.cfm">
                
 	<cfelse>
  				
    		<cfinclude template="stu_letter_template.cfm">
    
    
    </cfif>
