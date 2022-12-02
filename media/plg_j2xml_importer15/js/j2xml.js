/**
 * @package     Joomla.Plugins
 * @subpackage  J2xml.Importer15
 *
 * @version     __DEPLOY_VERSION__
 * @since       3.7.27
 *
 * @author      Helios Ciancio <info (at) eshiol (dot) it>
 * @link        https://www.eshiol.it
 * @copyright   Copyright (C) 2016 - 2022 Helios Ciancio. All Rights Reserved
 * @license     http://www.gnu.org/licenses/gpl-3.0.html GNU/GPL v3
 * J2XML is free software. This version may have been modified pursuant to the
 * GNU General Public License, and as distributed it includes or is derivative
 * of works licensed under the  GNU  General  Public  License or other free or
 * open source software licenses.
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

if (typeof(eshiol.j2xml.validated) === 'undefined') {
	eshiol.j2xml.validated = [];
}

eshiol.j2xml.importer15 = {};
eshiol.j2xml.importer15.version = '__DEPLOY_VERSION__';
eshiol.j2xml.importer15.requires = '22.12.373';
eshiol.j2xml.importer15.requiresJ2XML = '3.9.222';

console.log('J2XML - Importer 1.5 plugin v' + eshiol.j2xml.importer15.version);

/**
 *
 * @param {}
 *            root
 * @return {}
 */
 eshiol.j2xml.convert
 		.push(function(data) {
			console.log('eshiol.j2xml.convert.importer15');
			if (versionCompare(eshiol.j2xml.version, eshiol.j2xml.importer15.requires) < 0) {
				eshiol.renderMessages({
					'error' : [ 'J2XML - Importer 1.5 v'
					+ eshiol.j2xml.importer15.version
					+ ' requires J2XML ' + eshiol.j2xml.importer15.requiresJ2XML ]
				});
				return false;
			}

			var plg_j2xml_importer15Options  = Joomla.getOptions('plg_j2xml_importer15');

			if (plg_j2xml_importer15Options) {
				console.log('Ajax: ' + plg_j2xml_importer15Options.Ajax);
			}

			if (plg_j2xml_importer15Options && (plg_j2xml_importer15Options.Ajax != 0)) {
				console.log('Client side processing...');

				if (versionCompare(eshiol.j2xml.version, eshiol.j2xml.importer15.requires) < 0) {
					eshiol.renderMessages({
						'error': ['J2XML - Importer 1.5 v' + eshiol.j2xml.importer15.version+' requires J2XML v' + eshiol.j2xml.importer15.requires]
					});
					return false;
				}
				console.log(data);

				try {
					xmlDoc = jQuery.parseXML(data);
					xml = jQuery(xmlDoc);
					root = xml.find(":root")[0];

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
						data = this.Processor.transformToDocument(root)
						xml = jQuery(data);
						root = xml.find(":root")[0];
						data = '<?xml version="1.0" encoding="UTF-8" ?>' + "\n" + eshiol.XMLToString(root);
					}
				} catch (e) {
					return false;
				}
			}

			return data;
		});

/**
 *
 * @param {} data
 * @return  {}
 */
eshiol.j2xml.validate.push(function(data)
{
	console.log('eshiol.j2xml.importer15.validate');

	if (versionCompare(eshiol.j2xml.version, eshiol.j2xml.importer15.requires) < 0)
	{
		eshiol.renderMessages({
			'error': ['J2XML - Importer 1.5 v' + eshiol.j2xml.importer15.version + ' requires J2XML v' + eshiol.j2xml.importer15.requiresJ2XML]
		});
		return false;
	}

	try {
	   	xmlDoc = jQuery.parseXML(data);
		xml = jQuery(xmlDoc);
		root = xml.find(":root")[0];

		console.log('eshiol.j2xml.importer15.validated: ' + ((root.nodeName == "j2xml") && (jQuery(root).attr('version') == '1.5.6.74')));

		return ((root.nodeName == "j2xml") && (jQuery(root).attr('version') == '1.5.6.74'));
	} catch (e) {
		return false;
	}
});
