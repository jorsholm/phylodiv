library(tidyverse)

taxa <- readRDS("data/raw_data/otu_taxonomy_reliable.rds")

# Build taxonomy file 
rownames_to_column(taxa, var = "otu") |> 
  filter(phylum == "Arthropoda") |> 
  filter(!str_detect(family, "pseudo")) |> 
  mutate(taxonomy = pmap_chr(list(phylum, class, order, family), 
                             ~paste(c(..1, ..2, ..3, ..4), collapse = ";"))) |> 
  select(otu, taxonomy) |> 
  write_tsv(file = "data/phylo/taxonomyfile.tsv", col_names = F)

# Filter sequences 
otu_keep <- 
  rownames_to_column(taxa, var = "otu") |> 
  filter(phylum == "Arthropoda") |> 
  pull(otu)

aln <- ape::read.FASTA("data/aln.fasta")

aln_red <- aln[which(names(aln) %in% otu_keep)]

ape::write.FASTA(aln_red, file = "data/aln_red.fasta")
