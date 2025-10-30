# Pré Projeto de pesquisa ou Projeto básico

Ambos contendo os seguintes elementos:

- I – Introdução
- II – Revisão teórica
- III – Justificativa
- IV – Hipóteses, se for o caso
- V – Objetivo geral e objetivos específicos
- VI – Metodologia
- VII – Resultados esperados
- VIII – Cronograma de trabalho

## Art. 9º - O relatório técnico contendo a documentação completa do projeto, deve ser: 

- Redigido com linguagem técnica e estruturado conforme padrões profissionais da Engenharia. 
- (i) Introdução e objetivos do projeto;
- (ii) Requisitos funcionais e não funcionais;
- (iii) Modelagens (funcional, estática, dinâmica);
- (iv) Estratégias de implementação;
- (v) Procedimentos de testes e validação;
- (vi) Resultados e considerações finais;
- (vii) Referências e anexos técnicos (códigos, esquemas, diagramas, etc.). Os modelos utilizados serão definidos pelo orientador, considerando o objeto do projeto.
- (v) Procedimentos de testes e validação;
- (vi) Resultados e considerações finais;
- (vii) Referências e anexos técnicos (códigos, esquemas, diagramas, etc.). 
- Os modelos utilizados serão definidos pelo orientador, considerando o objeto do projeto.

# Como gerar o site e o PDF (MkDocs + mkdocs-with-pdf)

## Pré-requisitos
- Python 3.9+ e pip instalados

## Instalação (opcional: ambiente virtual)
- Windows (PowerShell):
    ```
    python -m venv .venv
    .\.venv\Scripts\Activate.ps1
    pip install mkdocs mkdocs-material mkdocs-with-pdf
    ```
- Linux/macOS:
    ```
    python -m venv .venv
    source .venv/bin/activate
    pip install mkdocs mkdocs-material mkdocs-with-pdf
    ```

## Configuração (mkdocs.yml na raiz do projeto)
Crie/edite o arquivo mkdocs.yml:
```yaml
site_name: Peixe Babel
theme:
    name: material

plugins:
    - search
    - with-pdf:
            output_path: pdf/peixe-babel.pdf  # será gerado dentro de site/

nav:
    - Início: index.md
    - Capítulo 1: cap1.md
    - Capítulo 2: cap2.md
```

Observações:
- A ordem do PDF segue a ordem definida em nav.
- Os arquivos .md devem estar em docs/ (ex.: docs/index.md, docs/cap1.md, ...).

## Desenvolvimento (site local)
```
mkdocs serve
```
- Acesse http://127.0.0.1:8000

## Build (site estático + PDF)
```
mkdocs build --clean
```
- Saída do site: site/
- Saída do PDF: site/pdf/peixe-babel.pdf

## Dicas
- Imagens e links devem ser relativos à pasta docs/.
- Se o PDF não aparecer, confirme se o plugin está em plugins e rode mkdocs build novamente.
- Para publicar (ex.: GitHub Pages): mkdocs gh-deploy