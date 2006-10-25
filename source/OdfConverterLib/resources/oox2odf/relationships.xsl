<?xml version="1.0" encoding="UTF-8"?>
<!--<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:uri="http://schemas.openxmlformats.org/drawingml/2006/picture"
  xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture" version="1.0">-->
  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
    xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
    xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
    xmlns:uri="http://schemas.openxmlformats.org/drawingml/2006/picture"
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:pzip="urn:cleverage:xmlns:post-processings:zip"
    xmlns="http://schemas.openxmlformats.org/package/2006/relationships"
    exclude-result-prefixes="w">
    
  <xsl:template name="CopyPictures">
    <xsl:param name="document"/>


        <xsl:if test="name(document(concat('word/',$document))//node()) = 'w:hdr'">
          <xsl:for-each
            select="document(concat('word/',$document))//w:hdr/w:p/w:r/w:drawing/wp:inline|document(concat('word/',$document))//w:hdr/w:p/w:r/w:drawing/wp:anchor">
            <xsl:variable name="pziptarget">
              <xsl:value-of select="wp:docPr/@name"/>
            </xsl:variable>
            <xsl:variable name="id">
              <xsl:value-of select="a:graphic/a:graphicData/pic:pic/pic:blipFill/a:blip/@r:embed"/>
            </xsl:variable>
            <xsl:for-each
              select="document(concat('word/_rels/',$document,'.rels'))//node()[name() = 'Relationship']">
              <xsl:if test="./@Id=$id">
                <xsl:variable name="pzipsource">
                  <xsl:value-of select="./@Target"/>
                </xsl:variable>
                <pzip:copy pzip:source="word/{$pzipsource}" pzip:target="pictures/{$pziptarget}"/>
                
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:if>
    
        <xsl:if test="name(document(concat('word/',$document))//node()) = 'w:document'">
        
        <!--  Copy Pictures Files to the picture catalog -->

        <xsl:variable name="id">
          <xsl:value-of select="a:graphic/a:graphicData/pic:pic/pic:blipFill/a:blip/@r:embed"/>
        </xsl:variable>
        <xsl:if test="document(concat('word/_rels/',$document,'.rels'))">
          <xsl:for-each
            select="document(concat('word/_rels/',$document,'.rels'))//node()[name() = 'Relationship']">

            <xsl:if test="./@Id=$id">
              <xsl:variable name="pzipsource">
                <xsl:value-of select="./@Target"/>
              </xsl:variable>
              <xsl:variable name="pziptarget">
                <xsl:value-of select="substring-after($pzipsource,'/')"/>
              </xsl:variable>
           <!--   <xsl:value-of select="concat($pzipsource,'aaa')"/>-->
              <pzip:copy pzip:source="word/{$pzipsource}" pzip:target="pictures/{$pziptarget}"/>
             
            </xsl:if>

          </xsl:for-each>
        </xsl:if>
          </xsl:if>
  </xsl:template>


</xsl:stylesheet>
