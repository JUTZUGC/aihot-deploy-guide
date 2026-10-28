# AIHOT 一键部署指南

> 第三方部署指南 · 非 AIHOT 官方仓库。官方项目：[KKKKhazix/AIHOT](https://github.com/KKKKhazix/AIHOT)
> 内容来自官方文档（2026-10-28）。项目迭代快，请以[官方文档](https://github.com/KKKKhazix/AIHOT/blob/main/README.md)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用自己配数据库和抓取流程，让百度搭子把 AIHOT 跑起来，打开就能看当天精选。

⚠️ 需要 Docker、Node.js 24 和一个 OpenAI 兼容的模型 API Key。首次启动一两分钟后才有内容，首批资料处理约需半小时。站点与后台默认只监听本机 3000 端口，公网部署要自行加反向代理与 HTTPS。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/aihot-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会克隆仓库、生成 .env、启动 Docker Compose，并在本机 3000 端口打开站点，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:3000](http://127.0.0.1:3000)，按官方引导完成初始化配置。

## AIHOT 是什么？

AIHOT 是开源的8.8k stars，MIT，自己找热点、自己写日报的行业热点站框架（协议：MIT，<img src="https://img.shields.io/github/stars/KKKKhazix/AIHOT?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

每天从 RSS、网页、JSON、X、公众号等信源采集资料，用模型预筛、两次独立评分、写标题摘要，再把同一事件聚簇并按来源热度排序，自动生成日报、周报和月报。

- 六种信源：RSS、网页列表、JSON 接口、X 账号、公众号与外部推送
- 精选流程：预筛 + 两次独立评分，提示词与入选门槛全部可改
- 事件聚簇：同一件事只出现一次，后续进展挂在同一事件下
- 热点排行：48 小时内按独立来源计热度，重复抓取不重复计数
- 自动出刊：日报、周报、月报，出刊时间可在 site/site.ts 调整
- 对外出口：RSS、公开 API、MCP、llms.txt，人与 Agent 共用同一份内容

（来源：[官方仓库](https://github.com/KKKKhazix/AIHOT)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 8.8k stars | 近期增长最快的自托管热点站框架之一 |
| 流程完整 | 采集、预筛、评分、写作、聚簇、出刊一条链路 |
| 提示词全公开 | 行业 KnowHow 直接改文件，不用改代码 |
| 多出口 | RSS、API、MCP、llms.txt 都能接 |
| Docker Compose | 一条命令拉起站点、后台与 PostgreSQL |
| MIT | 可自建、可二开 |

| 需要注意 | 说明 |
|---|---|
| 需要模型 Key | 不接模型就只能跑空站 |
| 需要 Node.js 24 | 只用来生成配置，版本不够会直接失败 |
| 首次处理慢 | 首批资料约半小时才成刊 |
| 大陆网络要配代理 | 抓取海外信源与模型调用都可能受影响 |
| 不是通用 CMS | 从线上站点导出，改动要跟着仓库结构走 |

> 以上基于官方文档与社区反馈整理（2026-10-28），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/KKKKhazix/AIHOT.git myhot
cd myhot
node -e "const m=+process.versions.node.split('.')[0]; if(m<24){console.error('需要 Node.js 24 或更高');process.exit(1)}"
read -r -p "请输入 OpenAI 兼容模型 API Key: " LLM_KEY
node scripts/init-env.ts --llm-key "$LLM_KEY"
docker compose up -d --build
```

启动后浏览器访问 [http://127.0.0.1:3000](http://127.0.0.1:3000)（管理面板）。（来源：[https://github.com/KKKKhazix/AIHOT#跑起来](https://github.com/KKKKhazix/AIHOT#跑起来)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 Docker Compose 步骤、Node.js 24 与模型 Key 要求 | 已核对 2026-10-28 |
| 仓库无 Release 二进制资产，部署依赖源码与 Docker | 已核对 2026-10-28 |
| 未实测部署（需要模型 API Key 与 Docker 环境） | 说明 2026-10-28 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-28 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

AIHOT 站点自带 MCP、RSS 与公开 API 出口，部署后可在 /agent 页面复制接入方式；本仓库的 MCP 只提供部署步骤、模型配置与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-28）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\aihot-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 启动之后

1. 打开 [http://127.0.0.1:3000](http://127.0.0.1:3000) 看首页精选
2. 后台在 [http://127.0.0.1:3000/admin](http://127.0.0.1:3000/admin)，密码在 `.env` 的 `ADMIN_PASSWORD`
3. 一两分钟后开始有内容，首批资料处理约半小时
4. 在后台的信源管理里试抓、改分类，或替换 `industry/sources.json`

### 改成你的行业

站名、分类、信源、评分提示词都在 `site/` 与 `industry/` 两个目录：

| 文件 | 改什么 |
|---|---|
| `site/site.ts` | 站名、行业词、出刊时间、首页文案 |
| `industry/sources.json` | 首次启动时导入的信源 |
| `industry/prompts/` | 精选标准与写作要求 |
| `industry/selection.ts` | 入选门槛 |

改完执行 `docker compose up -d --build` 重新构建。

### 维护

- 更新：`git pull` 后重新 `docker compose up -d --build`
- 备份：备份 `.env` 与 Docker 数据卷
- 模型 Key 只写在 `.env`，不要提交到仓库

> ⚠️ 首次跑起来会调用模型，按量计费；先在后台设好预算熔断，再放量抓取。

## 常见坑

- Node 版本过低：init-env 需要 Node.js 24，先升级再执行
- docker compose 起不来：确认 Docker Desktop 正在运行，且当前目录是 myhot
- 页面能开但一直没有内容：先在后台试抓一个信源，确认模型 Key 与网络都通
- 模型 401：检查 .env 的 LLM_BASE_URL、LLM_MODEL 与 LLM_API_KEY 是否匹配
- 出刊时间不对：改 site/site.ts 的 EDITION_TIMES 后重新构建
- 公网访问不了：默认只监听本机 3000，需要自己做反向代理与 HTTPS
- 成本失控：先在后台配置预算熔断，再增加信源与抓取频率

## 免责声明

本仓库为第三方指南，与 AIHOT 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-28），项目迭代快，请以[官方文档](https://github.com/KKKKhazix/AIHOT/blob/main/README.md)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
