# Documento Básico de Desenvolvimento

## Objetivo
- Descrever como desenvolver, testar e entregar o projeto.
- Padronizar práticas para aumentar qualidade e previsibilidade.

## Escopo
- Aplicação: <nome do projeto>
- Domínio: <domínio/área>
- Responsáveis: <times/pessoas>

## Stack Técnica
- Linguagem: <ex.: TypeScript/Java/C#>
- Framework: <ex.: Node.js/.NET/Spring>
- Banco de dados: <ex.: PostgreSQL>
- Outras dependências: <ex.: Redis, Mensageria>

## Pré-requisitos
- Versões: <ex.: Node 20 / .NET 8 / Java 21>
- Ferramentas: Git, <gerenciador de pacotes>, Docker (opcional)

## Configuração do Ambiente
- Clonar repositório: `git clone <url>`
- Instalar dependências: `<comando>`
- Variáveis de ambiente: copiar `.env.example` para `.env` e preencher chaves.
- Executar local: `<comando>` (modo dev), `<comando>` (build)

## Estrutura do Projeto
- src/ — código-fonte
- tests/ — testes automatizados
- docs/ — documentação
- scripts/ — automações (lint, build, release)
- .github/ — pipelines/PR templates (se aplicável)

## Convenções de Código
- Estilo: <formatter> e <linter> obrigatórios.
- Commits: Conventional Commits (ex.: feat:, fix:, chore:).
- Branches: `feature/<id-issue>-<slug>`, `fix/<id-issue>-<slug>`.
- PRs: pequenos, com descrição, checklist e link para issue.

## Fluxo de Desenvolvimento
- Abrir issue → criar branch → implementar → testes → PR → revisão → merge.
- Exigir CI verde e 1+ aprovação antes do merge.
- Feature flags para mudanças impactantes.

## Testes e Qualidade
- Tipos: unitários, integração, e2e (quando necessário).
- Cobertura mínima: <ex.: 80%>.
- Comandos: `test`, `test:watch`, `test:coverage`.
- Análise estática e verificação de tipos no CI.

## Build e Execução
- Build: `<comando>`
- Artefatos: <ex.: dist/, container>
- Versão: automatizar via tag/release (semver).

## Deploy
- Ambientes: dev → staging → prod.
- Estratégia: <ex.: blue/green, canário>.
- Gatilho: merge na main + tag de release.
- Rollback: documentado e testado.

## Observabilidade
- Logs estruturados (JSON).
- Métricas: <ex.: Prometheus/OpenTelemetry>.
- Tracing distribuído para chamadas entre serviços.
- Dashboards e alertas definidos.

## Segurança
- Segredos via cofre (nunca em código).
- SAST/DAST e dependabot/renovate.
- Princípio do menor privilégio em acessos.

## Versionamento e Compatibilidade
- SemVer: MAJOR.MINOR.PATCH.
- Notas de versão e mudanças quebráveis documentadas.

## Tarefas Abertas
- [ ] Preencher versões e comandos reais.
- [ ] Definir thresholds de qualidade.
- [ ] Configurar pipelines e políticas de PR.

## Referências
- Guia de contribuição: docs/contributing.md
- Padrões de commit: https://www.conventionalcommits.org/
- SemVer: https://semver.org/
- <links internos úteis>