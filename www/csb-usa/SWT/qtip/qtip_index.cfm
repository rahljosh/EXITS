<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<style>


</style>
<script type="text/javascript">
// Create the tooltips only on document load
$(document).ready(function() 
{
   // By suppling no content attribute, the library uses each elements title attribute by default
   $('#content a[href][title]').qtip({
      content: {
         text: false // Use each elements title attribute
      },
      style: 'cream' // Give it some style
   });
   
   // NOTE: You can even omit all options and simply replace the regular title tooltips like so:
   // $('#content a[href]').qtip();
});
</script>
<div id="content" class="default"> 
<div class="center"> 
   <h2>Q-Tip (rapper)</h2> 
   <img class="right" src="http://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/(ATCQ)Q-Tip_in_DC.jpg.jpg/220px-(ATCQ)Q-Tip_in_DC.jpg.jpg" alt="" /> 
   <p>Jonathan Davis (born April 10, 1970), better known by his stage name <a href="#" title="That sounds familiar...">Q-Tip</a>, is an American hip hop artist, singer, and occasional actor from Queens, New York City, perhaps best known as part of the critically acclaimed group A Tribe Called Quest.</p> 
   
   <h4>Personal Life</h4> 
   <p>Q-Tip was born in Harlem, New York. He attended Murry Bergtraum High School in Manhattan, <a href="#" title="The Big Apple">New York</a>. He converted to Islam in the mid-1990s, and changed his name to Kamaal Ibn John Fareed. The Q in Q-Tip's stage name stands for Queens, the borough of New York City from which he hails. On Martha Stewart he said his name <a href="#" title="I'm sure I've heard that before...">Q-tip</a> was his childhood nickname because he was skinny and had big hair.</p> 
   
   <h4>Career</h4> 
   <p>A Tribe Called Quest disbanded in 1998, after which Q-Tip pursued a solo career. His first solo singles, "Vivrant Thing" and "Breathe &amp; Stop", were far more pop-oriented than anything he had done in A Tribe Called Quest, as was his solo debut LP for Arista Records, Amplified. His 2002 follow-up, Kamaal the Abstract, although critically acclaimed and issued a catalog number, was <a href="#" title="Citation needed">never released</a> because the label believed that it did not have commercial appeal.</p> 
 
   <p>As of late, <a href="#" title="Hmm....">Q-Tip</a> has been very active, once again happily reunited with the full line-up of A Tribe Called Quest on the 2K7 NBA Bounce Tour, Rock the Bells Tour '08, and regaining control of his previously label-owned MySpace page. He has announced that he is negotiating for the ownership of the masters of earlier material from his previous labels and plans to release them independently.</p> 
   <br /> 
   <p> 
      <b>Source:</b> Wikipedia<br /> 
      <b>Image:</b> Joe Cereghino
   </p> 
</div> 
</div>

<script type="text/javascript" src="/projects/qtip/js/jquery.1.3.2.min.js"></script>
<script type="text/javascript" src="/projects/qtip/js/jquery.qtip-1.0.0.min.js"></script> 
</body>
</html>