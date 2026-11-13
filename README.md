# sfxmint

Put free CC0 sound effects into a web app or game by naming the event, not by hunting through a library.

```bash
npx sfxmint add coin jump hit
```

```
  3 files → public/sounds/ (66 KB)

  coin.mp3               2.0s   Double-Chime 8-Bit Coin Pickup 13
  jump.mp3               1.0s   Smooth 8-Bit Video Game Jump 01
  hit.mp3                1.0s   Cracking Punch Impact 25
```

No API key, signup or account to try. Every file is [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/): commercial use, no attribution, no strings.

## Then play them

```js
import { createSoundboard } from "sfxmint";
import manifest from "./public/sounds/sounds.json";

const sfx = createSoundboard(manifest, { preload: ["coin"] });

button.onclick = () => sfx.play("coin");
```

That's the whole API surface you need. `sfx.setMuted()` toggles and remembers the preference; `sfx.stop()` cuts everything off.

## Why not just `new Audio(url)`

Finding sound files is the easy part. These three are what actually break:

- **Browsers block audio until the first user gesture.** A cue triggered on mount silently rejects, and on iOS an `HTMLAudioElement` stays locked unless that exact element was started inside a gesture — so cloning one for overlapping playback fails on phones. This package runs on Web Audio and resumes a single context on the first gesture, which covers every later cue.
- **Repeated cues cut each other off.** `audio.currentTime = 0` restarts the one element you have, so a fast second click truncates the first. Each `play()` here gets its own source node and they overlap.
- **A mute toggle has to survive a reload.** Persisted to `localStorage`, wrapped so private mode doesn't throw.

Safe to import during SSR — every method is inert until it runs in a browser.

## CLI

```bash
npx sfxmint add coin jump hit         # one file per role
npx sfxmint add --set platformer      # a whole kit; takes SFXMINT_API_KEY, or the first 5 with no key
npx sfxmint search "glass break"      # free text when no role fits
npx sfxmint list roles                # browse (or: list sets)
npx sfxmint mcp                       # the library as a local MCP server (below)
```

| Option | |
|---|---|
| `--out <dir>` | where files land (default `public/sounds`) |
| `--format <fmt>` | `mp3` (default, free), `ogg` (free, older sounds only), `wav` (takes a download pack's key in `SFXMINT_API_KEY`: lossless, no MP3 delay at the start, clean loops) |
| `--style <style>` | `balanced` (default), `crisp`, `soft`, `spacious` — re-ranks a role's family by measured acoustics |
| `--force` | replace an existing file that has different content |
| `--json` | machine-readable output |

Roles are named by what they are for — `click`, `purchase-success`, `error`, `coin`, `jump`, `explosion`, `dialogue-blip`, `notification` — and aliases work, so `button-click` or `tap` finds `click`. Around 200 of them; `sfxmint list roles` prints the current set.

Running `add` again keeps what is already there, so you can collect cues as you build.

## What gets written

```
public/sounds/
  coin.mp3
  sounds.json     ← role → file, plus source URL, checksum, duration, license
  SOUNDS.md       ← the same list as a table, each sound linked to its page
  LICENSE.txt
```

Every download is checked against the byte count and SHA-256 the API reports; a mismatch is an error, not a warning. Nothing overwrites an existing file with different content unless you pass `--force`.

## MCP server for coding agents

```bash
npx -y sfxmint mcp
```

The same library as a local [MCP](https://modelcontextprotocol.io) server over stdio, so Claude Code, Cursor, Cline or any other MCP client can pick cues while it writes your code. Four tools, free to try with no key:

| Tool | For |
|---|---|
| `get_role_sound` | one named event: `click`, `coin`, `purchase-success`, `error`… |
| `get_sound_set` | a whole kit for one product, one sound per role |
| `search_sounds` | a description, hard limits (duration, loop, format), or a gap |
| `get_sound` | exact file metadata for one slug: URLs, SHA-256, measured acoustics |

Names, arguments and results are those of the remote server at `https://sfxmint.com/mcp`, which each call goes to; the process just speaks stdio for clients that want a command. It needs Node 20+ and network access to sfxmint.com.

**Claude Code**

```bash
claude mcp add sfxmint -- npx -y sfxmint mcp
```

**Cursor** (`~/.cursor/mcp.json`, or `.cursor/mcp.json` in a project), **Cline** (MCP Servers → Configure MCP Servers), **Claude Desktop**, **Windsurf** and other clients take the same block:

```json
{
  "mcpServers": {
    "sfxmint": {
      "command": "npx",
      "args": ["-y", "sfxmint", "mcp"]
    }
  }
}
```

On Windows, if the client cannot start `npx` directly, use `"command": "cmd"` with `"args": ["/c", "npx", "-y", "sfxmint", "mcp"]`.

With `"env": { "SFXMINT_API_KEY": "sfx_live_…" }` in that block, every call carries the key. With or without one, only the free library tools are listed. Clients that connect to remote servers can skip the local process and add `https://sfxmint.com/mcp` directly.

## Honest limits

- **The library is AI-generated** or procedurally synthesized, then loudness-normalized and QC'd. Foley purists will hear it. Nothing is scraped or re-hosted from other libraries.
- **No music, no voice, no speech.** Sound effects only.
- **A file check is not a listening check.** The checksum proves you got the bytes the API described. Whether a cue suits your scene is something only a listen in context can tell.
- **Use has an allowance.** Without a key: 20 lookups and tool calls and 5 different sound downloads a day per network (a second format or a retry of one is not counted again). Set `SFXMINT_API_KEY` to a free account's key for 100 calls and 20 downloads a day (300 downloads a month); a download pack on the account removes the limits and adds WAV for 30 days. Free use is MP3: without a pack a WAV answers `402 wav_needs_pack` with the `mp3_url` to use instead, though a browser can still play or hotlink it in a page. Past a limit a file answers `429 download_limit` and a call `429 call_limit`; the CLI keeps the files it already got, stops, and prints the limit message and what is left. Listening in a browser is never counted, and the manifest keeps each file's permanent address, never a signed one.
- **A set can be short a role, and a role can have no file that passes its checks yet.** Either way the CLI downloads the rest and tells you which event has no file yet, rather than failing the whole kit or leaving you to discover it in production.

## Also available

The same library as a remote [MCP server](https://github.com/sfxmint/sfxmint-mcp) (`https://sfxmint.com/mcp`), or a plain [JSON API](https://sfxmint.com/api/docs), free to try with no key.

**When the library has no fit**, list the sound as missing in your project. SFXMint no longer makes new sounds; new ones join the library from what people search for. An account that already has a plan or credits can still use them in AI Studio on the website, or with its API key: `POST https://sfxmint.com/api/v1/orders`. Any other generation request answers `410 generation_closed`. The `add` and `search` commands do not generate; they need no key for up to 5 sounds a day, and send `SFXMINT_API_KEY` with API requests only when it is set, so they show in your usage.

## License

This package: MIT. The sound files it downloads: CC0 1.0.
