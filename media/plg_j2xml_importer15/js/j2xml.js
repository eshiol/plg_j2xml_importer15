/**
 * @version		3.7.27 media/plg_j2xml_importer15/js/j2xml.js
 * 
 * @package		J2XML
 * @subpackage	plg_j2xml_importer15
 * @since		3.7.27
 *
 * @author		Helios Ciancio <info@eshiol.it>
 * @link		http://www.eshiol.it
 * @copyright	Copyright (C) 2013, 2017 Helios Ciancio. All Rights Reserved
 * @license		http://www.gnu.org/licenses/gpl-3.0.html GNU/GPL v3
 * J2XML is free software. This version may have been modified pursuant
 * to the GNU General Public License, and as distributed it includes or
 * is derivative of works licensed under the GNU General Public License 
 * or other free or open source software licenses.
 */

// Avoid `console` errors in browsers that lack a console.
(function () {
	var methods = [
		'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
		'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
		'profile', 'profileEnd', 'table', 'time', 'timeEnd', 'timeStamp',
		'trace', 'warn'
	];
	console = window.console = window.console || {};
	methods.forEach(function (method) {
		if (!console[method]) {
			console[method] = function () {};
		}
	});
}());
  
console.log('Importer 1.5 for J2XML v3.7.27');

if (typeof(eshiol) === 'undefined') {
	eshiol = {};
}

if (typeof(eshiol.j2xml) === 'undefined') {
	eshiol.j2xml = {};
}

if (typeof(eshiol.j2xml.convert) === 'undefined') {
	eshiol.j2xml.convert = [];
}

/**
 * 
 * @param {} root
 * @return  {}
 */ 
eshiol.j2xml.convert.push(function(xml)
{   
	console.log('eshiol.j2xml.convert.importer15');
	console.log(xml);

   	xmlDoc = jQuery.parseXML(xml);
	$xml = jQuery(xmlDoc);
	root = $xml.find(":root")[0];

	if ((root.nodeName == "j2xml") && (jQuery(root).attr('version') == '1.5.6.74'))
	{
		var xmlResp = new DOMParser();
		var xmlHttp = new XMLHttpRequest();
		xmlHttp.open("GET", '/plugins/j2xml/importer15/1506.xsl', false);
		// Make sure the returned document has the correct MIME type
		xmlHttp.overrideMimeType("application/xslt+xml");
		xmlHttp.send(null);
		this.Processor = new XSLTProcessor();
		// Just interpret the returned data as XML instead of parsing in a separate step
		this.Processor.importStylesheet(xmlHttp.responseXML);
		xml = this.Processor.transformToDocument(root)
		$xml = jQuery(xml);
		root = $xml.find(":root")[0];
		xml = eshiol.XMLToString(root);
	}
	return xml;
});