<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" /> -->
    <xsl:template match="tei:teiHeader"/>

    <xsl:template match="tei:body">
        <div class="row">
            <div class="col-3"><br/><br/><br/><br/><br/>
                <xsl:for-each select="//tei:add[@place = 'marginleft']">
                    <xsl:choose>
                        <xsl:when test="tei:del[@type='crossedOut']">
                            <span>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="attribute::hand"/> marginAdd
                                </xsl:attribute>
                                <span class="deletion">
                                    <xsl:value-of select="tei:del"/>
                                </span>
                            </span><br/>
                        </xsl:when>
                        <xsl:otherwise>
                            <span>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="attribute::hand"/> marginAdd
                                </xsl:attribute>
                                <xsl:value-of select="."/><br/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each> 
            </div>
            <div class="col-9">
                <div class="transcription">
                    <xsl:apply-templates select="//tei:div"/>
                </div>
            </div>
        </div> 
    </xsl:template>

    <xsl:template match="tei:add[@place='marginleft']" />

    <xsl:template match="tei:div">
        <div class="#MWS">
            <xsl:apply-templates select="node()[not(self::tei:add[@place='marginleft'])]" />
        </div>
    </xsl:template>

    
    <xsl:template match="tei:p">
        <p>
        <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:i">
        <span class="italic">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:head">
        <h4 class="heading">
            <xsl:apply-templates/>
        </h4>
    </xsl:template>
    
    <xsl:template match="tei:del">
        <del>
            <xsl:attribute name="class">
                <xsl:value-of select="@hand"/>
                <xsl:text> deletion</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </del>
    </xsl:template>

    <!--<xsl:template match="tei:del">
        <span>
            <xsl:attribute name="class">
                <xsl:text>deletion </xsl:text>
                <xsl:value-of select="@hand"/>
                <xsl:if test="@type='crossedOut'">
                    <xsl:text> crossedOut</xsl:text>
                </xsl:if>
                <xsl:if test="@rend">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@rend"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>-->

    <xsl:template match="tei:add[@place = 'supralinear']">
        <span>
            <xsl:attribute name="class">
                <xsl:text>supraAdd </xsl:text>
                <xsl:value-of select="@hand"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:add[@place = 'inline']">
        <span>
            <xsl:attribute name="class">
                <xsl:text> italic-MWS </xsl:text>
                <xsl:value-of select="@hand"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='sup']">
        <span class="supraAdd">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'circled']">
        <span class="numberCircle">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <span class="line-break">
            <br/>
        </span>
    </xsl:template>

    <xsl:template match="tei:metamark[@function='pagenumber']">
    <span class="pagenumber">
        <xsl:apply-templates/>
    </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'u']">
        <span class="under">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:del[@type='crossedOut']">
        <del>
            <xsl:attribute name="class">
                <xsl:value-of select="@hand"/>
                <xsl:text> deletion</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </del>
    </xsl:template>


    <xsl:template match="tei:center">
        <span class="centered-text">
                <xsl:apply-templates/>
        </span>
    </xsl:template>


    <xsl:template match="tei:indent">
        <span class="indent">
                <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:extraindent">
        <span class="extraindent">
                <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="metamark[@function='insert']">
        <span style="position: relative; font-size: 0.8em; vertical-align: baseline;">
            <span style="position: absolute; bottom: -8px; left: 0; color: black;">^</span>
        </span>
    </xsl:template>

    <xsl:template match="tei:list">
        <span class="list">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:item">
        <span class="item">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    
    <xsl:template match="tei:item[@rend = 'right']">
        <span class="item-right">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- <xsl:template match="metamark[@function='insert']">
        <span style="metamark">
             <xsl:apply-templates/>
         </span>
    </xsl:template> -->

    
    <!-- add additional templates below, for example to transform the tei:lb in <br/> empty elements, tei:hi[@rend = 'sup'] in <sup> elements, the underlined text, additions with the attribute "overwritten" etc. -->

    
</xsl:stylesheet>
