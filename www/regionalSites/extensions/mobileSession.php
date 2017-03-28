<?php
/**
 * MIT License
 * ===========
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * -----------------------------------------------------------------------
 *
 *
 * Run this in your browser to see the example!
 *
 *
 *
 * IMPORTANT: Clear your sessions/cookies before running UA tests.
 *
 * This is a procedural approach example of how to switch your website layout
 * based on a variable $layoutType.
 *
 * The example also includes the switch links that you can put in the footer
 * of your page. Is a good practice to let the user switch between layouts,
 * even if he is visiting the page from a phone or tablet.
 * ------------------------------------------------------------------------
 *
 * @author      Serban Ghita <serbanghita@gmail.com>
 * @license     MIT License https://github.com/serbanghita/Mobile-Detect/blob/master/LICENSE.txt
 *
 */

// This is mandatory if you're using sessions.
session_start();

// It's mandatory to include the library.
require_once 'mobileDetect/Mobile_Detect.php';	

/**
 *  Begin helper functions.
 */

// Your default site layouts.
// Update this array if you have fewer layout types.
function layoutTypes()
{
    return array('classic', 'mobile', 'tablet');

}

function initLayoutType()
{
    // Safety check.
    if (!class_exists('Mobile_Detect')) { return 'classic'; }

    $detect = new Mobile_Detect;
    $isMobile = $detect->isMobile();
    $isTablet = $detect->isTablet();

    $layoutTypes = layoutTypes();

    // Set the layout type.
    if ( isset($_GET['layoutType']) ) {

        $layoutType = $_GET['layoutType'];

    } else {

        if (empty($_SESSION['layoutType'])) {

            $layoutType = ($isMobile ? ($isTablet ? 'tablet' : 'mobile') : 'classic');

        } else {

            $layoutType =  $_SESSION['layoutType'];

        }

    }

    // Fallback. If everything fails choose classic layout.
    if ( !in_array($layoutType, $layoutTypes) ) { $layoutType = 'classic'; }

    // Store the layout type for future use.
    $_SESSION['layoutType'] = $layoutType;

    return $layoutType;

}

/**
 *  End helper functions.
 */

// Let's roll. Call this function!
$layoutType = initLayoutType();

/**
 *
 * Example of layout switch links.
 * Eg. ['Classic' | Mobile | 'Tablet']
 *
 */
?>