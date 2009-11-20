<?php
$kb_keywords = (isset($_REQUEST["kb_keywords"])) ? htmlentities(stripslashes($_REQUEST["kb_keywords"])) : "";
?>

<table cellpadding="0" cellspacing="0" border="0" width='100%' id="box">
	<tr>
		<td class="boxtitle">Knowledgebase</td>
	</tr>
	
	<tr>
		<td>
			<table width="100%"  border="0" align="center" cellpadding="3" cellspacing="0">
			    <form action="<?php echo BASE_URL; ?>">
			      <input type="hidden" name="mod_id" value="<?php echo MODULE_KNOWLEDGEBASE; ?>">
			      <tr>
			        <td class="box_content_text">Search by keywords: </td>
			      </tr>
			      <tr>
			        <td align="center">
						<input name="kb_keywords" size="20" class="home_input" style="width:99%;" value="<?php echo $kb_keywords; ?>"><br>
			        </td>
			      </tr>
			      <tr align="center" valign="top">
			        <td height="30"><span class="box_content_cell"><input type="submit" class="home_button" value="Find" style="width:99%;"></span>
			        </td>
			      </tr>
			    </form>
			</table>		
		</td>
	</tr>
	
</table>
<br>		
