PKHeX Web
=========

![License](https://img.shields.io/badge/License-GPLv3-blue.svg)

**An unofficial, browser-based fork of [PKHeX](https://github.com/kwsch/PKHeX).** It is not made or supported by the PKHeX maintainers: report problems with PKHeX Web here, and problems with the PKHeX desktop editor or PKHeX.Core at [kwsch/PKHeX](https://github.com/kwsch/PKHeX/issues).

PKHeX Web is a static Blazor WebAssembly save editor built on PKHeX.Core, the library behind the PKHeX desktop editor. The save never leaves your device: the files are opened, edited, checked for legality and downloaded entirely in the browser, with no server, upload, analytics or persistent storage.

It currently opens raw, decrypted **Pokémon X, Y, Omega Ruby and Alpha Sapphire** saves. For an open save you can:

- browse the party and boxes
- edit a Pokémon's species and form, nickname, language, friendship, level and experience, nature, IVs and EVs, held item, moves, PP and PP Ups, ability and gender
- run PKHeX.Core's legality analysis
- download the edited save

Every other game is refused for now. Support for more games is the next step.

**We do not support or condone cheating at the expense of others. Do not use significantly hacked Pokémon in battle or in trades with those who are unaware hacked Pokémon are in use.**

## Relationship to PKHeX

This repository is a fork of [kwsch/PKHeX](https://github.com/kwsch/PKHeX), and it is kept as close to upstream as it can be:

- **Synced with upstream.** Upstream's changes are merged into `main` regularly, and `master` mirrors upstream master.
- **Upstream files are left as they are.** The web app lives in its own folders: `PKHeX.Web`, `PKHeX.Web.SpriteAtlas` and `Tests/PKHeX.Web.Tests`. Every other file that differs from upstream is listed, with the reason, in [`PKHeX.Web/tools/fork-boundary.txt`](https://github.com/jcreek/PKHeX/blob/main/PKHeX.Web/tools/fork-boundary.txt), and CI fails on any change it does not list ([fork-boundary](https://github.com/jcreek/PKHeX/blob/main/.github/workflows/fork-boundary.yml)).
- **Core changes go upstream first.** Anything the web app needs from PKHeX.Core is proposed to kwsch/PKHeX as its own pull request, and carried here only until upstream has it.

Everything that makes PKHeX work, from save parsing to legality checking, is the work of kwsch and the [PKHeX contributors](https://github.com/kwsch/PKHeX/graphs/contributors). Upstream's own README is [`README.md`](https://github.com/jcreek/PKHeX/blob/main/README.md).

## Using and building it

[`PKHeX.Web/README.md`](https://github.com/jcreek/PKHeX/blob/main/PKHeX.Web/README.md) covers:

- building and serving the static site, including the security headers it needs
- what the app does and refuses
- the test tiers and CI

The quick version, with the [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0):

```sh
dotnet publish PKHeX.Web/PKHeX.Web.csproj -c Release -o PKHeX.Web/bin/Release/publish
python3 -m http.server 8080 --bind 127.0.0.1 --directory PKHeX.Web/bin/Release/publish/wwwroot
```

## Contributing

Contributions are welcome. See [`PKHeX.Web/CONTRIBUTING.md`](https://github.com/jcreek/PKHeX/blob/main/PKHeX.Web/CONTRIBUTING.md) for how branches, upstream syncs and Core changes work here.

## License

PKHeX and this fork are distributed under the [GNU General Public License v3](https://github.com/jcreek/PKHeX/blob/main/LICENSE). Third-party components and their licenses are listed in [`PKHeX.Web/THIRD-PARTY-NOTICES.md`](https://github.com/jcreek/PKHeX/blob/main/PKHeX.Web/THIRD-PARTY-NOTICES.md).
