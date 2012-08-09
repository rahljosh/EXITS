<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<script language="javascript">
	function cancelation() {
		if (document.form2.status.value == 'active') {
			document.getElementById('cancelation').style.display = 'none';
		}
		if (document.form2.status.value == 'inactive') {
			document.getElementById('cancelation').style.display = 'none';
		}
		if (document.form2.status.value == 'cancel') {
			document.getElementById('cancelation').style.display = '';
		}
	}
</script> 

<body>
<form id="form2" name="form2" method="post" action="">
  <select id="status" name="status" onchange="javascript:cancelation();">
    <option value="active">active</option>
    <option value="inactive">inactive</option>
    <option value="cancel">cancel</option>
  </select>
</form>

<table id="cancelation" cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
								
									<table width="100%" cellpadding=5 cellspacing=0 border=0>
										<tr bgcolor="#C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Cancelation	</td>
									  </tr>
										<tr>
											<td width="20">
dfg gf sdfgsfdg dgf 555
										  </td>
											<td width="1083" class="style1">Candidate Cancelled &nbsp; <b>Date:</b> &nbsp; <input type="text" class="style1" name="cancel_date" size=8 value="fdhgfghfhg"></td>
										</tr>
										<tr>
											<td colspan="2">
												<table width="100%">
													<tr>
														<td class="style1" bordercolor="FFFFFF" align="right" valign="top"><b>Reason:</b></td>
														<td width="990" class="style1"><input type="text" class="style1" name="cancel_reason" size=20 value=""></td>
													</tr>
												</table>
											</td>										
										</tr>
									</table>
									
								</td>
							</tr>
</table>
						
						<br id="cancelation">
						
						test
						
						<script language="javascript">
							// hide field reason (changing program)
							document.getElementById('cancelation').style.display = 'none';
						</script> 
						444555
</body>
</html>
