---
name: interviewing
description: "Interview the user about a plan or open question until a carry-only-conclusions briefing (docs/handoff-<date>.md) stands: charter first (scope, terminology, mode), questions per register, briefing at the end. Use when the user wants to be interviewed or grilled about an undertaking, wants a briefing/handoff for a next session, or another skill needs a structured interview. Never starts implementation; it ends with the briefing."
---

# Interviewing

Interview the user until a briefing for the next session stands: charter first, then rounds of questions in one register, then a carry-only-conclusions briefing.
Base: Matt Pocock's grilling (mattpocock/skills v1.3.1, MIT, vendored verbatim below; license and provenance in `vendor/mattpocock-skills/`). Troy-Delta from Chelsea Troy, *The Curse of Unbounded Contexts*, DDD Europe 2026.
**Where the Delta conflicts with the base, the Delta wins.**

<!-- BEGIN VENDORED: mattpocock/skills v1.3.1 skills/productivity/grilling/SKILL.md (MIT) — do not edit, see vendor/mattpocock-skills/VENDORED.md -->

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
<!-- END VENDORED -->

## Troy-Delta

### 1. Overrides of the base

- (a) A recommended answer per question only in register Deciding, not always.
- (b) The `❓ **Q1**` / `➡️` text format is replaced by AskUserQuestion (section 3).
- (c) "Done when the frontier is empty" is extended by the briefing gate (`### Readiness gate`).
- (d) Everything else in the base holds: design tree, rounds, frontier, facts via sub-agent, decisions belong to the user.

### 2. Round 0: Charter (Troy: conversation charter)

Before computing any frontier, establish the charter:

- **Scope:** which system, which problem. Also the **target area path**: the folder whose `docs/` receives the briefing. Default to the cwd if it has a `docs/` dir, otherwise ask.
- **Terminology:** the central terms and what they mean in this context. Actively ask about every term that could be ambiguous.
- **Mode** = register: Exploring / Brainstorming / Deciding / Implementing.

Once settled, restate the charter in one block and have the user confirm it. On the first surprising answer, do not correct: ask "what did you understand by X?".

**With ai-mem (optional):** once the charter is confirmed, if the agent type `fabrica:librarian` is available, spawn it once with the charter as the question and the target area path. Use its answer as facts, never as decisions. If it is not available, skip this silently; the interview works the same. Never write records.

### 3. Questions via AskUserQuestion

Ask every question through the AskUserQuestion tool (a deliberate deviation from Pocock, who rejects the native question tool because it pushes towards multiple choice).

- One round = the whole frontier. Per call 1–4 questions with 2–4 options each; a frontier of more than 4 questions goes over several calls within the same round.
- Questions that depend on each other never go into the same round.
- `header` = short question title (≤12 chars). Free answers go through the built-in "Other".

Per register (the charter's Mode):

- **Deciding:** the first option is your recommendation; its label ends with "(Recommended)".
- **Exploring:** understand, change nothing. Options are neutral angles or hypotheses. Do not evaluate or recommend: no "(Recommended)", no ranking; evaluating belongs to Deciding.
- **Brainstorming:** ask for options and collect them; do not evaluate. No "(Recommended)". Options may be of the kind "Add another option" / "Enough for now".
- **Implementing:** the interview only confirms the charter and the briefing.

Flattening risk (Pocock's objection): if a whole round came back as pure option clicks, ask one open question in the user's own words ("why this one?") before the next round. Pocock's passivity signal ("agreed" 40 times) is a reason to stop and check.

### 4. Register change (Troy: one conversation, one domain)

One conversation, one register, one domain. If the conversation drifts into another register or domain (e.g. evaluating during Exploring or Brainstorming, starting to implement), say so and propose closing this register with a handoff (`### Briefing file`) and continuing in a new session. Do not just continue. Never mix Brainstorming and Deciding.

### 5. Third-Time Rule (Troy: anti-corruption-layer moment)

Keep a count of corrections per point. At the third correction on the same point, stop asking again: propose closing with a handoff (`### Briefing file`) instead.

### 6. Re-anchor (Troy: one conversation, one domain)

Every ~15–20 messages, restate the charter constraints in 2–4 lines and ask whether they still hold. If they no longer hold, treat it as a register or domain change (section 4).

## Briefing (output)

The result of the interview is a briefing file for the next session. It is the only thing that crosses the session boundary.

### Readiness gate

The briefing's charter carries two separate fields: **Mode (this session)** and **Next register**. The briefing hands over *to* the next session, so "the register is Implementing" means **Next register = Implementing**.

**Umsetzungsreif** (implementation-ready) = all three hold:

- (a) the frontier is empty, AND
- (b) the user explicitly confirmed the shared view (ask via AskUserQuestion; "(Recommended)" only if Mode (this session) is Deciding), AND
- (c) Next register = Implementing.

Normally a Deciding session reaches this; an Implementing session that only confirms an already settled plan can too. Exploring and Brainstorming always end with a **phase handoff** whose Next register is the proposed next one (Brainstorming or Deciding). A Deciding session that stops with a non-empty frontier is also a phase handoff: Next register = Deciding, open points = the remaining frontier.

**Who sets Next register:** you propose it, the user confirms it in the closing question (b). After a register change (Delta section 4) it is the register the conversation drifted into. After the Third-Time Rule (section 5) it stays the same register in a fresh session, and the contested point goes into open points.

### Briefing file

The briefing follows Troy's carry-only-conclusions handoff: charter, conclusions, open points, no history. The charter stands at the head of every briefing (Troy: conversation charter).

Path: `<target area>/docs/handoff-<YYYY-MM-DD>.md`. If a file with that name exists, ask (overwrite as state / write `handoff-<date>-<slug>.md`); never append. Point to artifacts by path or id instead of copying their content.

Template (German variant):

```
# Handoff <date>: <topic>

Format: Carry-only-Conclusions (Praxis 3). Charter, Schlussfolgerungen, offene Punkte, kein Verlauf.
Status: umsetzungsreif | Phase-Handoff (<Mode> → <Nächstes Register>)

## Charter

**Scope:** ...
**Terminologie:** ...
**Mode (diese Session):** ...
**Nächstes Register:** ...

## Schlussfolgerungen

1. <conclusion, pointing to artifacts by path/id>

## Offene Punkte

- <empty only if umsetzungsreif>

## Start with

- umsetzungsreif: Neue Session mit diesem Briefing, dann `/dev-team:chunk-plan`.
- Phase-Handoff: Neue Session im Register <next>, mit diesem Handoff, dann `/briefing-interviewer:brief-me`.
```

English headings: Charter, Terminology, Mode (this session), Next register, Conclusions, Open points, Start with; Status `implementation-ready` | `phase handoff (<Mode> → <Next register>)`, e.g. `phase handoff (Exploring → Brainstorming)`. Format line: "Format: carry-only-conclusions (practice 3). Charter, conclusions, open points, no history." Start with: "New session with this briefing, then `/dev-team:chunk-plan`." | "New session in register <next>, with this handoff, then `/briefing-interviewer:brief-me`."

- Language: that of the target area's existing `docs/handoff-*.md`, else of its CLAUDE.md; if still unclear, ask in the charter.
- **No history:** no Q&A transcript, no "first we discussed".
- "Start with" names exactly one line (only the matching one, without the label), chosen by the gate: implementation-ready names `/dev-team:chunk-plan` in a new session with this briefing (the briefing file, conclusions only, is the hard boundary); otherwise the next register and `/briefing-interviewer:brief-me`.

### Glossary (optional)

When terms were clarified in the charter or later, offer via AskUserQuestion to write them into `<target area>/docs/reference/glossary.md`. Create the file only with consent. Table `| Term | Means | Not to be confused with |`; overwrite a term's row in place; no implementation details.

### Record candidates (optional)

At the end, if ai-mem is installed, list record candidates as plain text (`Decision: / Why: / Scope:`) in the final message and suggest `/fabrica:reflect` to hand them to the archivist. Do not invoke it and never write records yourself. Without ai-mem, skip this. The dependency on ai-mem is optional and one-way.

### Never

- Never invoke `/dev-team:chunk-plan` or `/dev-team:dev-team`, and never start implementing, not even when the briefing is implementation-ready. Name `/dev-team:chunk-plan` in "Start with" only.
- Never append to an existing handoff.
- Never write records.
- The session ends after the briefing is written and its path is shown.
