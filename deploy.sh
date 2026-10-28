#!/usr/bin/env bash
set -euo pipefail
# AIHOT 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/KKKKhazix/AIHOT/blob/main/README.md
# 更新日期：2026-10-28
# 类型：docker
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "需要先安装 Docker"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "需要 Docker Compose v2（docker compose 子命令）"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "需要先安装 Node.js"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/KKKKhazix/AIHOT.git myhot
cd myhot
node -e "const m=+process.versions.node.split('.')[0]; if(m<24){console.error('需要 Node.js 24 或更高');process.exit(1)}"
read -r -p "请输入 OpenAI 兼容模型 API Key: " LLM_KEY
node scripts/init-env.ts --llm-key "$LLM_KEY"
docker compose up -d --build

echo ""
if command -v curl >/dev/null 2>&1; then
  echo "等待服务启动：http://127.0.0.1:3000"
  ready=0
  for _ in $(seq 1 30); do
    if curl -sS -o /dev/null "http://127.0.0.1:3000" 2>/dev/null; then ready=1; break; fi
    sleep 2
  done
  if [ "$ready" = "1" ]; then
    echo "服务已就绪"
  else
    echo "警告：60 秒内未探测到 http://127.0.0.1:3000，请手动打开确认或查看日志"
    exit 1
  fi
else
  echo "未检测到 curl，跳过启动探测；请手动访问 http://127.0.0.1:3000 确认"
fi
echo "部署完成：浏览器打开 http://127.0.0.1:3000，后台在 /admin，管理员密码在 .env 的 ADMIN_PASSWORD"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/KKKKhazix/AIHOT/blob/main/README.md"
