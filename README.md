# 🎮 NFWC 服务器 — No Flesh Within Chest

7 人联机的 Minecraft Forge 1.19.2 整合包服务器。

## 准备工作

每台电脑都要有的：

- **Java 17** — 运行服务端用
- **No Flesh Within Chest-1.0.2-DIM.zip** — 整合包原文件
- **Minecraft 客户端** — 装了整合包的 PCL / HMCL 等
- **Astral** — 组网工具，所有人都加入同一个房间
- **CustomSkinLoader 模组** — 客户端装，服务器已预装

---

## 开服流程

### 第零步：克隆仓库

```bash
git clone https://github.com/YuZhen203/NFWC-Server.git
cd NFWC-Server
```

### 第一步：准备模组

从 Release 下载 `mods.zip`（约 335 MB）：
```
https://github.com/YuZhen203/NFWC-Server/releases/download/v1.0/mods.zip
```
下载后解压到 `NFWC-Server/mods/` 目录。

### 第二步：放整合包文件

把 `No Flesh Within Chest-1.0.2-DIM.zip` 复制到 `NFWC-Server/` 目录下。

### 第三步：运行 `auto_setup.bat`

双击运行，它自动完成以下 6 步：

```
[1/6] 解压整合包       ← 从 ZIP 提取 config、kubejs 等
[2/6] 检查模组         ← 确认 mods/ 已就绪
[3/6] 删除客户端模组   ← 清理不需要的纯客户端模组
[4/6] 删除客户端脚本   ← 清理 KubeJS 客户端代码
[5/6] 安装 Forge       ← 下载并安装 Forge 43.3.5
[6/6] 应用存档数据     ← 覆盖 world/、server.properties 等
```

### 第四步：同意 EULA

首次启动前必须同意 Minecraft EULA。在 `NFWC-Server/` 目录下找到 `eula.txt`，把 `eula=false` 改为 `eula=true`。

> 注意：`eula.txt` 在第一次双击 `run.bat` 后才会生成。如果还没看到它，先跑一次 `run.bat`，等出现 EULA 报错后关闭，再编辑 `eula.txt`。

### 第五步：启动服务器

双击 `run.bat`。看到 `Done (xxx s)! For help, type "help"` 即启动成功。

### 第六步：连接

1. 开服者打开 Astral，记下自己的虚拟 IP（如 `10.144.144.x`）
2. 所有人 Minecraft → 多人游戏 → 地址填 `开服者IP:25565`

---

## 提交存档（换主机时）

### 交班方（旧主机）

```bash
cd NFWC-Server
git add repack/
git commit -m "更新存档 2026-05-24"
git push
```

### 接手方（新主机）

```bash
git clone https://github.com/YuZhen203/NFWC-Server.git
cd NFWC-Server
# 下载 mods.zip 解压到 mods/
# 放入 No Flesh Within Chest-1.0.2-DIM.zip
auto_setup.bat
# 同意 EULA → 双击 run.bat → 完成
```

---

## 存档迁移（单人→服务器）

```bash
# 把你的单人存档 saves/<世界名> 复制到 NFWC-Server/repack/world
# 然后运行 auto_setup.bat 的第 6 步会自动应用
```


---

## 日常流程（仅更新存档）

首次配置完成后（已跑过 `auto_setup.bat`），后续每天的操作很简单。

### 玩完后提交存档

```bash
cd NFWC-Server
:: 把当前世界复制到 repack 目录
xcopy /e /i /q /y world repack\world
:: 推送到 GitHub
git add repack/
git commit -m "更新存档"
git push
```

### 新主机接手

```bash
cd NFWC-Server
git pull
:: 直接启动，mods/、config/、libraries/ 都在，不需要跑 auto_setup
run.bat
```

> 前提：接手方的 `NFWC-Server/` 目录之前已经完整跑过一次 `auto_setup.bat`，`mods/`、`config/`、`libraries/` 等都已存在。如果是在一台从来没有建过服务器的电脑上接手，需要走完整的开服流程。

---

## 目录说明

```
NFWC-Server/
├── auto_setup.bat       ← 一键配置脚本
├── repack/              ← 存档数据（推送到 Git）
│   ├── world/           ← 世界存档
│   ├── server.properties← 服务器配置
│   ├── ops.json         ← 管理员
│   └── ...
├── mods/                ← 手动下载，脚本检查
├── config/ kubejs/ ...  ← 脚本生成
├── .gitignore .gitattributes README.md
└── run.bat              ← Forge 安装器生成
```

---

## 常见问题

**Q: 别人连不上？** 检查 Astral 同一房间、防火墙 25565 端口、`online-mode=false`。

**Q: 模组报错？** 确认 `mods.zip` 是 Release 的最新版，重新解压覆盖。

**Q: 物品丢失？** 角色按 UUID 绑定，确认 `repack/world/playerdata/` 里有对应玩家的 `.dat` 文件。
