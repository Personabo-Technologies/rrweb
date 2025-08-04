#!/bin/bash

# EasyCodeAI rrweb 发布脚本
# 使用方法: ./scripts/publish-easycodeai.sh

set -e  # 遇到错误时退出

echo "🚀 开始发布 EasyCodeAI 版本的 rrweb..."

# 检查是否在正确的目录
if [ ! -f "package.json" ] || [ ! -f "lerna.json" ]; then
    echo "❌ 错误: 请在 rrweb 项目根目录运行此脚本"
    exit 1
fi

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ 错误: 有未提交的更改，请先提交所有更改"
    git status --short
    exit 1
fi

# 检查是否已登录 npm
if ! npm whoami > /dev/null 2>&1; then
    echo "❌ 错误: 请先登录 npm"
    echo "运行: npm login"
    exit 1
fi

echo "✅ 环境检查通过"

# 安装依赖
echo "📦 安装依赖..."
yarn install

# 运行测试
echo "🧪 运行测试..."
yarn test

# 构建项目
echo "🔨 构建项目..."
yarn build:all

# 创建 changeset
echo "📝 创建 changeset..."
echo "请按照提示选择包和版本类型："
echo "- 选择包: @sentry-internal/rrweb"
echo "- 版本类型: patch (推荐)"
echo "- 描述: Add EasyCodeAI IDE cross-origin iframe detection support"
echo ""
npx changeset

# 应用 changesets
echo "🔄 应用 changesets..."
npx changeset version

# 发布到 npm
echo "📤 发布到 npm..."
npx changeset publish

echo "✅ 发布完成！"
echo ""
echo "📋 发布后检查清单："
echo "1. 检查 npm 包: https://www.npmjs.com/package/@sentry-internal/rrweb"
echo "2. 验证版本号是否正确"
echo "3. 在你的 EasyCodeAI 项目中测试新功能"
echo ""
echo "🎉 恭喜！rrweb 已成功发布，支持 EasyCodeAI IDE！" 