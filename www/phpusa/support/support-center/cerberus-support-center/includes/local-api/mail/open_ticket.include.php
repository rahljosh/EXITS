<?php
require_once (FILESYSTEM_PATH . "includes/local-api/mail/send_internal_mail.function.php");

function addCustomFields($ticket_id) {
	global $field_ids;
	
	$display_groups = array();
	$sorted_display_groups = array();
	
	if(!empty($field_ids)) {
	   $field_handler = new cer_CustomFieldGroupHandler();
	   $field_handler->loadGroupTemplates();
	
	   class DisplayGroup {
	   	var $group_id = 0;
	      var $group_name = null;
	      var $sorted_fields = null;
	      var $fields = array();
	   };
	
	   class DisplayField {
	   	var $field_id = 0;
	      var $field_name = null;
	      var $field_type = null;
	      var $field_value = null;
	   };
	
	   foreach($field_ids as $fid) {
	      $gid = $field_handler->field_to_template[$fid]->group_id;
	
	      if(!isset($display_groups[$gid])) {
	         $display_groups[$gid] = new DisplayGroup();
	         $display_groups[$gid]->group_id = $gid;
	         $display_groups[$gid]->group_name = $field_handler->field_to_template[$fid]->group_name;
	      }
	
	      $field = new DisplayField();
	      $fn = "field_" . $fid;
	      $val = isset($_REQUEST[$fn]) ? stripslashes($_REQUEST[$fn]) : "";
	
	      if(!empty($val)) {
	      	$field->field_id = $fid;
	         $field->field_name = $field_handler->group_templates[$gid]->fields[$fid]->field_name;
	         $field->field_type = $field_handler->group_templates[$gid]->fields[$fid]->field_type;
	         $field->field_value = $val;
	         $display_groups[$gid]->fields[$fid] = $field;
	      }
	   }
	
	   foreach($display_groups as $gid => $g) {
	      $display_groups[$gid]->sorted_fields = cer_PointerSort::pointerSortCollection($display_groups[$gid]->fields,"field_name");
	   }
	
	   $sorted_display_groups = cer_PointerSort::pointerSortCollection($display_groups,"group_name");
	}
	
	include_once(FILESYSTEM_PATH . "cerberus-api/custom_fields/cer_CustomField.class.php");
	$ch = new cer_CustomFieldGroupHandler();
	
	// Custom fields
	if(!empty($sorted_display_groups)) {
	   foreach($sorted_display_groups as $gid => $g) {
	      if(!empty($g->sorted_fields)) {
	      	$inst = $ch->addGroupInstance('T', $ticket_id,$g->group_id);
//			         $body .= "\r\n===[ " . $g->group_name . " ]===\r\n";
	
	         foreach($g->sorted_fields as $fid => $f) {
	         	// [JAS]: [TODO] We probably need some type handling here.
	         	$ch->setFieldInstanceValue($f->field_id,$inst,$f->field_value);
//			            $body .= $f->field_name . ": ";
//			            $body .= $f->field_value . "\r\n";
	         }
	      }
	   }
	}
}

$nt_to = isset($pubgui->mailboxes[$nt_tid]['mailbox_address']) ? $pubgui->mailboxes[$nt_tid]['mailbox_address'] : "";
$nt_from = stripslashes($nt_from);
$subject = stripslashes($nt_subject);

$body = "IP: " . $_SERVER['REMOTE_ADDR'] . "\r\n\r\n" .
stripslashes($nt_content) . "\r\n";

// Added file attachment support    [JSJ]
$attachments = array();
if(is_array($_FILES)) {
   foreach($_FILES as $file) {
      $attachment = array();
      $attachment['file_name'] = $file['name'];
      $attachment['file_type'] = $file['type'];
      $attachment['data'] = @file_get_contents($file['tmp_name']);
      if(strlen($attachment['data']) > 0 && $file['name']) {
         $attachments[] = $attachment;
      }
   }
}

if(!empty($nt_to) && !empty($nt_from)) {
	$ticket_id = send_internal_mail($nt_to,$subject,$body,$nt_from,$attachments);
	
	if($ticket_id) {
		if(is_numeric($ticket_id)) {
			addCustomFields($ticket_id);
		} else {
			// intentionally ignored...
		}
	} else {
		// failed...
	}
}
else {
   echo "ERROR: Invalid To: ($nt_to) or From: ($nt_from) address.  Aborting.<br>";
   exit;
}

?>
