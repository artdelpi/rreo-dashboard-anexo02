# ============================================================
# Script: DoFile_RREO_Anexo2.R
# Objetivo: Baixar e consolidar dados do RREO Anexo 2 (Siconfi)
#           de todos os estados (2018 até o ano atual), 
#           por bimestre, usando a SICONFI API.
# Fonte do mapeamento de funções:
# Manual Técnico de Orçamento – MTO 2026 (SOF)
# https://www1.siop.planejamento.gov.br/mto/doku.php/mto2026
# ============================================================

library(dplyr)
library(httr)
library(jsonlite)

BASE_URL <- "https://apidatalake.tesouro.gov.br/ords/siconfi/tt//rreo"
UF_CODIGOS <- c(
  12, 27, 13, 16, 29, 23, 53, 32, 52, 21, 31, 50,
  51, 15, 25, 26, 22, 41, 33, 24, 11, 14, 43, 42,
  28, 35, 17
)
TIPO_DEMONSTRATIVO <- "RREO"
ANEXO <- "RREO-Anexo 02"
BIMESTRES <- 1:6
anos <- 2015:as.integer(format(Sys.Date(), "%Y"))

# Lista para acumular os data frames de cada requisição à API
df_list <- list()

for (ano in anos) {
  for (bimestre in BIMESTRES) {
    for (uf in UF_CODIGOS) {
      cat("Ano:", ano, "| Bimestre:", bimestre, "| UF:", uf, "\n")
      
      # Monta parâmetros da query para cada chamada
      query_params <- list(
        an_exercicio = ano,
        nr_periodo = bimestre,
        co_tipo_demonstrativo = TIPO_DEMONSTRATIVO,
        no_anexo = ANEXO,
        co_esfera = "E",
        id_ente = uf
      )
      
      # Faz requisição à API para o ente/ano/bimestre
      ans <- GET(url = BASE_URL, query = query_params)
      if (status_code(ans) != 200) next
      
      # Faz o parse do payload JSON
      dados <- fromJSON(content(ans, as = "text", encoding = "UTF-8"))
      if (length(dados$items) == 0) next
      
      # Força dados$items a ser um data frame
      df <- as.data.frame(dados$items)
      
      # Força valor a ser numérico
      df$valor <- as.numeric(df$valor)
      
      # Mantém somente colunas relevantes
      df <- df %>% 
        select(exercicio, periodo, uf, 
               rotulo, coluna, conta, valor)
      
      # Adiciona o data frame à lista de resultados
      df_list[[length(df_list)+1]] <- df 
      
      # Respeita limite da API (1 req/s)
      Sys.sleep(1)
    }
  }
}

# Monta data frame resultante
df_rreo_anexo2 <- bind_rows(df_list)

# Salva o resultado em CSV
# write.csv(df_rreo_anexo2, "~/rreo_anexo2.csv", row.names = FALSE)
