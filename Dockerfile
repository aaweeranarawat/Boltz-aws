FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-pip git && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir "boltz[cuda]" -U
ENV BOLTZ_CACHE=/opt/boltz_cache
RUN mkdir -p /opt/boltz_cache && python3 -c "from boltz.main import download_boltz2; from pathlib import Path; download_boltz2(Path('/opt/boltz_cache'))" || echo "WARN: weight download failed; verify in Boltz docs"
