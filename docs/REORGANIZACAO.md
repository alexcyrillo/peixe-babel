# Reorganização da Documentação - Art. 9º

## Alterações Realizadas

A estrutura do TCC foi reorganizada para atender ao **Art. 9º** que especifica a estrutura do relatório técnico para projetos de Engenharia de Computação.

### Estrutura Antiga vs Nova

**ANTES** (estrutura genérica):
- index.md (visão geral genérica)
- introduction.md (introdução sobre "sistemas")
- abstract.md (template vazio)
- conclusion.md (vazio)
- references.md (vazio)
- chapters/ (documentos de template)

**DEPOIS** (conforme Art. 9º):
1. **index.md** — Capa e Resumo (pt/en)
2. **introduction.md** — 1. Introdução e Objetivos (contexto, problema, objetivos gerais e específicos, justificativa, escopo)
3. **requirements.md** — 2. Requisitos Funcionais e Não Funcionais (RF01-05, RNF01-07, casos de uso)
4. **modeling.md** — 3. Modelagens (Funcional: contexto, casos de uso | Estática: classes | Dinâmica: sequência, estado)
5. **chapters/chapter4.md** — 4.1 Arquitetura e Design (componentes, decisões, segurança)
6. **chapters/chapter5.md** — 4.2 Implementação (backend, mobile, infraestrutura)
7. **chapters/chapter6.md** — 5. Procedimentos de Testes e Validação (plano, usabilidade, performance, segurança)
8. **conclusion.md** — 6. Resultados e Considerações Finais (resultados, contribuições, limitações, trabalhos futuros)
9. **references.md** — 7. Referências e Anexos Técnicos (bibliografia, código, diagramas, esquemas, glossário)

### Novos Arquivos Criados

- `docs/requirements.md` — Especificação completa de requisitos
- `docs/modeling.md` — Diagramas e modelagens (UML em ASCII art)

### Arquivos Atualizados

- `docs/index.md` — Capa com resumo e abstract
- `docs/introduction.md` — Introdução completa com objetivos e escopo
- `docs/conclusion.md` — Resultados, contribuições e trabalhos futuros
- `docs/references.md` — Bibliografia e anexos técnicos completos
- `mkdocs.yml` — Navegação reorganizada conforme Art. 9º

### Conteúdo dos Capítulos

Os capítulos em `docs/chapters/` foram transformados de templates genéricos para conteúdo específico do Peixe Babel:

- **chapter1.md** → Fundamentos e contexto teórico
- **chapter2.md** → Revisão bibliográfica (SRS, NLP, LLMs)
- **chapter3.md** → Metodologia e cronograma
- **chapter4.md** → Arquitetura e decisões técnicas
- **chapter5.md** → Implementação (backend, mobile)
- **chapter6.md** → Avaliação e testes
- **chapter7.md** → Conclusão e trabalhos futuros

## Estrutura de Navegação do PDF

O PDF será gerado com a seguinte ordem (conforme `mkdocs.yml nav:`):

1. Capa e Resumo
2. Introdução e Objetivos
3. Requisitos Funcionais e Não Funcionais
4. Modelagens (Funcional, Estática, Dinâmica)
5. Estratégias de Implementação
   - Arquitetura e Design
   - Implementação
6. Procedimentos de Testes e Validação
7. Resultados e Considerações Finais
8. Referências e Anexos Técnicos
9. Anexos (Documento de Visão, Diagrama de Contexto)

## Como Gerar o PDF

```bash
# Ativar ambiente virtual (se houver)
# Windows PowerShell
.\.venv\Scripts\Activate.ps1

# Instalar dependências (se necessário)
pip install mkdocs mkdocs-material mkdocs-with-pdf

# Gerar site e PDF
mkdocs build --clean

# Resultado
# Site: site/
# PDF: site/pdf/tcc-peixe-babel.pdf
```

## Checklist Art. 9º

- [x] (i) Introdução e objetivos do projeto
- [x] (ii) Requisitos funcionais e não funcionais
- [x] (iii) Modelagens (funcional, estática, dinâmica)
- [x] (iv) Estratégias de implementação
- [x] (v) Procedimentos de testes e validação
- [x] (vi) Resultados e considerações finais
- [x] (vii) Referências e anexos técnicos (códigos, esquemas, diagramas, etc.)

## Próximos Passos

1. **Revisar conteúdo técnico**: Preencher detalhes específicos de implementação nos capítulos 4 e 5
2. **Adicionar diagramas**: Criar imagens UML e salvar em `docs/img/`
3. **Completar anexos**: Adicionar código-fonte, schemas SQL, exemplos de API
4. **Validar build**: Gerar PDF e verificar formatação, numeração e índice
5. **Revisão final**: Verificar gramática, referências e consistência técnica
