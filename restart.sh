#!/bin/sh
set -eu

cd "$(dirname "$0")"

echo "[ARTEX] 正在停止容器..."

# 正常停止，最多等待 20 秒
if ! timeout 20 docker compose stop -t 5 artex postgres; then
    echo "[ARTEX] 停止超時，嘗試強制終止..."
    timeout 10 docker kill artex-artex-1 artex-postgres-1 2>/dev/null || true
fi

echo "[ARTEX] 正在重新啟動..."

# 啟動所有服務，最多等待 120 秒
if ! timeout 120 docker compose up -d; then
    echo "[ARTEX] 啟動失敗或超時！"
    exit 1
fi

echo "[ARTEX] 容器狀態："
timeout 10 docker compose ps || true

echo "[ARTEX] 重啟完成：http://localhost:8787"
