# Vendored: mattpocock/skills, grilling

- Upstream repo: https://github.com/mattpocock/skills
- Path: `skills/productivity/grilling/SKILL.md`
- Tag: `v1.3.1`
- Commit: `24fe0ef7737efae15c87225755e9f6f5965e4888`
- Fetch date: 2026-10-20
- License: MIT, Copyright (c) 2026 Matt Pocock (see `LICENSE` in this directory)

Checksum of the vendored `grilling/SKILL.md` (byte-identical to upstream; `scripts/check-vendor.sh` parses this line and nothing else):

sha256: 10ff989e7498b23b5acb49d5048f11dcd906757d2f79c5cdf8a00001381296f2

## Why vendored, not installed

Copied with attribution, license and version instead of installed as a plugin: the upstream plugin brings about ten further model-invoked skills (code review, TDD, research, prototyping) that would compete with the user's own workflow. Upstream changes are tracked by hand.

## Where it is embedded

`skills/interviewing/SKILL.md`, body only (without Pocock's frontmatter), between the `<!-- BEGIN VENDORED: ... -->` and `<!-- END VENDORED -->` markers.

## Updating by hand

1. Compare upstream `main` to the pinned commit: https://github.com/mattpocock/skills/compare/24fe0ef7737efae15c87225755e9f6f5965e4888...main (path filter `skills/productivity/grilling`).
2. Replace the vendored copy and update tag, commit, fetch date and sha256 here.
3. Run `scripts/check-vendor.sh`; update the marked block in the core skill until it passes.
4. Re-check the Delta's override list in the core skill against the new base.
