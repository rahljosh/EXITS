<?php
/*
 * [JAS]: [TODO] Eventually this should be a loop with only a single box drawing routine.
 *   That would be a lot more extendible for customers.
 *
 */

$cells_rendered = 0;
$cell_moved = true;
?>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  <?php if($pubgui->settings["pub_mod_open_ticket"]) { ?>
    <td valign="top" align="center"><table width="280"  border="0" cellpadding="1" cellspacing="0" class="menubox_border_idle" onmouseover="this.className='menubox_border_active';" onmouseout="this.className='menubox_border_idle';">
        <tr> 
          <td valign="top" align="center"><table width="100%"  border="0" cellpadding="3" cellspacing="0" class="menubox_idle" onmouseover="this.className='menubox_active';" onmouseout="this.className='menubox_idle';">
              <tr> 
                <td valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="64" height="64" align="center" bgcolor="#E6E6E6"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/48x48/icon_open_ticket.gif"></td>
                      <td width="10">&nbsp;</td>
                      <td width="204" class="box_content_text" valign="top"><a href="<?php echo $module_urls["open_ticket"]; ?>" class="url_lg">Open a Ticket</a><br>
                        Need assistance?  Open up a ticket and let our team know what we can do to help!
                      </td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
      </table>
    </td>
  <?php $cells_rendered++; $cell_moved = true; } else { $cell_moved = false; } ?>
  
  <?php if($cell_moved && $cells_rendered % 2 == 0) { ?>
  </tr>
  <tr> 
    <td height="8" colspan="2"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="1" height="8"></td>
  </tr>
  <tr> 
  <?php } ?>
  
  <?php if($pubgui->settings["pub_mod_track_tickets"]) { ?>
    <td valign="top" align="center"><table width="280"  border="0" cellpadding="1" cellspacing="0" class="menubox_border_idle" onmouseover="this.className='menubox_border_active';" onmouseout="this.className='menubox_border_idle';">
        <tr> 
          <td valign="top" align="center"><table width="100%"  border="0" cellpadding="3" cellspacing="0" class="menubox_idle" onmouseover="this.className='menubox_active';" onmouseout="this.className='menubox_idle';">
              <tr> 
                <td valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="64" height="64" align="center" bgcolor="#E6E6E6"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/48x48/icon_ticket_history.gif"></td>
                      <td width="10">&nbsp;</td>
                      <td width="204" class="box_content_text" valign="top"><a href="<?php echo $module_urls["track_tickets"]; ?>" class="url_lg">Ticket History</a><br>
                        Review your past ticket history and read or reply to open tickets.
                      </td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
      </table>
    </td>
  <?php $cells_rendered++; $cell_moved = true; } else { $cell_moved = false; } ?>
    
  <?php if($cell_moved && $cells_rendered % 2 == 0) { ?>
  </tr>
  <tr> 
    <td height="8" colspan="2"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="1" height="8"></td>
  </tr>
  <tr> 
  <?php } ?>
  
  <?php if($pubgui->settings["pub_mod_kb"]) { ?>  
    <td valign="top" align="center"><table width="280"  border="0" cellpadding="1" cellspacing="0" class="menubox_border_idle" onmouseover="this.className='menubox_border_active';" onmouseout="this.className='menubox_border_idle';">
        <tr> 
          <td valign="top" align="center"><table width="100%"  border="0" cellpadding="3" cellspacing="0" class="menubox_idle" onmouseover="this.className='menubox_active';" onmouseout="this.className='menubox_idle';">
              <tr> 
                <td align="center" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="64" height="64" align="center" bgcolor="#E6E6E6"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/48x48/icon_knowledgebase.gif"></td>
                      <td width="10">&nbsp;</td>
                      <td width="204" class="box_content_text" valign="top"><a href="<?php echo $module_urls["kb_tree"]; ?>" class="url_lg">Browse Knowledgebase</a><br>
                        Need an answer fast?  Browse our knowledgebase for articles on a broad range of topics.
                      </td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
      </table>
    </td>
  <?php $cells_rendered++; $cell_moved = true; } else { $cell_moved = false; } ?>
   
  <?php if($cell_moved && $cells_rendered % 2 == 0) { ?>
  </tr>
  <tr> 
    <td height="8" colspan="2"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="1" height="8"></td>
  </tr>
  <tr> 
  <?php } ?>
  
  <?php if($pubgui->settings["pub_mod_my_account"]) { ?>    
    <td valign="top" align="center"><table width="280"  border="0" cellpadding="1" cellspacing="0" class="menubox_border_idle" onmouseover="this.className='menubox_border_active';" onmouseout="this.className='menubox_border_idle';">
        <tr> 
          <td valign="top" align="center"><table width="100%"  border="0" cellpadding="3" cellspacing="0" class="menubox_idle" onmouseover="this.className='menubox_active';" onmouseout="this.className='menubox_idle';">
              <tr> 
                <td valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="64" height="64" align="center" bgcolor="#E6E6E6"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/48x48/icon_my_account.gif"></td>
                      <td width="10">&nbsp;</td>
                      <td width="204" class="box_content_text" valign="top"><a href="<?php echo $module_urls["my_account"]; ?>" class="url_lg">My Account</a><br>
                        Manage your contact information and set your personal preferences.
                      </td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
      </table>
    </td>
  <?php $cells_rendered++; $cell_moved = true; } else { $cell_moved = false; } ?>
  
  <?php if($cell_moved && $cells_rendered % 2 == 0) { ?>
  </tr>
  <?php } else { ?>
    <td height="8"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="1" height="8"></td>
  </tr>
  <?php } ?>
    
  </tr>

</table>
<br>