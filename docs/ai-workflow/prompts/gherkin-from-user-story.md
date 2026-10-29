# Prompt: Gherkin a partir de user story

## Quando usar
Início de uma feature nova, para gerar uma primeira lista de cenários que será revisada manualmente.

## Prompt (versão 2)

```text
Você é um QA sênior especialista em BDD.

Com base na user story e nas regras abaixo, gere cenários Gherkin em pt-BR.

Requisitos:
- Cubra: caminho feliz, campos obrigatórios, valores limite, formatos inválidos e erros de negócio
- Use "Esquema do Cenário" com exemplos quando houver variação de dados
- Use "Contexto" para pré-condições comuns a todos os cenários
- Escreva steps de forma declarativa, sem citar elementos de UI (cores, posição, IDs)
- NÃO invente funcionalidades que não estejam descritas abaixo
- Se uma regra estiver ambígua, liste a dúvida ao final em vez de assumir

User story:
<cole aqui>

Regras de negócio e campos:
<cole aqui>
```

## Histórico de versões

| Versão | Mudança | Efeito observado |
|---|---|---|
| 1 | Prompt simples, só com a user story | Cenários genéricos, funcionalidades inventadas |
| 2 | Regras, "não invente", "liste dúvidas" e uso de Contexto | Menos alucinação, mais casos de borda |

## Checklist de revisão da saída

- [ ] Todos os cenários correspondem a funcionalidades reais?
- [ ] Os steps estão desacoplados da UI?
- [ ] Os asserts validam mensagens/valores exatos?
- [ ] Faltou algum caso de borda?
- [ ] Os dados de teste são fictícios e seguros?
