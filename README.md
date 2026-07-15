# JP AI Server

Installation reproductible pour Ubuntu Server 26.04 LTS, 3× Tesla V100, TrueNAS NFS, llama.cpp, Open WebUI et SearXNG.

## Choix retenus

- Qwen General
- GLM Heretic Code
- DeepSeek Reasoning
- Qwen Code Agent
- un seul gros modèle chargé à la fois (`--models-max 1`)
- SearXNG activé
- Codebase Memory MCP optionnel
- aucun n8n ni lecteur PDF pour le moment

## Installation

```bash
git clone https://github.com/secretman28/JP-AI-Server.git
cd JP-AI-Server
chmod +x install.sh
./install.sh
sudo reboot
```

## Après reboot

```bash
jp doctor
jp status
jp models
```

## Télécharger les modèles

```bash
jp pull qwen
jp pull glm
jp pull deepseek
jp pull coder
```

Commence par Qwen seulement. Les autres peuvent être téléchargés plus tard.

## Interfaces

- Open WebUI: `http://IP_VM:3000`
- SearXNG: `http://IP_VM:8080`
- API llama.cpp: `http://IP_VM:11434/v1`

## Stockage TrueNAS

Le partage NFS doit déjà être monté et écrivable sur `/mnt/AI`.
