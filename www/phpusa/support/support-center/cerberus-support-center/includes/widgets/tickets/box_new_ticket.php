<?php
require_once (FILESYSTEM_PATH . "cerberus-api/utility/sort/cer_PointerSort.class.php");
require_once (FILESYSTEM_PATH . "cerberus-api/custom_fields/cer_CustomField.class.php");

if(!isset($pubgui->mailboxes[$t])) {
	die("ERROR: Invalid destination.");
}

$mailbox = $pubgui->mailboxes[$t];

$team_name = $mailbox['mailbox_alias'];

$fld_group_id = $mailbox['field_group'];
$fld_group = new cer_PublicGUIFieldGroups($fld_group_id);
$sorted_display_fields = array();

$field_handler = new cer_CustomFieldGroupHandler();
$field_handler->loadGroupTemplates();

class DisplayGroup {
	var $group_name = null;
	var $sorted_fields = null;
	var $field_ptrs = array();
};

$display_fields = array();

if(!empty($fld_group->active_group->fields))
foreach($fld_group->active_group->fields as $idx => $f) {
	$gid = $field_handler->field_to_template[$f->field_id]->group_id;
	$fid = $f->field_id;
	
	if(!isset($display_fields[$gid])) {
		$display_fields[$gid] = new DisplayGroup();
		$display_fields[$gid]->group_name = $field_handler->field_to_template[$fid]->group_name;
	}
	
	$display_fields[$gid]->field_ptrs[] = &$fld_group->active_group->fields[$idx];
}

if(!empty($display_fields)) {
	foreach($display_fields as $idx => $df) {
		$display_fields[$idx]->sorted_fields = cer_PointerSort::pointerSortCollection($display_fields[$idx]->field_ptrs,"field_order");
	}
	
	$sorted_display_fields = cer_PointerSort::pointerSortCollection($display_fields,"group_name");
}

?>

<script language="javascript1.2">
	function validateForm() {
		pass = true;
		
		if(document.open_ticket.nt_from.value == "") pass = false;
		if(document.open_ticket.nt_subject.value == "") pass = false;
		if(document.open_ticket.nt_content.value == "") pass = false;
		
		<?php 
		foreach($sorted_display_fields as $df)
		foreach($df->sorted_fields as $f) { 
			if($f->field_option == 2) { ?>
			if(document.open_ticket.field_<?php echo $f->field_id; ?>.value == "") pass = false;
		<?php
			 }
		 }
		?>
		
		if(!pass) {
			alert("You must fill in all fields marked with an asterisk (*).");
		}
		
		return pass;
	}
</script>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
<form enctype="multipart/form-data" name="open_ticket" name="<?php echo $_SERVER['PHP_SELF']; ?>" method="post" onsubmit="javascript:return validateForm();">
<input type="hidden" name="mod_id" value="<?php echo MODULE_OPEN_TICKET; ?>">
<input type="hidden" name="nt_tid" value="<?php echo $t; ?>">
<input type="hidden" name="form_submit" value="open_ticket">
	<tr>
		<td class="table_header_cell"><span class="black_heading">Send a Ticket to '<?php echo $team_name; ?>'</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				<tr>
					<td colspan="3" class="box_content_text"><span class="required_asterisk">*</span> = Required Field</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>IP:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><?php echo $_SERVER['REMOTE_ADDR']; ?></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>E-mail Address</B><span class='required_asterisk'>*</span>:</td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text">
						<?php if($cer_session->is_logged_in) { ?>
							<?php echo $cer_session->user_email; ?>
							<input type="hidden" name="nt_from" value="<?php echo $cer_session->user_email; ?>">
						<?php } else { ?>
							<input type="text" name="nt_from" size="40" value="">
						<?php }	?>
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Subject</B><span class='required_asterisk'>*</span>:</td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="nt_subject" size="40" value=""></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><b>Body</b><span class='required_asterisk'>*</span>:</td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><textarea rows="15" cols="40" name="nt_content"></textarea></td>
				</tr>
			</table>
		
		</td>
	</tr>
	
</table>

<br>

<?php 
if(!empty($display_fields))
foreach($sorted_display_fields as $df) {
?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading"><?php echo $df->group_name; ?></span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				<tr>
					<td colspan="3"><img src="includes/images/spacer.gif" height="2" width="1"></td>
				</tr>
				<?php foreach($df->sorted_fields as $f) { ?>
				<tr>
					<td valign="top" class="box_content_text"><B><?php echo $f->field_name; ?></B><?php echo (($f->field_option == 2) ? "<span class='required_asterisk'>*</span>" : ""); ?>:</td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text">
						<?php
						switch($f->field_type) {
							case "T": ?>
								<textarea name="field_<?php echo $f->field_id; ?>" rows="5" cols="40"></textarea>
								<?php
								break;
							case "E": ?>
								<input type="text" size="8" maxlength="8" name="field_<?php echo $f->field_id; ?>">
								(enter as <b>mm/dd/yy<b>)
								<?php
								break;
							case "S": ?>
								<input type="text" size="40" name="field_<?php echo $f->field_id; ?>" value="">
								<?php
								break;
								
							case "D": ?>
								<select name="field_<?php echo $f->field_id; ?>">
									<option value="">
									<?php 
									if(!empty($field_handler->field_to_template[$f->field_id]->fields[$f->field_id]->field_options))
									foreach($field_handler->field_to_template[$f->field_id]->fields[$f->field_id]->field_options as $oid => $o) {	?>
										<option value="<?php echo $oid; ?>"><?php echo $o; ?>
									<?php } ?>
								</select>
								<?php
								break;
						}
						?>
						<input type="hidden" name="field_ids[]" value="<?php echo $f->field_id; ?>">
					</td>
				</tr>
				<?php } ?>
				
			</table>
		
		</td>
	</tr>
	
</table>

<br>

<?php } 

// Added file attachment support. [JSJ] 

// If you want additional upload fields just duplicate the input fields below
// The code will automatically add as many files as are uploaded.

?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Add File Attachment(s)</span></td>
	</tr>
	<tr class="white_back">
		<td>
		   <table cellpadding=2 cellspacing=1 border=0>
		      <tr>
		         <td class="box_content_text">
			File attachment #1:&nbsp;<input name="file1" type="file" /><br />
			File attachment #2:&nbsp;<input name="file2" type="file" /><br />	
			      </td>
			    </tr>
			 </table>		
		</td>
	</tr>
</table>

<table cellpadding="4" cellspacing="1" border="0" class="white_back" width='100%'>
	<tr>
		<td class="white_back" align="right"><input type="submit" class="button_style" value="Send Ticket"></td>
	</tr>
</table>

</form>
