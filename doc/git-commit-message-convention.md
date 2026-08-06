# Git Commit Message 规范

## 推荐格式

SwiftSound 推荐使用 Conventional Commits 风格：

```text
<type>(<scope>): <subject>
```

例如：

```text
feat(mv): add MV page
```

其中：

- `type` 表示变更类型。
- `scope` 表示影响的功能模块，可选，例如 `mv`、`player` 或 `theme`。
- `subject` 简洁描述本次变更，使用动词开头，不加句号。

## 常用类型

| 类型 | 用途 |
| --- | --- |
| `feat` | 新增功能 |
| `fix` | 修复问题 |
| `refactor` | 重构代码，不改变外部行为 |
| `style` | 调整格式或视觉样式，不改变功能逻辑 |
| `docs` | 修改文档 |
| `test` | 新增或修改测试 |
| `perf` | 性能优化 |
| `build` | 修改构建配置或依赖 |
| `ci` | 修改持续集成配置 |
| `chore` | 其他维护性变更 |

## SwiftSound 示例

```text
feat(mv): add MV detail page
fix(mv): handle missing MV URL
refactor(player): extract playback state
style(home): adjust sidebar spacing
docs: document commit message convention
chore: update Xcode project settings
```

如果一次提交包含多个文件，应确保它们服务于同一个目的。例如，新增 MV 页面及其路由、数据请求和视图模型可以放在同一个功能提交中；与该功能无关的格式调整应拆分到其他提交。

## 书写建议

- 优先使用 `feat`，不要使用非标准的 `feature`。
- `scope` 统一使用小写，例如写作 `mv`，而不是 `MV`。
- 使用祈使语气，例如 `add`、`fix`、`update`，不要写成 `added` 或 `fixed`。
- 避免使用含义模糊的描述，例如 `update code` 或 `fix bug`。
- 标题尽量简短；需要补充背景时，在标题下面增加正文。
- 一个提交尽量只完成一个逻辑目的，便于代码审查、回滚和查找历史。
