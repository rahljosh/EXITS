<link rel="stylesheet" href="../../smg.css" type="text/css">
<style type="text/css">
<!--
.style1 {font-family: Verdana, Arial, Helvetica, sans-serif}
.style3 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; }
body {
	background-color: #f4f4f4;
}
-->
</style>

 <table cellpadding=3 cellspacing=3 border=1 align="center" width="98%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
							  <td bordercolor="FFFFFF">
                               <cfform action="qr_upload_candidate_picture.cfm?uniqueid=#url.uniqueid#" method="post" enctype="multipart/form-data" preloader="no">
 
                       		    <table width="98%" border=0 align="center" cellpadding=3 cellspacing=0 bordercolor="#C7CFDC" bgcolor="#ffffff">
                                <tr bgcolor="#C2D1EF">
                                  <td height="16" bgcolor="#8FB6C9" class="style1"><strong><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">:: Photo Upload</font></strong></td>
                                  </tr>
                                <tr >
                                  <td ><span class="style3">Please upload a head shot of the candidate.  A passport photo works great, but any photo will be fine.<br />
                                      <br />
                                  </span>
                                    <div align="center"><span class="style3"> Browse for the file..
                                      <input type="file" name="candidate_pic" size="35"  enctype="multipart/form-data" />
                                          <br />
                                      *image type needs to be either a .jpg, .jpeg,  or a .gif <br />
                                      <br />
                                      <input type="image" src="../../pics/save.gif" alt="Upload Picture to Server" />
                                      <br />
                                    </span></div>
                                    <br />                                 </td>
                                  </tr> 
							</table>
         
                          </cfform>
                       
                       	      </td>
   						    </tr>

 </table>


 