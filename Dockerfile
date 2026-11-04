# The stdio MCP server in a container: Docker Hub (overview in DOCKER.md) and directories that start and inspect it (Glama).
# No dependencies to install; tools/list answers from the bundled tools when offline.
FROM node:22-alpine
LABEL org.opencontainers.image.title="SFXMint MCP server" \
      org.opencontainers.image.description="Free CC0 sound effects for coding agents: search and fetch them by event or description over MCP" \
      org.opencontainers.image.url="https://sfxmint.com" \
      org.opencontainers.image.documentation="https://sfxmint.com/api/docs" \
      org.opencontainers.image.source="https://github.com/sfxmint/sfxmint-npm" \
      org.opencontainers.image.licenses="MIT" \
      io.modelcontextprotocol.server.name="com.sfxmint/sounds"
WORKDIR /app
COPY package.json LICENSE ./
COPY bin ./bin
COPY src ./src
USER node
ENTRYPOINT ["node", "bin/sfxmint.mjs", "mcp"]
