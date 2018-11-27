/**
 * 
 * @package		J2XML
 * @subpackage	plg_j2xml_importer15
 * @version		3.7.32
 * @since		3.7.27
 *
 * @author		Helios Ciancio <info@eshiol.it>
 * @link		http://www.eshiol.it
 * @copyright	Copyright (C) 2013, 2018 Helios Ciancio. All Rights Reserved
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

if (typeof(eshiol) === 'undefined') {
	eshiol = {};
}

if (typeof(eshiol.j2xml) === 'undefined') {
	eshiol.j2xml = {};
}

if (typeof(eshiol.j2xml.convert) === 'undefined') {
	eshiol.j2xml.convert = [];
}

eshiol.j2xml.importer15 = {};
eshiol.j2xml.importer15.version = '3.7.32';
eshiol.j2xml.importer15.requires = '18.8.310';

console.log('J2XML - Importer 1.5 v'+eshiol.j2xml.importer15.version);

/**
 * 
 * @param {} root
 * @return  {}
 */ 
eshiol.j2xml.convert.push(function(xml)
{   
	console.log('eshiol.j2xml.convert.importer15');
	if (versionCompare(eshiol.j2xml.version, eshiol.j2xml.importer15.requires) < 0)
	{
		eshiol.renderMessages({
			'error': ['J2XML - Importer 1.5 v'+eshiol.j2xml.importer15.version+' requires J2XML v3.7.173']
		});
		return false;
	}
	console.log(xml);

    try {
       	xmlDoc = jQuery.parseXML(xml);
    } catch (err) {
        return xml;
    }
	$xml = jQuery(xmlDoc);
	root = $xml.find(":root")[0];

	if ((root.nodeName == "j2xml") && (jQuery(root).attr('version') == '1.5.6.74'))
	{
		var xmlResp = new DOMParser();
		var xmlHttp = new XMLHttpRequest();
		xmlHttp.open("GET", '../plugins/j2xml/importer15/1506.xsl', false);
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
