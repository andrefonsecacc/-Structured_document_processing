<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" encoding="UTF-8" />

	<xsl:key name="Personagem" match="personagem" use="@id" />
	<xsl:template match="guiao">
		<html>
			<head>
				<title>Trabalho 2 - PDE</title>
				<!-- Verificação do corpo a ver se esta bem construido -->
				<xsl:variable name="nTemp" select="count(/cenas/temporada)" />
				<xsl:variable name="nEpi" select="count(/cenas/episodio)" />
				<xsl:variable name="nPartes" select="count(/cenas/partes)" />
				<xsl:variable name="nCena" select="count(/cenas/cena)" />

				<!-- tenho que mudar esta porra o teste ta mal feito mas a intençao ta 
					la sobe leixoes!!! -->
				<xsl:if test="$nTemp > 0 and $nEpi > 0 and $nPartes > 0 and $nCena > 0 ">
					<xsl:message terminate="no">
						Erro: Corpo do guiao mal construido
					</xsl:message>
				</xsl:if>
				<link rel="stylesheet" type="text/css" href="trab2.css" />
				
			</head>
			<body>
				<xsl:apply-templates select="cabeçalho" />
				<xsl:apply-templates select="cenas" />
			</body>
		</html>
	</xsl:template>

	<!--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% outras templates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->

	<!-- folha de rosto -->
	<xsl:template match="cabeçalho">

		<div id="cabecalho">
			<!-- titulo do guiao -->
			<h2>
				<xsl:value-of select="titulo" />
			</h2>

			<!-- dataPublicaçao (mudar isto) -->
			<div id="data">
				<p>
					<b>Dia: </b>
					<xsl:value-of select="dataPublicaçao/dia" />
				</p>
				<p>
					<b>Mes: </b>
					<xsl:value-of select="dataPublicaçao/mes" />
				</p>
				<p>
					<b>Ano: </b>
					<xsl:value-of select="dataPublicaçao/ano" />
				</p>
			</div>

			<!-- Autores -->
			<div id="autores">
				<p>Autor/es</p>
				<xsl:apply-templates select="autor" />
			</div>

			<!-- testar se sinopse existe , se existir chamar o template de tratamente 
				pra este caso -->
			<xsl:if test="sinopse">
				<xsl:apply-templates select="sinopse" />
			</xsl:if>

			<!-- testar se personagens existe, se existir chamar a template de tratamente 
				pra este caso -->
			<xsl:if test="personagens">
				<p>Tabela de personagem/ens</p>
				<xsl:apply-templates select="personagens" />
			</xsl:if>


		</div>
	</xsl:template>

	<!-- template para autor, cria lista de autor/es -->
	<xsl:template match="autor">
		<xsl:for-each select=".">
			<ul>
				<li>
					<xsl:value-of select="." />
				</li>
			</ul>
		</xsl:for-each>
	</xsl:template>

	<!-- template para sinopse -->
	<xsl:template match="sinopse">
		<div id="sinopse">
			<p>
				<xsl:value-of select="." />
			</p>
		</div>
	</xsl:template>

	<!-- template para personagens cria tabela com as personagens -->
	<xsl:template match="personagens">
		<div id="personagens">
			<table style="width:100%">
				<tr>
					<th>Nome</th>
					<th>Descriçao</th>
				</tr>

				<xsl:for-each select="personagem">
					<tr>
						<td>
							<xsl:value-of select="./nome" />
						</td>
						<td>
							<xsl:value-of select="./descriçao" />
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</div>
	</xsl:template>

	<!-- template para cenas (tabela de conteudos) -->
	<xsl:template match="cenas">

		<h4>Tabela de conteudos</h4>
		<div id="navegacao">
			<xsl:if test="temporada">
				<xsl:apply-templates select="temporada" mode="indice" />
			</xsl:if>

			<xsl:if test="episodio">
				<xsl:apply-templates select="episodio" mode="indice" />
			</xsl:if>

			<xsl:if test="partes">
				<xsl:apply-templates select="partes" mode="indice" />
			</xsl:if>

			<xsl:if test="cena">
				<xsl:apply-templates select="cena" mode="indice" />
			</xsl:if>
		</div>


		<div id="conteudo">

			<xsl:if test="temporada">
				<xsl:apply-templates select="temporada" mode="conteudo" />
			</xsl:if>
			<br></br>
			<xsl:if test="episodio">
				<xsl:apply-templates select="episodio" mode="conteudo" />
			</xsl:if>
			<br></br>
			<xsl:if test="partes">
				<xsl:apply-templates select="partes" mode="conteudo" />
			</xsl:if>
			<br></br>
			<xsl:if test="cena">
				<xsl:apply-templates select="partes" mode="conteudo" />
			</xsl:if>

		</div>


	</xsl:template>




	<!-- template para temporada (tabela de conteudos) -->
	<xsl:template match="temporada" mode="indice">
		<LI>
			<A HREF="#{generate-id()}">
				<xsl:number format="1" />
				. Temporada
				-
				<xsl:value-of select="titulo" />
			</A>
			<ul>
				<xsl:apply-templates select="episodio" mode="indice" />
			</ul>
		</LI>
	</xsl:template>

	<!-- template para episodios (tabela de conteudos) -->
	<xsl:template match="episodio" mode="indice">
		<LI>
			<A href="#{generate-id()}">
				<xsl:number format="1." />
				.Episodio -
				<xsl:value-of select="titulo" />
			</A>
			<ul>
				<xsl:apply-templates select="cena" mode="indice" />
			</ul>
		</LI>
	</xsl:template>

	<!-- template para partes (tabela de conteudos) -->
	<xsl:template match="partes" mode="indice">
		<LI>
			<A href="#{generate-id()}">
				<xsl:number format="1." />
				Parte -
				<xsl:value-of select="titulo" />
			</A>
			<ul>
				<xsl:apply-templates select="cena" mode="indice" />
			</ul>
		</LI>
	</xsl:template>

	<!-- template para cena (tabela de conteudos) -->
	<xsl:template match="cena" mode="indice">
		<LI>
			<A href="#{generate-id()}">
				<xsl:number format="1." />
				Cena -
				<xsl:value-of select="@contexto" />
			</A>
		</LI>
	</xsl:template>



	<xsl:template match="temporda" mode="conteudo">
		<xsl:for-each select=".">
			<div id="temporada">
				<h2>
					<a name="{generate-id()}">
						<xsl:value-of select="titulo" />
					</a>
				</h2>
				<!-- testar se personagens existe, se existir chamar a template de tratamente 
					pra este caso -->
				<xsl:if test="personagens">
					<p>Tabela de personagem/ens</p>
					<xsl:apply-templates select="personagens" />
				</xsl:if>
				<xsl:if test="sinopse">
					<xsl:apply-templates select="sinopse" />
				</xsl:if>
				<xsl:apply-templates select="episodio" mode="conteudo" />
			</div>
		</xsl:for-each>
	</xsl:template>


	<xsl:template match="episodio" mode="conteudo">
		<xsl:for-each select=".">
			<div id="episodio">
				<h2>
					<a name="{generate-id()}">
						<xsl:value-of select="titulo" />
					</a>
				</h2>
				<!-- testar se personagens existe, se existir chamar a template de tratamente 
					pra este caso -->
				<xsl:if test="personagens">
					<p>Tabela de personagem/ens</p>
					<xsl:apply-templates select="personagens" />
				</xsl:if>
				<xsl:if test="sinopse">
					<xsl:apply-templates select="sinopse" />
				</xsl:if>
				<xsl:apply-templates select="cena" mode="conteudo" />
			</div>
		</xsl:for-each>
	</xsl:template>


	<xsl:template match="partes" mode="conteudo">
		<xsl:for-each select=".">
			<div id="partes">
				<h2>
					<a name="{generate-id()}">
						<xsl:value-of select="titulo" />
					</a>
				</h2>
				<!-- testar se personagens existe, se existir chamar a template de tratamente 
					pra este caso -->
				<xsl:if test="personagens">
					<p>Tabela de personagem/ens</p>
					<xsl:apply-templates select="personagens" />
				</xsl:if>
				<xsl:if test="sinopse">
					<xsl:apply-templates select="sinopse" />
				</xsl:if>
				<xsl:apply-templates select="cena" mode="conteudo" />
			</div>
		</xsl:for-each>
	</xsl:template>


	<!-- Template para cena -->
	<xsl:template match="cena" mode="conteudo">
		
		<xsl:for-each select=".">
			<div id="cena">
				<h2>
					<a name="{generate-id()}">
						<xsl:value-of select="@contexto" />
					</a>
				</h2>
					<p>Lista de conteudos da cena</p>
			<div id="listaPersonagens">
				<xsl:for-each select="fala">
					<ul>
						<li>
							<xsl:value-of select="@Personagem" />
						</li>
					</ul>
				</xsl:for-each>

			</div>
			<div id="listaAderecos">
				<xsl:for-each select="adereço">
					<ul>
						<li>
							<xsl:value-of select="." />
						</li>
					</ul>
				</xsl:for-each>
			</div>
				<xsl:apply-templates select="fala" />
				<xsl:apply-templates select="refere" />
				<xsl:apply-templates select="endereço" />
			</div>
		</xsl:for-each>
	</xsl:template>

	<!-- nao faço ideia do que estou a fazer pra aqui -->
	<xsl:template match="fala">
		<p id="pers">
			<xsl:value-of select="@Personagem" />
			:
		</p>
		<p>
			<xsl:value-of select="text()" />
			<xsl:if test="comentario">
				<xsl:apply-templates select="comentario" />
			</xsl:if>
		</p>

	</xsl:template>

	<xsl:template match="comentario">
		<i>
			(
			<xsl:value-of select="." />
			)
		</i>
	</xsl:template>

	<xsl:template match="refere">
		<p class="upperCase">
			Referencia:
			<xsl:value-of select="@Personagem" />
		</p>
	</xsl:template>

	<xsl:template match="endereço">
		<p>
			<b>
				<xsl:value-of select="." />
			</b>
		</p>
	</xsl:template>



</xsl:stylesheet>