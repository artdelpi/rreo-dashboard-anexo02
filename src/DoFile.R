# ============================================================
# Script: DoFile.R
# Objetivo: Coletar dados da API RREO (SICONFI) Anexo 02
#           para todos os entes federativos,
#           de 2015 até o ano atual, 
#           consolidando por bimestre.
# Fonte do mapeamento de funções:
# Manual Técnico de Orçamento – MTO 2026 (SOF)
# https://www1.siop.planejamento.gov.br/mto/doku.php/mto2026
# ============================================================

library(httr)
library(jsonlite)
library(dplyr)

ufs <- c(
  12, 27, 13, 16, 29, 23, 53, 32, 52, 21, 31, 50,
  51, 15, 25, 26, 22, 41, 33, 24, 11, 14, 43, 42,
  28, 35, 17
)
anos <- 2015:2025
bimestres <- 1:6
tipo_demonstrativo <- "RREO"
anexo <- "RREO-Anexo 02"

# DataFrame para armazenar todos os registros brutos
registros_brutos <- data.frame()

for (ano in anos) {
  for (bimestre in bimestres) {
    for (id_ente in ufs) {
      cat("Ano:", ano, "| Bimestre:", bimestre, "| UF:", id_ente, "\n")
      url <- paste0(
        "https://apidatalake.tesouro.gov.br/ords/siconfi/tt/rreo?",
        "an_exercicio=", ano,
        "&nr_periodo=", bimestre,
        "&co_tipo_demonstrativo=", tipo_demonstrativo,
        "&id_ente=", id_ente,
        "&no_anexo=", URLencode(anexo)
      )
      res <- GET(url)
      if (status_code(res) != 200) next
      dados <- fromJSON(content(res, as = "text", encoding = "UTF-8"))
      if (length(dados$items) == 0) next
      df <- as.data.frame(dados$items)
      # Adiciona colunas de contexto
      df$ano <- ano
      df$bimestre <- bimestre
      df$cod_ibge <- id_ente
      registros_brutos <- rbind(registros_brutos, df)
      Sys.sleep(1)
    }
  }
}

registros_brutos

#write.csv(registros_brutos, ~/siconfi_rreo_bruto_2015_2025.csv", row.names = FALSE)
