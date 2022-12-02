<!--
/**
 * @package     Joomla.Plugins
 * @subpackage  J2xml.Importer15
 *
 * @version     __DEPLOY_VERSION__
 * @since       3.0.0
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
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output 
	cdata-section-elements="title alias introtext fulltext description attribs metadata name"
	encoding="UTF-8"
	indent="yes"
	/>

<xsl:variable name="maxcatid">
	<xsl:call-template name="max">
		<xsl:with-param name="list" select ="/j2xml/category/id" />
	</xsl:call-template>
</xsl:variable>

<xsl:template match="/j2xml[(count(/j2xml/content) &gt; 0) or (count(/j2xml/weblink) &gt; 0)]">
<j2xml version="15.9.0">
	<xsl:apply-templates select="/j2xml/content" />
	<xsl:apply-templates select="/j2xml/section" />
	<xsl:apply-templates select="/j2xml/category" />
	<xsl:apply-templates select="/j2xml/user" />
	<xsl:apply-templates select="/j2xml/img" />
	<xsl:apply-templates select="/j2xml/weblink" />
</j2xml>
</xsl:template>

<xsl:template match="/j2xml[(count(/j2xml/content) = 0) and (count(/j2xml/weblink) = 0)]">
<j2xml version="15.9.0">
	<xsl:apply-templates select="/j2xml/section" />
	<xsl:apply-templates select="/j2xml/category" />
	<xsl:apply-templates select="/j2xml/user" />
	<xsl:apply-templates select="/j2xml/img" />
</j2xml>
</xsl:template>

<xsl:template name="fixTimezone"><xsl:param name="timezone"></xsl:param></xsl:template>

<xsl:template name="fixTimezone2">
<xsl:param name="timezone"></xsl:param>
<xsl:choose>
	<xsl:when test="$timezone = '-12'" >Europe/Rome</xsl:when>
	<xsl:when test="$timezone = '-12'" >Pacific/Midway</xsl:when>
	<xsl:when test="$timezone = '-11'" >Pacific/Midway</xsl:when>
	<xsl:when test="$timezone = '-10'" >Pacific/Honolulu</xsl:when>
	<xsl:when test="$timezone = '-95'" >Pacific/Marquesas</xsl:when>
	<xsl:when test="$timezone = '-9'"  >America/Adak</xsl:when>
	<xsl:when test="$timezone = '-8'"  >America/Nome</xsl:when>
	<xsl:when test="$timezone = '-7'"  >America/Los_Angeles</xsl:when>
	<xsl:when test="$timezone = '-6'"  >America/Messico City</xsl:when>
	<xsl:when test="$timezone = '-5'"  >America/Bogota</xsl:when>
	<xsl:when test="$timezone = '-45'" >America/Caracas</xsl:when>
	<xsl:when test="$timezone = '-4'"  >America/Detroit</xsl:when>
	<xsl:when test="$timezone = '-35'" >America/St_Johns</xsl:when>
	<xsl:when test="$timezone = '-3'"  >America/Sao_Paulo</xsl:when>
	<xsl:when test="$timezone = '-2'"  >Atlantic/South_Georgia</xsl:when>
	<xsl:when test="$timezone = '-1'"  >Atlantic/Azores</xsl:when>
	<xsl:when test="$timezone = '0'"   >Europe/London</xsl:when>
	<xsl:when test="$timezone = '1'"   >Europe/Rome</xsl:when>
	<xsl:when test="$timezone = '2'"   >Europe/Istanbul</xsl:when>
	<xsl:when test="$timezone = '3'"   >Asia/Baghdad</xsl:when>
	<xsl:when test="$timezone = '35'"  >Asia/Tehran</xsl:when>
	<xsl:when test="$timezone = '4'"   >Asia/Muscat</xsl:when>
	<xsl:when test="$timezone = '45'"  >Asia/Kabul</xsl:when>
	<xsl:when test="$timezone = '5'"   >Asia/Karachi</xsl:when>
	<xsl:when test="$timezone = '55'"  >Asia/Colombo</xsl:when>
	<xsl:when test="$timezone = '575'" >Asia/Kathmandu</xsl:when>
	<xsl:when test="$timezone = '6'"   >Asia/Almaty</xsl:when>
	<xsl:when test="$timezone = '65'"  >Asia/Rangoon</xsl:when>
	<xsl:when test="$timezone = '9'"   >Asia/Tokyo</xsl:when>
	<xsl:when test="$timezone = '95'"  >Australia/Adelaide</xsl:when>
	<xsl:when test="$timezone = '10'"  >Pacific/Guam</xsl:when>
	<xsl:when test="$timezone = '105'" >Australia/Lord_Howe</xsl:when>
	<xsl:when test="$timezone = '11'"  >Asia/Magadan</xsl:when>
	<xsl:when test="$timezone = '115'" >Pacific/Norfolk</xsl:when>
	<xsl:when test="$timezone = '12'"  >Pacific/Auckland</xsl:when>
	<xsl:when test="$timezone = '1275'">Pacific/Chatham</xsl:when>
	<xsl:when test="$timezone = '13'"  >Pacific/Tongatapu</xsl:when>
	<xsl:when test="$timezone = '14'"  >Pacific/Kiritimati</xsl:when>
</xsl:choose>
</xsl:template>

<!-- RECURSIVE TEMPLATE, KEEPS CALLING ITSELF UNTIL ALL ITEMS ARE PROCESSED -->
<xsl:template name="toJson">
<xsl:param name="ini"></xsl:param>
<xsl:if test="$ini != ''">
	<xsl:variable name="first">
		<xsl:choose>
			<xsl:when test="contains($ini,'&#10;')"><xsl:copy-of select="substring-before($ini,'&#10;')" /></xsl:when>
			<xsl:otherwise><xsl:copy-of select="$ini" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="remaining" select="substring-after($ini,'&#10;')" />
	<xsl:choose>
		<xsl:when test="substring-before($first,'=') = 'readmore'">"alternative_readmore"</xsl:when>
		<xsl:otherwise>"<xsl:copy-of select="substring-before($first,'=')"/>"</xsl:otherwise>
	</xsl:choose>:"<xsl:choose>
		<xsl:when test="substring-before($first,'=') != 'timezone'"><xsl:copy-of select="substring-after($first,'=')"/></xsl:when>
		<xsl:otherwise><xsl:call-template name="fixTimezone"><xsl:with-param name="timezone" select="substring-after($first,'=')"></xsl:with-param></xsl:call-template></xsl:otherwise>
	</xsl:choose>"<xsl:if test="$remaining">,<xsl:call-template name="toJson"><xsl:with-param name="ini" select="$remaining"></xsl:with-param></xsl:call-template></xsl:if>
</xsl:if>
</xsl:template>

<!-- RECURSIVE TEMPLATE, KEEPS CALLING ITSELF UNTIL ALL ITEMS ARE PROCESSED -->
<xsl:template name="getValue">
<xsl:param name="ini"></xsl:param>
<xsl:param name="field"></xsl:param>
<xsl:if test="$ini != ''">
	<xsl:variable name="first">
		<xsl:choose>
			<xsl:when test="contains($ini,'&#10;')"><xsl:copy-of select="substring-before($ini,'&#10;')" /></xsl:when>
			<xsl:otherwise><xsl:copy-of select="$ini" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="remaining" select="substring-after($ini,'&#10;')" />
	<xsl:choose>
		<xsl:when test="substring-before($first,'=') = $field"><xsl:copy-of select="substring-after($first,'=')"/></xsl:when>
		<xsl:when test="$remaining"><xsl:call-template name="getValue"><xsl:with-param name="ini" select="$remaining"></xsl:with-param><xsl:with-param name="field" select="$field"></xsl:with-param></xsl:call-template></xsl:when>
	</xsl:choose>
</xsl:if>
</xsl:template>

<xsl:template name ="max">
	<xsl:param name ="list" />
	<xsl:choose>
		<xsl:when test ="$list">
			<xsl:variable name ="first" select ="$list[1]" />
			<xsl:variable name ="rest">
				<xsl:call-template name ="max">
					<xsl:with-param name ="list" select ="$list[position() != 1]" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$first &gt; $rest">
					<xsl:value-of select ="$first"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select ="$rest"/>     
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>0</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="htmlspecialchars_decode">
	<xsl:param name="text" />
	<xsl:variable name="text1">
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text" select="$text" />
			<xsl:with-param name="replace" select="'&amp;lt;'" />
			<xsl:with-param name="by" select="'&lt;'" />
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="text2">
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text" select="$text1" />
			<xsl:with-param name="replace" select="'&amp;gt;'" />
			<xsl:with-param name="by" select="'&gt;'" />
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="text3">
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text" select="$text2" />
			<xsl:with-param name="replace" select="'&amp;amp;'" />
			<xsl:with-param name="by" select="'&amp;'" />
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="text4">
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text" select="$text3" />
			<xsl:with-param name="replace" select="'&amp;quot;'" />
			<xsl:with-param name="by" select="'&quot;'" />
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$text4" />
</xsl:template>

<xsl:template name="string-replace-all">
  <xsl:param name="text" />
  <xsl:param name="replace" />
  <xsl:param name="by" />
  <xsl:choose>
    <xsl:when test="contains($text, $replace)">
      <xsl:value-of select="substring-before($text,$replace)" />
      <xsl:value-of select="$by" />
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="substring-after($text,$replace)" />
        <xsl:with-param name="replace" select="$replace" />
        <xsl:with-param name="by" select="$by" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="content">
<content>
	<id><xsl:value-of select="id"/></id>
	<title><xsl:value-of select="title"/></title>
	<alias><xsl:choose>
		<xsl:when test="alias25"><xsl:value-of select="alias25"></xsl:value-of></xsl:when>
		<xsl:otherwise><xsl:call-template name="normalize-alias"><xsl:with-param name="s" select="alias"></xsl:with-param></xsl:call-template></xsl:otherwise>
		</xsl:choose></alias>
	<introtext><xsl:value-of select="introtext"/></introtext>
	<fulltext><xsl:value-of select="fulltext"/></fulltext>
	<state><xsl:choose>
			<xsl:when test="not(state)">1</xsl:when>
			<xsl:when test="state = ''">1</xsl:when>
			<xsl:when test="state = -1">2</xsl:when>
			<xsl:otherwise><xsl:value-of select="state"/></xsl:otherwise>
	</xsl:choose></state>
	<created><xsl:value-of select="created"/></created>
	<created_by_alias><xsl:value-of select="created_by_alias"/></created_by_alias>
	<modified><xsl:value-of select="modified"/></modified>
	<publish_up><xsl:value-of select="publish_up"/></publish_up>
	<publish_down><xsl:value-of select="publish_down"/></publish_down>
	<images><![CDATA[{"image_intro":"","float_intro":"","image_intro_alt":"","image_intro_caption":"","image_fulltext":"","float_fulltext":"","image_fulltext_alt":"","image_fulltext_caption":""}]]></images>
	<urls><![CDATA[{"urla":null,"urlatext":"","targeta":"","urlb":null,"urlbtext":"","targetb":"","urlc":null,"urlctext":"","targetc":""}]]></urls>
	<attribs>{<xsl:call-template name="toJson"><xsl:with-param name="ini" select="attribs"></xsl:with-param></xsl:call-template>}</attribs>
	<version><xsl:value-of select="version"/></version>
	<ordering><xsl:value-of select="ordering"/></ordering>
	<metakey><xsl:value-of select="metakey"/></metakey>
	<metadesc><xsl:value-of select="metadesc"/></metadesc>
	<access><xsl:choose>
			<xsl:when test="not(access)">1</xsl:when>
			<xsl:when test="access = ''">1</xsl:when>
			<xsl:otherwise><xsl:value-of select="access+1"/></xsl:otherwise>
	</xsl:choose></access>
	<hits><xsl:choose>
			<xsl:when test="not(hits)">0</xsl:when>
			<xsl:when test="hits = ''">0</xsl:when>
			<xsl:otherwise><xsl:value-of select="hits"/></xsl:otherwise>
	</xsl:choose></hits>
	<metadata>{<xsl:call-template name="toJson"><xsl:with-param name="ini" select="metadata"></xsl:with-param></xsl:call-template>}</metadata>
	<language><xsl:call-template name="getValue">
	<xsl:with-param name="ini" select="attribs"></xsl:with-param>
	<xsl:with-param name="field">language</xsl:with-param>
	</xsl:call-template></language>
	<xreference></xreference>
	<catid>
		<xsl:choose>
			<xsl:when test="catid25='' and catid=''">uncategorised</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="sectionid25"><xsl:value-of select="sectionid25"/></xsl:when>
					<xsl:otherwise><xsl:call-template name="normalize-alias"><xsl:with-param name="s" select="sectionid"></xsl:with-param></xsl:call-template></xsl:otherwise>
				</xsl:choose>/<xsl:choose>
					<xsl:when test="catid25"><xsl:value-of select="catid25"/></xsl:when>
					<xsl:otherwise><xsl:call-template name="normalize-alias"><xsl:with-param name="s" select="catid"></xsl:with-param></xsl:call-template></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose></catid>
	<created_by><xsl:value-of select="created_by"/></created_by>
	<modified_by><xsl:value-of select="modified_by"/></modified_by>
	<featured><xsl:value-of select="frontpage"/></featured>
	<rating_sum>0</rating_sum>
	<rating_count>0</rating_count>
</content>
</xsl:template>

<xsl:template match="category">
<category>
	<id><xsl:choose>
		<xsl:when test="starts-with(sectionid,'com_')">0</xsl:when>
		<xsl:otherwise><xsl:value-of select="id"/></xsl:otherwise>
	</xsl:choose></id>
	<xsl:variable name="alias"><xsl:choose>
		<xsl:when test="alias25"><xsl:value-of select="alias25"></xsl:value-of></xsl:when>
		<xsl:otherwise><xsl:call-template name="normalize-alias"><xsl:with-param name="s" select="alias"></xsl:with-param></xsl:call-template></xsl:otherwise>
	</xsl:choose></xsl:variable>
	<xsl:variable name="section"><xsl:choose>
		<xsl:when test="sectionid25"><xsl:value-of select="sectionid25"></xsl:value-of></xsl:when>
		<xsl:otherwise><xsl:call-template name="normalize-alias"><xsl:with-param name="s" select="sectionid"></xsl:with-param></xsl:call-template></xsl:otherwise>
	</xsl:choose></xsl:variable>
	<path>
		<xsl:if test="not(starts-with(sectionid,'com_'))"><xsl:value-of select="$section"/>/</xsl:if><xsl:value-of select="$alias"/>
	</path>
	<extension><xsl:choose>
		<xsl:when test="starts-with(sectionid,'com_')"><xsl:value-of select="sectionid"/></xsl:when>
		<xsl:otherwise>com_content</xsl:otherwise>
	</xsl:choose></extension>
	<title><xsl:value-of select="title"/></title>
	<alias><xsl:value-of select="$alias"/></alias>
	<note></note>
	<description><xsl:value-of select="description"/></description>
	<published><xsl:value-of select="published"/></published>
	<access><xsl:choose>
			<xsl:when test="not(access)">1</xsl:when>
			<xsl:when test="access = ''">1</xsl:when>
			<xsl:otherwise><xsl:value-of select="access+1"/></xsl:otherwise>
	</xsl:choose></access>
	<params>{<xsl:call-template name="toJson"><xsl:with-param name="ini" select="params"></xsl:with-param></xsl:call-template>}</params>
	<metadesc></metadesc>
	<metakey></metakey>
	<metadata><![CDATA[{"author":"","robots":""}]]></metadata>
	<created_time></created_time>
	<modified_time></modified_time>
	<hits>0</hits>
	<language><![CDATA[*]]></language>
	<created_user_id></created_user_id>
	<modified_user_id></modified_user_id>
</category>
</xsl:template>

<xsl:template match="section">
<category>
	<xsl:variable name="id" select="id/text()"/>
	<xsl:choose>
		<xsl:when test="count(/j2xml/category/id[text()=$id])=0"><id><xsl:value-of select="id"/></id></xsl:when>
		<xsl:when test="count(/j2xml/content) &gt; 0"><id>0</id></xsl:when>
		<xsl:otherwise>
			<id><xsl:value-of select="$maxcatid + position() + 1"/></id>
			<original_id><xsl:value-of select="id"/></original_id>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:variable name="alias"><xsl:choose>
		<xsl:when test="alias25"><xsl:value-of select="alias25"></xsl:value-of></xsl:when>
		<xsl:otherwise><xsl:call-template name="normalize-alias"><xsl:with-param name="s" select="alias"></xsl:with-param></xsl:call-template></xsl:otherwise>
	</xsl:choose></xsl:variable>
	<path><xsl:value-of select="$alias"/></path>
	<extension><![CDATA[com_content]]></extension>
	<title><xsl:value-of select="title"/></title>
	<alias><xsl:value-of select="$alias"/></alias>
	<note></note>
	<description><xsl:value-of select="description"/></description>
	<published><xsl:value-of select="published"/></published>
	<access><xsl:choose>
			<xsl:when test="not(access)">1</xsl:when>
			<xsl:when test="access = ''">1</xsl:when>
			<xsl:otherwise><xsl:value-of select="access+1"/></xsl:otherwise>
	</xsl:choose></access>
	<params>{<xsl:call-template name="toJson"><xsl:with-param name="ini" select="params"></xsl:with-param></xsl:call-template>}</params>
	<metadesc></metadesc>
	<metakey></metakey>
	<metadata><![CDATA[{"author":"","robots":""}]]></metadata>
	<created_time></created_time>
	<modified_time></modified_time>
	<hits>0</hits>
	<language><![CDATA[*]]></language>
	<created_user_id></created_user_id>
	<modified_user_id></modified_user_id>
</category>
</xsl:template>

<xsl:template match="user">
<user>
	<id><xsl:value-of select="id"/></id>
	<name><xsl:value-of select="name"/></name>
	<username><xsl:value-of select="translate(username, ' \', '--')"/></username>
	<email><xsl:value-of select="email"/></email>
	<password><xsl:value-of select="password"/></password>
	<usertype><![CDATA[deprecated]]></usertype>
	<block><xsl:value-of select="block"/></block>
	<sendEmail><xsl:value-of select="sendEmail"/></sendEmail>
	<registerDate><xsl:value-of select="registerDate"/></registerDate>
	<lastvisitDate><xsl:value-of select="lastvisitDate"/></lastvisitDate>
	<activation><xsl:value-of select="activation"/></activation>
	<params>{<xsl:call-template name="toJson"><xsl:with-param name="ini" select="params"></xsl:with-param></xsl:call-template>}</params>
	<lastResetTime><![CDATA[0000-00-00 00:00:00]]></lastResetTime>
	<resetCount>0</resetCount>
	<group><xsl:choose>
	<!-- 
		<xsl:when test="usertype = 'Administrator' or usertype = 'Author' or usertype = 'Editor' or usertype = 'Manager' or usertype = 'Publisher'"><xsl:value-of select="usertype"/></xsl:when>
		<xsl:when test="usertype = 'Super Administrator'">Super Users</xsl:when>
		<xsl:otherwise>Registered</xsl:otherwise>
	-->
		<xsl:when test="usertype = 'Administrator'">["Public","Manager","Administrator"]</xsl:when>
		<xsl:when test="usertype = 'Author'">["Public","Registered","Author"]</xsl:when>
		<xsl:when test="usertype = 'Editor'">["Public","Registered","Author","Editor"]</xsl:when>
		<xsl:when test="usertype = 'Guest'">["Public","Guest"]</xsl:when>
		<xsl:when test="usertype = 'Manager'">["Public","Manager"]</xsl:when>
		<xsl:when test="usertype = 'Public'">["Public"]</xsl:when>
		<xsl:when test="usertype = 'Publisher'">["Public","Registered","Author","Editor","Publisher"]</xsl:when>
		<xsl:when test="usertype = 'Registered'">["Public","Registered"]</xsl:when>
		<xsl:when test="usertype = 'Super Administrator'">["Public","Super Users"]</xsl:when>
		<xsl:otherwise>["Public","Registered"]</xsl:otherwise>
	</xsl:choose></group>
</user>
</xsl:template>

<xsl:template match="img">
	<xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="weblink">
<weblink>
	<id><xsl:value-of select="id"/></id>
	<catid><xsl:value-of select="catid"/></catid>
	<title><xsl:value-of select="title"/></title>
	<alias><xsl:call-template name="normalize-alias"><xsl:with-param name="s" select="alias"></xsl:with-param></xsl:call-template></alias>
	<url><xsl:value-of select="url"/></url>
	<description><xsl:value-of select="description"/></description>
	<hits><xsl:value-of select="hits"/></hits>
	<state><xsl:value-of select="published"/></state>
	<ordering><xsl:value-of select="ordering"/></ordering>
	<access>1</access>
	<params>{<xsl:call-template name="toJson"><xsl:with-param name="ini" select="params"></xsl:with-param></xsl:call-template>}</params>
	<language><![CDATA[*]]></language>
	<created><xsl:value-of select="date"/></created>
	<created_by_alias></created_by_alias>
	<modified><![CDATA[0000-00-00 00:00:00]]></modified>
	<metakey></metakey>
	<metadesc></metadesc>
	<metadata><![CDATA[{"robots":"","rights":""}]]></metadata>
	<featured>0</featured>
	<xreference></xreference>
	<publish_up><![CDATA[0000-00-00 00:00:00]]></publish_up>
	<publish_down><![CDATA[0000-00-00 00:00:00]]></publish_down>
	<version></version>
	<images></images>
</weblink>
</xsl:template>

<xsl:template name="left-trim">
	<xsl:param name="s" />
	<xsl:choose>
		<xsl:when test="substring($s, 1, 1) = ''">
			<xsl:value-of select="$s"/>
		</xsl:when>
		<xsl:when test="normalize-space(substring($s, 1, 1)) = ''">
			<xsl:call-template name="left-trim">
				<xsl:with-param name="s" select="substring($s, 2)" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$s" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="right-trim">
	<xsl:param name="s" />
	<xsl:choose>
		<xsl:when test="substring($s, 1, 1) = ''">
			<xsl:value-of select="$s"/>
		</xsl:when>
		<xsl:when test="normalize-space(substring($s, string-length($s))) = ''">
			<xsl:call-template name="right-trim">
				<xsl:with-param name="s" select="substring($s, 1, string-length($s) - 1)" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$s" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="trim">
	<xsl:param name="s" />
	<xsl:call-template name="right-trim">
		<xsl:with-param name="s">
			<xsl:call-template name="left-trim">
				<xsl:with-param name="s" select="$s" />
			</xsl:call-template>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="normalize-alias">
	<xsl:param name="s" />
	<xsl:param name="a">
		<xsl:call-template name="trim">
			<xsl:with-param name="s" select="translate($s, '-', ' ')" />
		</xsl:call-template>
	</xsl:param>
	<xsl:value-of select="translate($a, ' ', '-')" />	
</xsl:template>

</xsl:stylesheet>
