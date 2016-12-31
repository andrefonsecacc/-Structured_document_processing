<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:foaf="http://xmlns.com/foaf/spec/" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:rep="http://www.alunos.dcc.fc.up.pt/~up201006344/">

	<xsl:template match="guiao">
		<rdf:RDF>
			<rdf:Description rdf:about="http://www.example.com/xml">

				<xsl:apply-templates />

			</rdf:Description>
		</rdf:RDF>
	</xsl:template>

	<xsl:template match="cabeçalho">
		<dc:title>
			<xsl:value-of select="titulo" />
		</dc:title>
		<dc:date>
			<xsl:value-of select="dataPublicaçao/dia" />-<xsl:value-of select="dataPublicaçao/mes" />-<xsl:value-of select="dataPublicaçao/ano" />
		</dc:date>

		<xsl:apply-templates select="autor" />
		<rep:characters>
			<xsl:if test="personagens">
				<xsl:apply-templates select="personagens" />
			</xsl:if>
		</rep:characters>

		<xsl:if test="sinopse">
			<xsl:apply-templates select="sinopse" />
		</xsl:if>

	</xsl:template>

	<xsl:template match="autor">
		<xsl:for-each select=".">
			<dc:creator>
				<xsl:value-of select="." />
			</dc:creator>
		</xsl:for-each>
	</xsl:template>
	
<xsl:template match="personagens">
		<rdf:Bag>

				<xsl:for-each select="personagem">
					<foaf:name>
						<xsl:value-of select="./nome" />
					</foaf:name>
					<dc:description>
						<xsl:value-of select="./descriçao" />
					</dc:description>
				</xsl:for-each>
		
		</rdf:Bag>
	</xsl:template>

	<xsl:template match="sinopse">
		<dc:description>
			<xsl:value-of select="." />
		</dc:description>
	</xsl:template>



	<xsl:template match="cenas">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="temporada">
		<rep:Temporada>
			<rdfs:Class rdf:about="temporada({@ID})">
				<rdfs:subClassOf rdf:resource="guiao" />
				<dc:title>
					<xsl:value-of select="titulo" />
				</dc:title>
				<xsl:apply-templates select="episodio" />
				<xsl:apply-templates select="partes" />
				<xsl:apply-templates select="cena" />
			</rdfs:Class>
		</rep:Temporada>
	</xsl:template>

	<xsl:template match="episodio">
		<rep:episodio>
			<rdfs:Class rdf:about="episodio({@ID})">
				<rdfs:subClassOf rdf:resource="temporada" />
				<dc:title>
					<xsl:value-of select="titulo" />
				</dc:title>
				<xsl:apply-templates select="cena" />
			</rdfs:Class>
		</rep:episodio>
	</xsl:template>

	<xsl:template match="partes">
		<rep:partes>
			<rdfs:Class rdf:about="partes({@ID})">
				<rdfs:subClassOf rdf:resource="guiao" />
				<dc:title>
					<xsl:value-of select="titulo" />
				</dc:title>
				<xsl:apply-templates select="cena" />
			</rdfs:Class>
		</rep:partes>
	</xsl:template>

	<xsl:template match="cena">
			<foaf:name>
				<xsl:value-of select="@contexto" />
			</foaf:name>
		
	</xsl:template>

</xsl:stylesheet>