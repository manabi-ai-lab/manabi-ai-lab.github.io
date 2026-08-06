#!/bin/sh
# GitHub Release を作って高画質MP4を添付する。
#
#   sh scripts/create-release.sh "放課後トークルーム_1時間_高画質版.mp4"
#
# アップロード前に必ず SHA-256 を照合する。一致しなければ何もしない。
# 再エンコードは絶対にしない。

set -e

REPO="manabi-ai-lab/manabi-bgm"
TAG="v1.0.0-after-school-talk-room"
TITLE="放課後トークルーム — 1時間BGM"
EXPECTED="118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc"
EXPECTED_SIZE=679926904

FILE="${1:-放課後トークルーム_1時間_高画質版.mp4}"

# リポジトリのルートを推定（このスクリプトの1つ上）
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
NOTES="$ROOT/templates/RELEASE_NOTES.md"

if [ ! -f "$FILE" ]; then
  echo "エラー: ファイルがありません: $FILE" >&2
  echo "先に docs/RESTORE.md の手順で復元してください。" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "エラー: GitHub CLI (gh) が見つかりません。" >&2
  echo "  インストール: https://cli.github.com/" >&2
  echo "  または docs/RELEASE.md の「B. ブラウザで作る」に従ってください。" >&2
  exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
  ACTUAL=$(sha256sum "$FILE" | cut -d' ' -f1)
elif command -v shasum >/dev/null 2>&1; then
  ACTUAL=$(shasum -a 256 "$FILE" | cut -d' ' -f1)
else
  echo "エラー: sha256sum も shasum も見つかりません。照合できないので中止します。" >&2
  exit 1
fi
SIZE=$(wc -c < "$FILE" | tr -d ' ')

echo "ファイル : $FILE"
echo "サイズ   : $SIZE バイト（期待: $EXPECTED_SIZE）"
echo "SHA-256  : $ACTUAL"
echo "期待値   : $EXPECTED"
echo ""

if [ "$ACTUAL" != "$EXPECTED" ] || [ "$SIZE" != "$EXPECTED_SIZE" ]; then
  echo "❌ 一致しません。アップロードを中止しました。" >&2
  echo "   低画質版（スマホDrive版）を掴んでいないか確認してください。" >&2
  echo "   docs/RESTORE.md を参照。" >&2
  exit 1
fi
echo "✅ 照合OK。Release を作成します。"
echo ""

# gh のログイン確認（未ログインなら案内して終了：パスワードは絶対に聞かない）
if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI が未ログインです。次を実行してブラウザでログインしてください。" >&2
  echo "  gh auth login" >&2
  exit 1
fi

if [ -f "$NOTES" ]; then
  gh release create "$TAG" "$FILE" \
    --repo "$REPO" \
    --title "$TITLE" \
    --notes-file "$NOTES"
else
  gh release create "$TAG" "$FILE" \
    --repo "$REPO" \
    --title "$TITLE" \
    --notes "『放課後トークルーム』1時間・高画質版。SHA-256: $EXPECTED"
fi

echo ""
echo "✅ 完了: https://github.com/$REPO/releases/tag/$TAG"
echo ""
echo "次にやること："
echo "  1. Release からダウンロードし直して SHA-256 を再照合する（docs/RELEASE.md）"
echo "  2. tracks/after-school-talk-room/CHECKSUMS.md の照合記録に追記する"
