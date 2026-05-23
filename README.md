# 🎮 NFWC 服务器 — No Flesh Within Chest

7 人联机的 Minecraft Forge 1.19.2 整合包服务器。

## 目录

- [准备工作](#准备工作)
- [开服流程](#开服流程)
- [换主机时的操作](#换主机时的操作)
- [结束游戏后提交存档](#结束游戏后提交存档)
- [目录结构说明](#目录结构说明)
- [常见问题](#常见问题)

---

## 准备工作

### 每台电脑都要有的东西

| 项目 | 说明 |
|------|------|
| **Java 17** | 运行服务端用，OpenJDK 或任何 JDK 17 均可 |
| **No Flesh Within Chest-1.0.2-DIM.zip** | 整合包原文件，7 个人手上都有 |
| **Minecraft 客户端** | 安装了整合包的 PCL / HMCL / 官方启动器 |
| **Astral** | 组网工具，所有人都装并加入同一个房间 |
| **CustomSkinLoader 模组** | 皮肤显示用（非必须，想有皮肤就装） |

### Astral 组网

1. 每个人启动 Astral，加入同一个房间
2. 开服的人记下自己的 Astral 虚拟 IP（例如 `10.144.144.x`）
3. 其他人用 `开服者虚拟IP:25565` 连接

---

## 开服流程

### 第一步：拉取仓库

```bash
git clone https://github.com/YuZhen203/NFWC-Server.git
cd NFWC-Server
```

### 第二步：放整合包文件

把 `No Flesh Within Chest-1.0.2-DIM.zip` 复制到 `NFWC-Server/` 目录下。

### 第三步：运行 `auto_setup.bat`

双击 `auto_setup.bat`，它会自动完成：

```
[1/6] 解压整合包       ← 从 ZIP 提取 mods、config、kubejs 等
[2/6] 复制模组和配置    ← 覆盖到正确位置
[3/6] 删除客户端模组    ← 去掉 31 个纯客户端模组（Oculus、EMI 等）
[4/6] 删除客户端脚本    ← 去掉 KubeJS 客户端脚本
[5/6] 安装 Forge        ← 下载并安装 Forge 43.3.5
[6/6] 应用游戏存档      ← 覆盖 world/、server.properties 等
```

> ⚠️ 脚本会联网下载 Forge 安装器（约 7MB）和 Minecraft 服务端（约 48MB），需保持联网。

### 第四步：同意 EULA

首次启动前需同意 Minecraft EULA。在 `NFWC-Server/` 目录下找到 `eula.txt`，把 `eula=false` 改为 `eula=true` 并保存。

### 第五步：启动服务器

**方式一：双击 `run.bat`**

最简单，一个命令行窗口里可以看到服务端日志。

**方式二：用 Sea Lantern**

如果安装了 Sea Lantern（海晶灯），导入 `NFWC-Server/` 目录即可使用 GUI 管理。

启动后看到 `Done (xxx s)! For help, type "help"` 即表示服务器运行成功。

### 第六步：连接

1. 开服者打开 Astral，找到自己的虚拟 IP
2. 所有人打开 Minecraft → 多人游戏 → 添加服务器
3. 地址填 `开服者AstralIP:25565`（例如 `10.144.144.5:25565`）

---

## 换主机时的操作

当开服的人要下线，由另一人接手：

### 接手方（新主机）

```bash
# 1. 拉取最新存档
git clone https://github.com/YuZhen203/NFWC-Server.git
cd NFWC-Server

# 2. 放入整合包 ZIP
cp /path/to/No\ Flesh\ Within\ Chest-1.0.2-DIM.zip .

# 3. 运行配置脚本
auto_setup.bat

# 4. 同意 EULA
# 编辑 eula.txt，改为 eula=true

# 5. 启动服务器
run.bat
```

> 全程约 5 分钟，不需要手动配置任何东西。

### 交班方（旧主机）

在结束游戏后运行 `repack/release.bat`，它会自动：

1. 将最新的 `world/`、`server.properties`、`ops.json` 等打包到 `repack/` 目录
2. 提交并推送到 GitHub

> 如果 `release.bat` 推送失败，也可以手动执行：
> ```bash
> cd NFWC-Server
> git add repack/
> git commit -m "更新存档 2026-05-24"
> git push
> ```

---

## 目录结构说明

```
NFWC-Server/
├── auto_setup.bat       ← 一键配置脚本（核心）
├── repack/              ← 存档数据目录（推送的核心内容）
│   ├── world/           ← 世界存档（建筑、玩家数据、物品）
│   ├── server.properties← 服务器配置（视距、难度、端口等）
│   ├── ops.json         ← 管理员名单
│   ├── whitelist.json   ← 白名单
│   ├── usercache.json   ← 用户名-UUID 映射
│   ├── banned-*.json    ← 封禁列表
│   └── release.bat      ← 存档推送脚本
├── .gitignore           ← 忽略运行时文件
├── README.md            ← 本文件
│
├── mods/                ← 运行时生成（auto_setup.bat 创建）
├── config/              ← 运行时生成
├── kubejs/              ← 运行时生成
├── defaultconfigs/      ← 运行时生成
├── libraries/           ← 运行时生成（Forge 依赖）
├── world/               ← 运行时生成（auto_setup.bat 从 repack/ 复制）
└── run.bat              ← 运行时生成（Forge 安装器生成）
```

> **不推送到 GitHub 的内容**：`mods/`、`config/`、`kubejs/`、`libraries/`、`server.jar`、`logs/`、`crash-reports/`。这些由 `auto_setup.bat` 自动生成。

---

## 常见问题

### Q: 为什么把客户端模组删了？

Oculus（光影）、EMI（物品管理器）、Jade（信息显示）等 31 个模组是纯客户端的。服务端加载它们会直接崩溃。删除它们不影响游戏内容和世界数据。

### Q: 我的物品/背包怎么丢了？

角色物品按 UUID 绑定。如果换主机后背包空了，请联系群主恢复或使用 `/give` 命令补发。

### Q: 可以用自己的世界存档吗？

可以。把自己的 `saves/世界名/` 文件夹重命名为 `world`，替换 `repack/world/` 即可。

### Q: 别人连不上服务器？

- 确认所有人都连在同一个 Astral 房间
- 确认开服者 Astral 虚拟 IP 正确
- 确认开服者没有关闭防火墙端口 25565
- 在服务器控制台输入 `whitelist off` 确保未开启白名单

### Q: 服务端显示 Done 了但我连不上？

- 检查是否在同一个 Astral 房间
- 检杝 `server.properties` 中 `online-mode=false` 是否已设置
- 试试 `localhost:25565` 能否连接（仅开服者自己测试用）
