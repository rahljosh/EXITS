<!--
    in reality you'd have this in an external stylesheet;
    i am using it like this for the sake of the example
-->
<style type="text/css">
    .Zebra_Form .optional { padding: 10px 50px; display: none }
</style>

<!--
    again, in reality you'd have this in an external JavaScript file;
    i am using it like this for the sake of the example
-->


<?php echo (isset($zf_error) ? $zf_error : (isset($error) ? $error : ''))?>

<div class="row">
    <?php echo $label_name . $nameTitle?>
</div>
<div class="row">
    <?php echo $label_email . $email?>
</div>
<div class="row">
    <?php echo $label_comments . $userComments?>
</div>


<div class="row last"><?php echo $btnsubmit?></div>