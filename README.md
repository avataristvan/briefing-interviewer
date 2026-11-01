# briefing-interviewer

A Claude Code plugin that interviews you about a plan before anything gets built, and ends with a short briefing the next session can act on.

## The problem

With a coding agent, building is cheap and fast, so it starts too early. A plan you only half understand turns into code, and the open questions show up later as rework: a term that meant one thing to you and another to the model, a constraint from message three that no longer carries weight by message forty, a session that drifted from "let's understand this" into "let's change it" without anyone deciding to.

Long conversations make this worse. Each correction adds to the context instead of replacing it, so the model keeps sliding back to the version you already rejected.

## What it does

`briefing-interviewer` puts an interview between the idea and the code:

1. **Charter first.** Scope (which system, which problem), terminology (what the key terms mean *here*), and mode (exploring, brainstorming, deciding or implementing). You confirm it before the first real question.
2. **Questions in rounds.** It works through the open decisions as a tree. Each round asks only what can be answered now and leaves the questions that depend on those answers for later. It looks up facts itself (files, tools) and only asks you for decisions.
3. **One register at a time.** In exploring or brainstorming it doesn't evaluate. If the conversation drifts into deciding or implementing, it says so and proposes closing with a handoff.
4. **A briefing at the end.** It writes `docs/handoff-<date>.md`: the charter, the conclusions and the open points, with no history. The interview never starts implementing.

A briefing is **implementation-ready** only when no open decisions are left, you have confirmed the shared view, and the next register is implementing. Otherwise it is a **phase handoff** that names the next register (for example exploring → brainstorming).

## What comes out

An illustrative briefing: [`examples/briefing-example.md`](examples/briefing-example.md). In short:

```markdown
# Handoff 2026-10-28: CSV export for reading lists

Format: carry-only-conclusions (practice 3). Charter, conclusions, open points, no history.
Status: implementation-ready

## Charter
**Scope:** ...   **Terminology:** ...   **Mode (this session):** Deciding   **Next register:** Implementing

## Conclusions
1. ...

## Open points
(none)

## Start with
New session with this briefing, then `/dev-team:chunk-plan`.
```

## The four practices

The interview follows four practices from Chelsea Troy's talk [*The Curse of Unbounded Contexts: Using Domains as LLM Consumers*](https://www.youtube.com/watch?v=J6OZhCTVgHI) (DDD Europe 2026). Her argument: most failed LLM conversations share one cause, the missing context boundary, and domain-driven design already has words for that. Summarised here in my own words; the talk is worth watching in full.

- **Conversation charter** ([26:50](https://www.youtube.com/watch?v=J6OZhCTVgHI&t=1610s)): start with scope, terminology and mode. Otherwise you and the model can be sure of two different meanings of "model" without noticing. The interviewer asks about every term that could be ambiguous, and at the first surprising answer it asks what you understood by the term instead of correcting you.
- **One conversation, one domain** ([28:29](https://www.youtube.com/watch?v=J6OZhCTVgHI&t=1709s)): exploring, brainstorming, deciding and implementing are different ways of thinking. Mixed in one conversation, the answers come out as half explanation, half proposal. The interviewer stays in one register, re-anchors the charter every 15–20 messages, and proposes a handoff when the register changes.
- **Carry-only-conclusions handoff** ([29:19](https://www.youtube.com/watch?v=J6OZhCTVgHI&t=1759s)): the next conversation starts from the conclusions only, written like a briefing for a pair partner, not from the transcript. That is the file this plugin produces.
- **Third-time rule** ([32:51](https://www.youtube.com/watch?v=J6OZhCTVgHI&t=1971s)): if the same point has been corrected three times and still doesn't hold, the context is the problem, not the explanation. The interviewer counts corrections per point and proposes closing with a handoff instead of asking again.

## Built on Matt Pocock's grilling

The interview core is Matt Pocock's [grilling skill](https://github.com/mattpocock/skills) (MIT), vendored unchanged with its licence and pinned version in [`vendor/mattpocock-skills/`](vendor/mattpocock-skills/VENDORED.md) and embedded verbatim in the core skill. The practices above are layered on top as an explicit list of overrides. One deliberate deviation: questions go through Claude Code's native question tool (AskUserQuestion), and a round of pure option clicks is followed by one open "why this one?" question to counter the flattening Pocock warns about.

`scripts/check-vendor.sh` checks that the vendored copy and the embedded block still match.

## Install

```bash
claude plugin marketplace add avataristvan/briefing-interviewer
claude plugin install briefing-interviewer@briefing-interviewer
```

## Usage

- `/briefing-interviewer:brief-me [topic or target folder]` starts an interview (bare `/brief-me` works when no other plugin uses the name).
- `briefing-interviewer:interviewing` is the core skill. Claude can also load it on its own when you ask to be interviewed or grilled about a plan, or when you want a briefing for the next session.

The briefing goes to `<target folder>/docs/handoff-<date>.md`, in the language of the folder's existing handoffs (English and German templates are built in). An existing file is never appended to.

## Optional: Fabrica

The plugin works on its own. If [Fabrica](https://github.com/avataristvan/fabrica) is installed, the interviewer also asks its librarian for recorded decisions once the charter stands, and at the end it lists record candidates for the archivist. Without Fabrica these steps are skipped silently.

## Status

This is a working tool from my own setup, not a polished product. It has been through a few trial runs, and their findings are being worked in step by step.

## License

MIT, see [LICENSE](LICENSE). The vendored grilling skill keeps its own MIT licence (Copyright (c) 2026 Matt Pocock).
