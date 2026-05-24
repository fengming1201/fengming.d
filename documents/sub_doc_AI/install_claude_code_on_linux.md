## step1:install node

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | bash  && sudo apt install -y nodejs
node --version
v20.19.2node --versio
```


## step2:install npm

```bash
sudo apt install npm
```


## step3:install claude code

```bash
sudo npm install -g @anthropic-ai/claude-code

claude --version
2.1.138 (Claude Code)

```
## add deepseek API
# add to ~/.bashrc
```bash

export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
export ANTHROPIC_AUTH_TOKEN=sk-xxxx
export ANTHROPIC_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
export CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash
export CLAUDE_CODE_EFFORT_LEVEL=max
```
