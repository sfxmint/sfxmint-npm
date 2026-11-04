# SFXMint MCP server

Lets Claude Code, Cursor, Cline and other MCP clients find sound effects while they write your code. It serves [SFXMint](https://sfxmint.com), a library of 9,400+ AI-generated and procedurally synthesized sound effects for games and apps. Every library file is [CC0 1.0](https://sfxmint.com/license): commercial use, no attribution.

No API key needed. The container speaks MCP over stdio and needs network access to sfxmint.com.

```bash
docker run -i --rm flreey/sfxmint-mcp
```

## Add it to a client

**Claude Code**

```bash
claude mcp add sfxmint -- docker run -i --rm flreey/sfxmint-mcp
```

**Cursor, Cline, Claude Desktop, Windsurf** and other clients take the same block:

```json
{
  "mcpServers": {
    "sfxmint": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "flreey/sfxmint-mcp"]
    }
  }
}
```

## Tools

| Tool | For |
|---|---|
| `get_role_sound` | one named event: `click`, `coin`, `purchase-success`, `error` |
| `get_sound_set` | a whole kit for one product, one sound per role |
| `search_sounds` | a description, hard limits (duration, loop, format), or a gap |
| `get_sound` | exact file metadata for one sound: URLs, SHA-256, measured acoustics |

Each call goes to the public endpoint at `https://sfxmint.com/mcp`, so results are the same as the remote server's.

## Limits and API key

File downloads without a key: 20 different sounds a day per network. A free account's API key raises that to 50 a day, and any purchase removes the limit for 30 days. Listening in a browser is never counted.

To use a key, which also adds the account's generation tools, pass it to the container:

```bash
docker run -i --rm -e SFXMINT_API_KEY flreey/sfxmint-mcp
```

Keys are on the [API keys page](https://sfxmint.com/dashboard/keys); plans are on the [pricing page](https://sfxmint.com/pricing).

## Links

- [Sound effects library](https://sfxmint.com)
- [API and MCP docs](https://sfxmint.com/api/docs)
- [License](https://sfxmint.com/license)
- [Source](https://github.com/sfxmint/sfxmint-npm)

The server code is MIT. The sounds are CC0 1.0.
