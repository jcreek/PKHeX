# Contributing to PKHeX Web

PKHeX Web is an unofficial fork of [PKHeX](https://github.com/kwsch/PKHeX). The aim is to stay close enough to upstream that the web app could one day be merged back. Most of what follows exists to keep that possible.

Upstream's [contributing guidelines](../.github/CONTRIBUTING.md) apply here too. Those are:
- maintainable code, with comments and xmldoc where they help
- non-GUI logic kept apart from GUI code
- game data modelled the way the game handles it
- spaces, not tabs, in standard Visual Studio C# style, as set by `.editorconfig`

## Branches and pull requests

- `main` is the default branch and holds the web app. `master` is an untouched mirror of upstream master; never commit to it.
- Branch from an up-to-date `main`, and don't let the new branch track it. If it does, a plain `git push` lands directly on `main`:
  ```sh
  git checkout main && git pull --ff-only
  git checkout -b <name>                       # a local start point sets no upstream
  # or, from the remote: git checkout -b <name> --no-track origin/main
  git push -u origin <name>                    # first push
  ```
- Open a pull request into `main`. Pull requests are squash-merged.
- Use [Conventional Commits](https://www.conventionalcommits.org/) for titles and commit messages, scoped where it helps: `feat(web): ...`, `fix(core): ...`, `ci(web): ...`.

## Staying in step with upstream

The maintainer syncs by hand, from the fork's page on GitHub: **Sync fork → Update branch**, on `main` and on `master`. This merges upstream's new commits with a merge commit, so git records what has been synced and the next sync only brings what is new. Your pull requests pick up the synced commits when you update your branch from `main`.

Never choose **Discard commits** on `main`: it resets `main` to upstream and throws away the web app.

When GitHub reports a conflict, merge by hand on a branch instead:

```sh
git remote add upstream https://github.com/kwsch/PKHeX.git   # once
git fetch upstream
git checkout -b sync/upstream-<date> --no-track origin/main
git merge upstream/master
```

Open a pull request for it, and merge it with **a merge commit, not a squash**. A squash loses the record of what has been synced, and every later sync conflicts again.

## Changing files outside the web app

The web app lives in `PKHeX.Web`, `PKHeX.Web.SpriteAtlas` and `Tests/PKHeX.Web.Tests`. Any other path that differs from upstream must be listed in [`tools/fork-boundary.txt`](tools/fork-boundary.txt). The [`fork-boundary`](../.github/workflows/fork-boundary.yml) check fails a pull request that changes an unlisted path. Run it locally:

```sh
git fetch upstream && git -c core.quotePath=false diff --no-renames --name-only upstream/master...HEAD | PKHeX.Web/tools/fork-boundary.sh
```

When the web app needs something from PKHeX.Core (or a matching WinForms change):

1. **Make it a change upstream would want on its own.** That means a GUI-agnostic abstraction, a fix, or tests. It should not mention the web app.
2. **Propose it upstream.** Branch from upstream master with `git checkout -b core/<topic> --no-track upstream/master`, push it, and open a pull request into `kwsch/PKHeX:master`.
3. **Carry the identical change on `main`.** Add each changed path to `fork-boundary.txt` with a comment naming the upstream pull request, for example `# kwsch/PKHeX#4889`. Keep the two copies identical: when review changes the upstream pull request, make the same change on `main`. Any difference becomes a conflict at the next sync.
4. **Let the next sync bring it in once upstream merges it.** If upstream merged it unchanged, the sync merges cleanly. If upstream changed it, the sync conflicts: take upstream's version and adapt the web app. Either way, the check then warns that the entry no longer differs, so remove it.

Don't edit upstream's files for the fork's branding or docs. Add new files instead, such as [`.github/README.md`](../.github/README.md), which GitHub shows instead of upstream's root README.

## Reporting issues

Report problems with PKHeX Web in this repository's issues. Problems that also happen in the PKHeX desktop editor, or in PKHeX.Core itself, belong at [kwsch/PKHeX](https://github.com/kwsch/PKHeX/issues).

Never attach a save file you are not willing to share publicly. The app's diagnostic report (About → "Prepare a diagnostic report") holds no save data and is safe to paste.
