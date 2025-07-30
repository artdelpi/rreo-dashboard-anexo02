# Painel RREO – Saúde (Função 10) e Previdência Social (Função 9)

Este repositório disponibiliza dois **dashboards interativos em Power BI** para análise das **despesas liquidadas** dos Governos Estaduais, obtidas diretamente da **API do Tesouro Transparente (SICONFI)** por meio do endpoint `rreo` (Anexo 2).

- **Painel do Financiamento Estadual da Saúde** (Função 10)  
- **Painel do Financiamento Estadual da Previdência Social** (Função 9)

---

## Dashboards

<p align="center">
  <img src="docs/images/demo_f09.png" alt="Visão geral do dashboard da Previdência Social" width="600px">
  <br>
  <em>Figura 1 – Painel interativo em Power BI com dados de despesas liquidadas com previdência social por estado.</em>
</p>

<p align="center">
  <img src="docs/images/demo_f10.png" alt="Visão geral do dashboard da Saúde" width="600px">
  <br>
  <em>Figura 1 – Painel interativo em Power BI com dados de despesas liquidadas com saúde por estado.</em>
</p>

---

## Escopo dos Dados

- O painel considera apenas as **despesas liquidadas**, com base no atributo: `coluna = "DESPESAS LIQUIDADAS NO BIMESTRE"`.
- **Despesas intra-orçamentárias foram excluídas.**
- Foram filtradas as **despesas da Função 09 - Previdência social** e as seguintes subfunções:
  - **271 - Previdência Básica**
  - **272 - Previdência do Regime Estatutário**
  - **273 - Previdência Complementar**
  - **274 - Previdência Especial**
  - **FU09 – Demais Subfunções**
  - **FU09 – Administração Geral**

- Também foram filtradas as **despesas da Função 10 - Saúde** e as seguintes subfunções:
  - **301 - Atenção Básica**
  - **302 - Assistência Hospitalar e Ambulatorial**
  - **303 - Suporte Profilático e Terapêutico**
  - **304 - Vigilância Sanitária**
  - **305 - Vigilância Epidemiológica**
  - **306 - Alimentação e Nutrição**
  - **FU10 – Demais Subfunções**
  - **FU10 – Administração Geral**

---

## Coleta de Dados

### **Despesas Públicas (SICONFI)**

Os dashboards são alimentados por um **único arquivo bruto extraído via script R (`DoFile.R`)**, que coleta todas as informações do **Anexo 2 do endpoint `rreo` (API Tesouro Nacional – RREO)**.  

- **Endpoint:** `rreo`  
- **Parâmetros utilizados na coleta:**
  - **`id_ente`**: Código IBGE do estado (ex.: 33 = Rio de Janeiro)
  - **`an_exercicio`**: Anos de 2015 até o atual
  - **`nr_periodo`**: Bimestres (1 a 6)
  - **`co_tipo_demonstrativo`**: `RREO` (Relatório Resumido da Execução Orçamentária)
  - **`no_anexo`**: `RREO-Anexo 02`

> O script **não aplica filtros por função ou subfunção na coleta**, fazendo com que todas as informações do anexo sejam capturadas. Os filtros temáticos (por função, subfunção e natureza da despesa) são aplicados **diretamente no Power BI**, dentro dos próprios painéis.

### **Script utilizado: `DoFile.R`**

O script percorre todos os anos, bimestres e estados para montar uma base consolidada de registros brutos do Anexo 2 do RREO.

## Estrutura do Projeto

```text
SICONFI-API-POWERBI/
│
├── dashboards/                        # arquivos .pbix dos painéis em Power BI
│   ├── Dashboard de Previdência Social – Execução Orçamentária.pbix
│   └── Dashboard de Saúde – Execução Orçamentária.pbix
│
├── data/                              # armazenamento de dados brutos
│   └── raw/                           # dump bruto da API
│       └── siconfi_rreo_bruto_2015_2025.zip
│
├── docs/                              # documentação e recursos visuais
│   ├── images/                        # capturas de tela dos dashboards
│   │   ├── demo_f09.png
│   │   └── demo_f10.png
│   └── data_dictionary.md             # dicionário de dados do projeto
│
├── src/                               # scripts de extração de dados
│   └── DoFile.R                       # coleta registros brutos do RREO Anexo 2
│
├── .gitignore                         
└── README.md                          
```
