# Fluxo de trabalho com IA neste projeto

Princípio: a IA acelera o trabalho, mas **toda saída é revisada por mim antes de entrar no repositório**.

## Casos de uso documentados

1. [Geração de cenários Gherkin a partir de user stories](./01-geracao-cenarios.md)
2. [Análise de falhas no CI com IA](./02-analise-falhas-ci.md)
3. [Step definitions em Ruby com apoio de IA](./03-step-definitions-ruby.md)

## Prompts reutilizáveis

- [Gherkin a partir de user story](./prompts/gherkin-from-user-story.md)
- [Step definitions Ruby/Cucumber](./prompts/step-definitions-ruby.md)

## Regras que sigo

- Nunca confiar em seletores ou asserts gerados sem executar o teste
- Nunca enviar dados sensíveis (credenciais, dados pessoais reais) para a IA
- Registrar os prompts que funcionaram em `prompts/`
- Documentar sempre onde a IA errou
- Toda sugestão da IA no CI é **informativa**: nenhuma correção é aplicada automaticamente

## Resumo de resultados

> Exemplo: 

| Atividade | Sem IA | Com IA + revisão |
|---|---|---|
| Escrita de cenários de uma feature | ~2h | ~40min |
| Steps + Page Object de uma feature | ~1h30 | ~35min |
| Triagem de uma falha no CI | ~20min | ~5min |

## Limitações observadas

- A IA pode inventar funcionalidades que não existem na aplicação
- Asserts gerados tendem a ser genéricos e precisam de endurecimento
- Seletores e esperas sugeridos nem sempre são estáveis
