<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:10
         compiled from display/display_ticket_navbar.tpl.php */ ?>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="1">
              <tr> 
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_thread_bg_css; ?>
" align="center" width="0%" nowrap>
                	<img src="includes/images/spacer.gif" width="10" height="1" border="0"><a href="<?php echo $this->_tpl_vars['urls']['tab_display']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_thread_css; ?>
"><?php echo @constant('LANG_DISPLAY_DISPLAY'); ?>
</a><img src="includes/images/spacer.gif" width="10" height="1" border="0">
                </td>
                <td>&nbsp;</td>

                <?php if ($this->_tpl_vars['urls']['tab_props']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_props_bg_css; ?>
" align="center" width="0%" nowrap>
                	<img src="includes/images/spacer.gif" width="10" height="1" border="0"><a href="<?php echo $this->_tpl_vars['urls']['tab_props']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_props_css; ?>
"><?php echo @constant('LANG_DISPLAY_PROPS'); ?>
</a><img src="includes/images/spacer.gif" width="10" height="1" border="0">
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>
                
                <?php if ($this->_tpl_vars['urls']['tab_antispam']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_antispam_bg_css; ?>
" align="center" width="0%" nowrap>
                	<img src="includes/images/spacer.gif" width="10" height="1" border="0"><a href="<?php echo $this->_tpl_vars['urls']['tab_antispam']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_antispam_css; ?>
"><?php echo @constant('LANG_DISPLAY_ANTISPAM'); ?>
</a><img src="includes/images/spacer.gif" width="10" height="1" border="0">
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>
                
                <?php if ($this->_tpl_vars['urls']['tab_log']): ?>
                <td class="<?php echo $this->_tpl_vars['tabs']->tab_log_bg_css; ?>
" align="center" width="0%" nowrap>
                	<img src="includes/images/spacer.gif" width="10" height="1" border="0"><a href="<?php echo $this->_tpl_vars['urls']['tab_log']; ?>
" class="<?php echo $this->_tpl_vars['tabs']->tab_log_css; ?>
"><?php echo @constant('LANG_DISPLAY_LOG'); ?>
</a><img src="includes/images/spacer.gif" width="10" height="1" border="0">
                </td>
                <td>&nbsp;</td>
                <?php endif; ?>

                <td width="100%">
                	&nbsp;
                </td>
                
              </tr>
            </table>
          </td>
        </tr>
        <tr bgcolor="#858585"> 
          <td valign="top"><img src="includes/images/spacer.gif" width="1" height="2" alt=""></td>
        </tr>
        <tr> 
          <td valign="top"><img src="includes/images/spacer.gif" width="1" height="5" alt=""></td>
        </tr>
      </table>