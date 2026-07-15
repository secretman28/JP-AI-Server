# JP AI Server v3

Installateur modulaire et reprenable pour Ubuntu Server 26.04, 3x Tesla V100,
TrueNAS NFS, llama.cpp, Open WebUI, SearXNG et Codebase Memory MCP.

## Installation

```bash
git clone git@github.com:secretman28/JP-AI-Server.git
cd JP-AI-Server
cp config/server.env.example config/server.env
nano config/server.env
chmod +x install.sh
./install.sh
```

Chaque étape terminée est enregistrée dans `/var/lib/jp-ai/state`. Relancer
`./install.sh` reprend automatiquement après la dernière étape réussie.

## Commandes

```bash
jp doctor
jp status
jp models
jp pull qwen
jp pull glm
jp pull deepseek
jp pull coder
jp load qwen
jp unload qwen
jp benchmark
jp backup
jp update
jp install-codebase-memory
```

Le routeur llama.cpp utilise `--models-max 1`: un seul gros modèle est chargé
en VRAM à la fois.
