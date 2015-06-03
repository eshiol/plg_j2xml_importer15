<?php
/**
 * @version		3.1.18 plugins/j2xml/importer15/importer15.php
 * 
 * @package		J2XML
 * @subpackage	plg_j2xml_importer15
 * @since		2.5
 *
 * @author		Helios Ciancio <info@eshiol.it>
 * @link		http://www.eshiol.it
 * @copyright	Copyright (C) 2013 Helios Ciancio. All Rights Reserved
 * @license		http://www.gnu.org/licenses/gpl-3.0.html GNU/GPL v3
 * J2XML is free software. This version may have been modified pursuant
 * to the GNU General Public License, and as distributed it includes or
 * is derivative of works licensed under the GNU General Public License 
 * or other free or open source software licenses.
 */
 
// no direct access
defined('_JEXEC') or die('Restricted access.');

jimport('joomla.plugin.plugin');
jimport('joomla.application.component.helper');
jimport('joomla.filesystem.file');
jimport('eshiol.j2xml.version');

class plgJ2XMLImporter15 extends JPlugin
{
	var $_params = null;
	/**
	 * CONSTRUCTOR
	 * @param object $subject The object to observe
	 * @param object $params  The object that holds the plugin parameters
	 * @since 1.5
	 */
	function __construct(&$subject, $params)
	{
		parent::__construct($subject, $params);		

		$lang = JFactory::getLanguage();
		$lang->load('plg_j2xml_importer15', JPATH_SITE, null, false, false)
			|| $lang->load('plg_j2xml_importer15', JPATH_ADMINISTRATOR, null, false, false)
			|| $lang->load('plg_j2xml_importer15', JPATH_SITE, null, true)
			|| $lang->load('plg_j2xml_importer15', JPATH_ADMINISTRATOR, null, true);	
	}

	/**
	 * Method is called by 
	 *
	 * @access	public
	 */
	public function onBeforeImport($context, &$xml)
	{
		if (get_class($xml) != 'SimpleXMLElement')
			return false;
		
		$error = false;
		if (!class_exists('XSLTProcessor'))
		{
			JError::raiseWarning(1, JText::_('PLG_J2XML_IMPORTER15').' '.JText::_('PLG_J2XML_IMPORTER15_MSG_REQUIREMENTS_XSL'));
			$error = true;
		}

		if (version_compare(J2XMLVersion::getShortVersion(), '13.8.3') == -1)
		{
			JError::raiseWarning(1, JText::_('PLG_J2XML_IMPORTER15').' '.JText::_('PLG_J2XML_IMPORTER15_MSG_REQUIREMENTS_LIB'));
			$error = true;
		}
		
		if ($error) return false;
		
		if (!($version = $xml->xpath('/j2xml/@version')))
		{
			return true;
		}
		else if (version_compare($version[0], '1.5.81', 'gt'))
		{
			return true;
		}

		$fixtimezone  = '<xsl:template name="fixTimezone"><xsl:param name="timezone"></xsl:param><xsl:choose>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-12\'" >'.$this->params->get("timezone-12"  ,"Pacific/Midway").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-11\'" >'.$this->params->get("timezone-11"  ,"Pacific/Midway").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-10\'" >'.$this->params->get("timezone-10"  ,"Pacific/Honolulu").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-9.5\'" >'.$this->params->get("timezone-95"  ,"Pacific/Marquesas").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-9\'" >'.$this->params->get("timezone-9"   ,"America/Adak").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-8\'" >'.$this->params->get("timezone-8"   ,"America/Nome").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-7\'" >'.$this->params->get("timezone-7"   ,"America/Los_Angeles").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-6\'" >'.$this->params->get("timezone-6"   ,"America/Mexico_City").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-5\'" >'.$this->params->get("timezone-5"   ,"America/Bogota").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-4.5\'" >'.$this->params->get("timezone-45"  ,"America/Caracas").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-4\'" >'.$this->params->get("timezone-4"   ,"America/Detroit").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-3.5\'" >'.$this->params->get("timezone-35"  ,"America/St_Johns").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-3\'" >'.$this->params->get("timezone-3"   ,"America/Sao_Paulo").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-2\'" >'.$this->params->get("timezone-2"   ,"Atlantic/South_Georgia").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'-1\'" >'.$this->params->get("timezone-1"   ,"Atlantic/Azores").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'0\'" >'.$this->params->get("timezone0"    ,"Europe/London").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'1\'" >'.$this->params->get("timezone1"    ,"Europe/Rome").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'2\'" >'.$this->params->get("timezone2"    ,"Europe/Istanbul").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'3\'" >'.$this->params->get("timezone3"    ,"Asia/Baghdad").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'3.5\'" >'.$this->params->get("timezone35"   ,"Asia/Tehran").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'4\'" >'.$this->params->get("timezone4"    ,"Asia/Muscat").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'4.5\'" >'.$this->params->get("timezone45"   ,"Asia/Kabul").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'5\'" >'.$this->params->get("timezone5"    ,"Asia/Karachi").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'5.5\'" >'.$this->params->get("timezone55"   ,"Asia/Colombo").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'5.75\'" >'.$this->params->get("timezone575"  ,"Asia/Kathmandu").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'6\'" >'.$this->params->get("timezone6"    ,"Asia/Almaty").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'6.5\'" >'.$this->params->get("timezone65"   ,"Asia/Rangoon").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'9\'" >'.$this->params->get("timezone9"    ,"Asia/Tokyo").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'9.5\'" >'.$this->params->get("timezone95"   ,"Australia/Adelaide").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'10\'" >'.$this->params->get("timezone10"   ,"Pacific/Guam").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'10.5\'" >'.$this->params->get("timezone105"  ,"Australia/Lord_Howe").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'11\'" >'.$this->params->get("timezone11"   ,"Asia/Magadan").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'11.5\'" >'.$this->params->get("timezone115"  ,"Pacific/Norfolk").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'12\'" >'.$this->params->get("timezone12"   ,"Pacific/Auckland").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'12.75\'" >'.$this->params->get("timezone1275" ,"Pacific/Chatham").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'13\'" >'.$this->params->get("timezone13"   ,"Pacific/Tongatapu").'</xsl:when>';
		$fixtimezone .= '<xsl:when test="$timezone = \'14\'" >'.$this->params->get("timezone14"   ,"Pacific/Kiritimati").'</xsl:when>';
		$fixtimezone .= '</xsl:choose></xsl:template>';
		
		$xslt = new XSLTProcessor();
		$xslfile = new DOMDocument();
		// $xslfile->load(JPATH_ROOT.'/plugins/j2xml/importer15/1506.xsl');
		$xslfile->loadXML(
			str_replace(
				'<xsl:template name="fixTimezone"><xsl:param name="timezone"></xsl:param></xsl:template>', 
				$fixtimezone, 
				file_get_contents(JPATH_ROOT.'/plugins/j2xml/importer15/1506.xsl')
			)
		);
		$xslt->importStylesheet($xslfile);
		$xml = $xslt->transformToXML($xml);
		$xml = simplexml_load_string($xml);
		return true;
	}
}
