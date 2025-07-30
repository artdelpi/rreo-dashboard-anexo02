# Data Dictionary

Este documento descreve as colunas, descrições e fontes usadas no projeto.

---

## 1. Dataset: `siconfi_rreo_bruto_2015_2025.csv`

**Fonte:** API SICONFI – Relatório Resumido da Execução Orçamentária (RREO) – Anexo 02  
**Descrição:** Dump bruto de todos os registros do Anexo 02 do RREO, coletados pelo script `DoFile.R` para os anos de 2015 até o ano atual, para todos os entes federativos e bimestres. Sem filtragem por função ou subfunção, os filtros são aplicados no painel do Power BI.

**Colunas:**
- `exercicio`  
  Ano de referência (2015 até o ano atual).  
- `demonstrativo`  
  Tipo de relatório, sempre `"RREO"`.  
- `periodo`  
  Número do período no ano (bimestre: 1 a 6).  
- `periodicidade`  
  Código de periodicidade, normalmente `"B"` (bimestral).  
- `instituicao`  
  Descrição do ente (ex.: `"Governo do Estado do Rio de Janeiro"`).  
- `cod_ibge`  
  Código IBGE do ente federativo (ex.: 33 = RJ).  
- `uf`  
  Sigla da unidade federativa (ex.: `"RJ"`).  
- `populacao`  
  População estimada do ente, segundo o RREO (quando disponível).  
- `anexo`  
  Identificação do anexo, sempre `"RREO-Anexo 02"`.  
- `esfera`  
  Esfera de governo (`"E"` = Estadual).  
- `rotulo`  
  Rótulo da conta (ex.: `"Total das Despesas Exceto Intra‑Orçamentárias"`).  
- `coluna`  
  Descrição da métrica (ex.: `"DESPESAS LIQUIDADAS NO BIMESTRE"`).  
- `cod_conta`  
  Código interno da conta/subfunção (ex.: `"RREO2TotalDespesasIntra"`).  
- `conta`  
  Nome da função ou subfunção orçamentária (ex.: `"FU10 - Administração Geral"`).  
- `valor`  
  Valor da despesa, em reais, referente ao bimestre.  
- `bimestre`  
  Coluna criada pelo script R para facilitar o agrupamento (duplicata de `periodo`).

---

> **Observação:**  
> - Esse arquivo é importado no Power BI como fonte única.  
> - Todos os filtros (função, subfunção, natureza da despesa, ano, UF etc.) são aplicados **diretamente nos relatórios**.  
> - Para reproduzir ou atualizar os dados, execute `src/DoFile.R` e substitua o CSV em `data/raw/`.  
