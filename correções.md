# Documento de Correção - TCC Peixe Babel
## Análise de Problemas Estruturais, Erros de Português e Normas ABNT

**Data da Análise:** 2025  
**Documentos Analisados:** 
- `tcc/abstract.md`
- `tcc/chapters/chapter1_introduction.md`
- `tcc/chapters/chapter2_requirements.md`
- `tcc/chapters/chapter3_modeling.md`
- `tcc/chapters/chapter4_architecture.md`
- `tcc/chapters/chapter5_implementation.md`
- `tcc/conclusion.md`
- `tcc/references.md`
- `tcc/appendix.md`

---

## 1. PROBLEMAS ESTRUTURAIS

### 1.1. Estrutura Geral do Documento

**Status:** ✅ A estrutura geral está adequada conforme Art. 9º, mas há alguns problemas:

**Problemas identificados:**
1. **Falta de elementos pré-textuais completos:**
   - Não há capa visível nos arquivos Markdown
   - Não há folha de rosto
   - Não há ficha catalográfica
   - Não há dedicatória (opcional, mas comum em TCCs)
   - Não há agradecimentos (opcional, mas comum em TCCs)
   - Não há epígrafe (opcional)

2. **Resumo e Abstract:**
   - ✅ Presentes no arquivo `abstract.md`
   - ⚠️ Verificar se estão formatados corretamente conforme ABNT (fonte, espaçamento, palavras-chave)

3. **Listas:**
   - ❌ Não há lista de ilustrações
   - ❌ Não há lista de tabelas
   - ❌ Não há lista de abreviaturas e siglas (há glossário, mas não lista de siglas)
   - ❌ Não há lista de símbolos

4. **Sumário:**
   - ⚠️ Verificar se o sumário será gerado automaticamente no PDF final

### 1.2. Numeração e Hierarquia de Seções

**Status:** ✅ A numeração está adequada, mas há inconsistências:

**Problemas:**
- Alguns capítulos usam numeração (1, 2, 3...), outros não
- Verificar se a numeração está consistente em todo o documento

### 1.3. Referências Bibliográficas

**Status:** ⚠️ Há referências, mas com problemas:

**Problemas identificados:**
1. **Numeração duplicada:** No arquivo `references.md`:
   - Linha 8: "8. **Nation, I. S. P.**"
   - Linha 25: "8. **Vaswani, A., et al.**"
   - Linha 35: "8. **Martin, R. C.**"
   - Linha 46: "10. **OpenAI**" (duplicado)
   - Linha 48: "11. **alankan886**" (mas linha 31 já tem "11. **Wei, J., et al.**")

2. **Formatação inconsistente:** Algumas referências não seguem ABNT NBR 6023:
   - Falta local de publicação em algumas
   - Falta editora em algumas
   - URLs sem data de acesso em algumas
   - Formatação de autores inconsistente

3. **Citações no texto:** Verificar se todas as citações no texto têm referências correspondentes

---

## 2. ERROS DE PORTUGUÊS

### 2.1. Erros de Ortografia e Grafia

#### 2.1.1. Uso de "dia-a-dia" vs "dia a dia"
**Localização:** Não encontrado nos arquivos analisados (já corrigido ou não presente)

#### 2.1.2. Espaço antes de ponto final
**Status:** ✅ Não encontrados espaços antes de pontos finais

#### 2.1.3. Uso de hífen
**Status:** ✅ Uso de hífen parece correto

### 2.2. Erros de Concordância

#### 2.2.1. Concordância verbal
**Localização:** `chapter1_introduction.md`, linha 15

**Erro:**
```
Ao compreender com esses obstáculos, é possível uma proposta de solução
```

**Correção:**
```
Ao compreender esses obstáculos, é possível propor uma solução
```
ou
```
Ao compreender esses obstáculos, torna-se possível uma proposta de solução
```

**Justificativa:** "compreender com" está incorreto. Deve ser "compreender" ou "lidar com".

### 2.3. Erros de Pontuação

#### 2.3.1. Uso de vírgula
**Status:** ✅ Uso de vírgula parece adequado

#### 2.3.2. Uso de dois-pontos
**Status:** ✅ Uso de dois-pontos adequado

### 2.4. Erros de Redação e Estilo

#### 2.4.1. Construções inadequadas

**Localização:** `chapter1_introduction.md`, linha 15

**Texto:**
```
Ao compreender com esses obstáculos, é possível uma proposta de solução integrada
```

**Correção:**
```
Ao compreender esses obstáculos, torna-se possível propor uma solução integrada
```

#### 2.4.2. Repetição de termos

**Observação:** O termo "flashcard" aparece muitas vezes, o que é aceitável em um trabalho técnico, mas poderia ser variado ocasionalmente com "cartão de estudo" ou "cartão".

### 2.5. Problemas de Coesão e Coerência

**Status:** ✅ O texto apresenta boa coesão e coerência geral

---

## 3. PROBLEMAS COM NORMAS ABNT

### 3.1. Citações

#### 3.1.1. Citações diretas sem indicação de página

**Localização:** Várias

**Problema:** Em trabalhos acadêmicos, citações diretas devem indicar a página.

**Recomendação:** Verificar se há citações diretas e adicionar números de página quando aplicável.

#### 3.1.2. Citações indiretas

**Status:** ✅ As citações indiretas estão presentes e adequadas

**Exemplo correto encontrado:** `chapter1_introduction.md`, linha 43:
```
(OECD, 2021; Pane et al., 2015)
```

### 3.2. Formatação de Siglas e Abreviações

#### 3.2.1. Siglas não definidas na primeira ocorrência

**Problemas identificados:**

1. **"SRS"** - Aparece em `abstract.md` linha 9 sem definição completa na primeira menção
   - **Correção:** "sistema de repetição espaçada (SRS)" na primeira ocorrência

2. **"LLM"** - Aparece em `abstract.md` linha 12 sem definição completa
   - **Correção:** "modelos de linguagem de grande escala (LLM)" na primeira ocorrência

3. **"MVP"** - Aparece em `conclusion.md` linha 55 sem definição
   - **Correção:** "Produto Mínimo Viável (MVP - Minimum Viable Product)" na primeira ocorrência

4. **"SM-2"** - Aparece várias vezes, mas a primeira definição completa está apenas no apêndice
   - **Recomendação:** Definir na primeira ocorrência no texto principal

5. **"TTS"** - Aparece sem definição completa
   - **Correção:** "síntese de texto em voz (TTS - Text-to-Speech)" na primeira ocorrência

6. **"NLP"** - Aparece em `chapter1_introduction.md` linha 43 sem definição
   - **Correção:** "processamento de linguagem natural (NLP - Natural Language Processing)" na primeira ocorrência

7. **"API"** - Aparece várias vezes, mas deveria ser definida na primeira ocorrência
   - **Correção:** "Interface de Programação de Aplicações (API)" na primeira ocorrência

8. **"REST"** - Aparece sem definição
   - **Correção:** "Representational State Transfer (REST)" na primeira ocorrência

9. **"JWT"** - Aparece sem definição
   - **Correção:** "JSON Web Token (JWT)" na primeira ocorrência

10. **"LGPD"** - Aparece sem definição completa
    - **Correção:** "Lei Geral de Proteção de Dados (LGPD)" na primeira ocorrência

11. **"CRUD"** - Aparece sem definição
    - **Correção:** "Create, Read, Update, Delete (CRUD)" na primeira ocorrência

12. **"ADR"** - Aparece em `chapter4_architecture.md` linha 164 sem definição
    - **Correção:** "Architecture Decision Records (ADR)" na primeira ocorrência

### 3.3. Formatação de Títulos e Subtítulos

**Status:** ✅ Títulos estão formatados adequadamente em Markdown

**Observação:** Verificar se a formatação final no PDF/Word segue ABNT:
- Tamanho de fonte adequado
- Espaçamento adequado
- Negrito quando necessário
- Numeração consistente

### 3.4. Referências a Figuras e Tabelas

#### 3.4.1. Referência a figuras sem numeração adequada

**Problemas identificados:**

1. **`chapter3_modeling.md`:**
   - Linha 11: `![Diagrama de Contexto...]` - falta numeração e referência no texto
   - Linha 24: `![Diagrama de Casos de Uso...]` - falta numeração e referência
   - Linha 41: `![Diagrama de Classes...]` - falta numeração e referência
   - Linha 52: `![Diagrama de Sequência...]` - falta numeração e referência
   - Linha 65: `![Diagrama de Sequência...]` - falta numeração e referência
   - Linha 78: `![Diagrama de Sequência...]` - falta numeração e referência
   - Linha 95: `![Diagrama de Estados...]` - falta numeração e referência
   - Linha 106: `![Diagrama de Componentes...]` - falta numeração e referência

**Correção necessária:**
Todas as figuras devem ter:
1. Numeração sequencial (Figura 1, Figura 2, etc.)
2. Título descritivo
3. Fonte (geralmente "Elaborado pelo autor" ou fonte específica)
4. Referência no texto (ex: "conforme Figura 1" ou "como mostra a Figura 1")

**Exemplo de correção:**
```
![Diagrama de Contexto do Sistema e atores externos](../img/diagrama_contexto.png)

**Figura 1** - Diagrama de Contexto do Sistema Peixe Babel
Fonte: Elaborado pelo autor (2025).
```

E no texto:
```
O diagrama de contexto (Figura 1) ilustra o sistema e suas interações...
```

2. **`appendix.md`:**
   - Linha 307: Há uma referência a "Figura E.1", o que está correto para apêndices
   - ✅ Esta está correta

#### 3.4.2. Referência a tabelas

**Status:** ✅ As tabelas parecem estar formatadas corretamente

**Observação:** Verificar se todas as tabelas têm:
- Numeração
- Título
- Fonte (quando aplicável)

### 3.5. Uso de Estrangeirismos

#### 3.5.1. Termos em inglês sem itálico ou tradução

**Problemas identificados:**

1. **"flashcard"** - Aparece várias vezes sem itálico
   - **Recomendação:** Na primeira ocorrência, usar "cartão de estudo (*flashcard*)" ou apenas "flashcard" se já estiver estabelecido no contexto acadêmico

2. **"decks"** - Termo em inglês
   - **Recomendação:** Usar "baralhos" ou "conjuntos" em português, ou definir na primeira ocorrência

3. **"MVP"** - Já mencionado acima, mas também precisa de itálico na primeira ocorrência se mantido em inglês

4. **"LLM"** - Já mencionado acima

5. **"SRS"** - Já mencionado acima

**Recomendação conforme ABNT:**
- Termos estrangeiros devem aparecer em itálico na primeira ocorrência
- Preferir termos em português quando possível
- Se necessário usar termo estrangeiro, definir na primeira ocorrência

### 3.6. Numeração de Páginas

**Problema:** Documentos Markdown não têm numeração de páginas visível

**Recomendação:** No documento final (Word/PDF), garantir que:
- Páginas pré-textuais sejam numeradas em algarismos romanos minúsculos (i, ii, iii...)
- Páginas textuais sejam numeradas em algarismos arábicos (1, 2, 3...)
- Numeração apareça no canto superior direito (ABNT)

### 3.7. Espaçamento e Formatação

#### 3.7.1. Espaçamento entre linhas
**Observação:** Documentos Markdown não definem espaçamento. No documento final, deve ser:
- Espaçamento 1,5 entre linhas no texto
- Espaçamento simples em citações longas, notas de rodapé, referências, legendas, etc.

#### 3.7.2. Margens
**Observação:** Verificar se o documento final tem:
- Margem superior: 3 cm
- Margem inferior: 2 cm
- Margem esquerda: 3 cm
- Margem direita: 2 cm

### 3.8. Referências Bibliográficas

#### 3.8.1. Problemas de numeração

**Localização:** `references.md`

**Problemas:**
1. **Numeração duplicada:**
   - Linha 8: "8. **Nation, I. S. P.**" (mas linha 7 já tem "7. **OECD**")
   - Linha 25: "8. **Vaswani, A., et al.**" (mas linha 24 tem "8. **Vaswani, A., et al.**" - duplicado)
   - Linha 35: "8. **Martin, R. C.**" (mas linha 34 tem "9. **Fowler, M.**")
   - Linha 46: "10. **OpenAI**" (mas linha 29 já tem "10. **OpenAI**")
   - Linha 48: "11. **alankan886**" (mas linha 31 já tem "11. **Wei, J., et al.**")

**Correção necessária:** Renumerar todas as referências sequencialmente sem duplicações.

#### 3.8.2. Formatação conforme ABNT NBR 6023

**Problemas identificados:**

1. **Livros:**
   - ✅ Formatação geral está adequada
   - ⚠️ Verificar se todos têm local, editora e ano

2. **Artigos:**
   - ✅ Formatação geral está adequada
   - ⚠️ Verificar se todos têm volume, número, páginas quando aplicável

3. **Sites/URLs:**
   - ⚠️ Linha 29: "Disponível em: https://openai.com/research/gpt-4" - falta data de acesso
   - ⚠️ Linha 42: "Disponível em: https://www.django-rest-framework.org/" - falta data de acesso
   - ⚠️ Linha 44: "Disponível em: https://flutter.dev/docs" - falta data de acesso
   - ⚠️ Linha 46: "Disponível em: https://openai.com/research/gpt-4" - duplicado e falta data de acesso
   - ✅ Linha 48: "Acesso em: 13 nov. 2025." - correto

**Correção necessária:** Adicionar data de acesso a todas as URLs no formato: "Acesso em: [dia] [mês] [ano]."

**Exemplo:**
```
OPENAI (2024). GPT-4 Technical Report. Disponível em: 
https://openai.com/research/gpt-4. Acesso em: 15 nov. 2025.
```

4. **Repositórios GitHub:**
   - ⚠️ Linha 48: Formatação pode ser melhorada conforme ABNT

**Recomendação:** Formatar como:
```
ALANKAN886. SuperMemo2 (v3.0.1). GitHub, 2024. Disponível em: 
https://github.com/alankan886/SuperMemo2. Acesso em: 13 nov. 2025.
```

#### 3.8.3. Ordenação das referências

**Status:** ⚠️ As referências não estão em ordem alfabética

**Recomendação conforme ABNT:** Referências devem estar em ordem alfabética por sobrenome do primeiro autor.

**Problema atual:** As referências estão agrupadas por tema (Aprendizado de Idiomas, Processamento de Linguagem Natural, etc.), o que não é o padrão ABNT.

**Recomendação:** Reorganizar todas as referências em ordem alfabética única, independente do tema.

### 3.9. Apêndices e Anexos

**Status:** ✅ Apêndices estão presentes e bem organizados

**Observação:** Verificar se a numeração está correta (Apêndice A, B, C...)

---

## 4. PROBLEMAS ESPECÍFICOS POR CAPÍTULO

### 4.1. Capítulo 1 - Introdução

**Problemas identificados:**

1. **Linha 15:** Erro de construção
   ```
   Ao compreender com esses obstáculos, é possível uma proposta de solução
   ```
   **Correção:**
   ```
   Ao compreender esses obstáculos, torna-se possível propor uma solução
   ```

2. **Falta de definição de siglas:**
   - SRS (linha 36)
   - SM-2 (linha 36)
   - LLM (linha 37)
   - NLP (linha 43)
   - TTS (linha 43)

3. **Citações:** Parecem adequadas, mas verificar se todas têm referências correspondentes

### 4.2. Capítulo 2 - Requisitos

**Problemas identificados:**

1. **Falta de definição de siglas:**
   - SRS (linha 28, 40)
   - SM-2 (linha 40)
   - LLM (linha 44)
   - TTS (linha 18)
   - API (várias linhas)
   - REST (linha 34)
   - JWT (linha 128)
   - LGPD (linha 123)
   - CRUD (linha 62)
   - SUS (linha 94)
   - APM (linha 107)

2. **Formatação de casos de uso:** Parece adequada

### 4.3. Capítulo 3 - Modelagem

**Problemas identificados:**

1. **Figuras sem numeração e referência adequada:**
   - Todas as figuras precisam de numeração, título e fonte
   - Referências no texto devem usar "Figura X"

2. **Falta de definição de siglas:**
   - UML (título implícito)
   - SRS (linha 44)

### 4.4. Capítulo 4 - Arquitetura

**Problemas identificados:**

1. **Falta de definição de siglas:**
   - REST (linha 9)
   - API (várias linhas)
   - JWT (linha 19)
   - OAuth2 (linha 19)
   - ADR (linha 164)

2. **Formatação de tabelas:** Parece adequada

### 4.5. Capítulo 5 - Implementação

**Problemas identificados:**

1. **Falta de definição de siglas:**
   - API (várias linhas)
   - REST (linha 11)
   - SM-2 (linha 91)

2. **Código:** Formatação parece adequada

### 4.6. Conclusão

**Problemas identificados:**

1. **Falta de definição de siglas:**
   - MVP (linha 55)
   - SRS (várias linhas)
   - LLM (várias linhas)

2. **Texto:** Parece adequado

### 4.7. Referências

**Problemas identificados:**

1. **Numeração duplicada** (já mencionado acima)
2. **Falta de data de acesso em URLs** (já mencionado acima)
3. **Ordem não alfabética** (já mencionado acima)

### 4.8. Apêndices

**Problemas identificados:**

1. **Falta de definição de siglas:**
   - SRS (várias linhas)
   - SM-2 (várias linhas)
   - API (várias linhas)
   - LLM (várias linhas)
   - TTS (linha 248)
   - CRUD (linha 62)
   - SQL (linha 301)
   - ER (linha 303)
   - SUS (linha 104)
   - JWT (linha 252)
   - OAuth2 (linha 252)
   - LGPD (linha 239)
   - OCR (linha 362)
   - STT (linha 39)

2. **Figuras:** A Figura E.1 está corretamente referenciada

---

## 5. CHECKLIST DE CORREÇÕES NECESSÁRIAS

### 5.1. Estrutura
- [ ] Adicionar elementos pré-textuais completos (capa, folha de rosto, ficha catalográfica)
- [ ] Adicionar dedicatória (opcional)
- [ ] Adicionar agradecimentos (opcional)
- [ ] Adicionar epígrafe (opcional)
- [ ] Adicionar lista de ilustrações
- [ ] Adicionar lista de tabelas
- [ ] Adicionar lista de abreviaturas e siglas
- [ ] Adicionar lista de símbolos
- [ ] Verificar sumário
- [ ] Verificar numeração de páginas

### 5.2. Português
- [ ] Corrigir "Ao compreender com esses obstáculos" → "Ao compreender esses obstáculos"
- [ ] Revisar concordâncias
- [ ] Revisar pontuação
- [ ] Revisar ortografia

### 5.3. Normas ABNT
- [ ] Definir todas as siglas na primeira ocorrência
- [ ] Adicionar numeração e referências para todas as figuras
- [ ] Verificar formatação de tabelas
- [ ] Corrigir numeração duplicada nas referências
- [ ] Adicionar data de acesso a todas as URLs
- [ ] Reorganizar referências em ordem alfabética
- [ ] Verificar formatação de todas as referências conforme ABNT NBR 6023
- [ ] Colocar termos estrangeiros em itálico na primeira ocorrência
- [ ] Verificar espaçamento entre linhas (1,5)
- [ ] Verificar margens (3cm superior/esquerda, 2cm inferior/direita)
- [ ] Verificar formatação de títulos e subtítulos
- [ ] Verificar citações (adicionar páginas quando necessário)

### 5.4. Conteúdo
- [ ] Verificar se todas as citações têm referências correspondentes
- [ ] Verificar consistência terminológica
- [ ] Revisar coesão e coerência textual

---

## 6. PRIORIDADES DE CORREÇÃO

### Prioridade ALTA (Crítico para aprovação)
1. ✅ Corrigir numeração duplicada nas referências
2. ✅ Adicionar data de acesso a todas as URLs
3. ✅ Definir todas as siglas na primeira ocorrência
4. ✅ Adicionar numeração e referências para todas as figuras
5. ✅ Corrigir erro de português "Ao compreender com esses obstáculos"

### Prioridade MÉDIA (Importante para qualidade)
1. Reorganizar referências em ordem alfabética
2. Adicionar elementos pré-textuais (listas de ilustrações, tabelas, siglas)
3. Verificar formatação de todas as referências
4. Colocar termos estrangeiros em itálico na primeira ocorrência

### Prioridade BAIXA (Melhorias)
1. Adicionar dedicatória/agradecimentos (opcional)
2. Melhorar coesão textual
3. Variar referências ao sistema

---

## 7. OBSERVAÇÕES FINAIS

1. **Qualidade Geral:** O trabalho apresenta boa qualidade técnica e conteúdo adequado. Os problemas identificados são principalmente de formatação e padronização conforme ABNT.

2. **Estrutura:** A estrutura está adequada conforme Art. 9º, mas faltam alguns elementos pré-textuais.

3. **Referências:** Há problemas de numeração duplicada e falta de datas de acesso que devem ser corrigidos.

4. **Siglas:** Todas as siglas devem ser definidas na primeira ocorrência.

5. **Figuras:** Todas as figuras devem ter numeração, título, fonte e referência no texto.

6. **Consistência:** O trabalho é consistente em termos de conteúdo, mas precisa de padronização na formatação.

---

## 8. EXEMPLOS DE CORREÇÕES ESPECÍFICAS

### 8.1. Exemplo de Correção de Sigla

**Antes:**
```
O sistema utiliza um algoritmo SRS para otimizar a revisão.
```

**Depois:**
```
O sistema utiliza um algoritmo de repetição espaçada (SRS - Spaced Repetition System) para otimizar a revisão.
```

### 8.2. Exemplo de Correção de Figura

**Antes:**
```
![Diagrama de Contexto do Sistema e atores externos](../img/diagrama_contexto.png)
```

**Depois:**
```
![Diagrama de Contexto do Sistema e atores externos](../img/diagrama_contexto.png)

**Figura 1** - Diagrama de Contexto do Sistema Peixe Babel
Fonte: Elaborado pelo autor (2025).
```

E no texto:
```
O diagrama de contexto (Figura 1) ilustra o sistema e suas interações com atores externos.
```

### 8.3. Exemplo de Correção de Referência

**Antes:**
```
10. **OpenAI** (2024). GPT-4 Technical Report. Disponível em: https://openai.com/research/gpt-4
```

**Depois:**
```
OPENAI. GPT-4 Technical Report. 2024. Disponível em: 
https://openai.com/research/gpt-4. Acesso em: 15 nov. 2025.
```

### 8.4. Exemplo de Correção de Erro de Português

**Antes:**
```
Ao compreender com esses obstáculos, é possível uma proposta de solução integrada
```

**Depois:**
```
Ao compreender esses obstáculos, torna-se possível propor uma solução integrada
```

---

**Fim do Documento de Correção**
```

Este documento identifica os principais problemas estruturais, erros de português e questões relacionadas às normas ABNT no TCC. Como estou em modo de leitura, não posso criar o arquivo diretamente. Você pode copiar este conteúdo e salvá-lo como `correcoes_tcc.md` na pasta `tcc` ou onde preferir.

Principais problemas encontrados:
1. Numeração duplicada nas referências
2. Falta de definição de siglas na primeira ocorrência
3. Figuras sem numeração e referência adequada
4. Falta de data de acesso em URLs
5. Erro de português: "Ao compreender com esses obstáculos"
6. Referências não estão em ordem alfabética
7. Faltam alguns elementos pré-textuais (listas de ilustrações, tabelas, siglas)