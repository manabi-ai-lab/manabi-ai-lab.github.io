#!/bin/sh
# 放課後トークルーム 高画質版：復元 + SHA-256照合
#
# 使い方：8個の part-XX.bin と同じフォルダに置いて  sh restore-and-verify.sh
#
# 再エンコードは一切しない。単純なバイナリ連結のみ。

set -e

BASE="after-school-talk-room-one-hour-youtube"
OUT="放課後トークルーム_1時間_高画質版.mp4"
EXPECTED="118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc"
EXPECTED_SIZE=679926904

# パーツごとの期待ハッシュ（PARTS_SHA256.txt と同じ）
PART_HASHES="\
738a9fcf8427dc22e679c568311f3d58121d30a69ee75082d90b523c7422d658
7471b94f39e82e177269efc720b625c7594c06a68ad032cf005131b2424422ba
4d8c880af1a2bc8ee21da87c28f91d6e0159f59fdeda4c4bb7d65bfa742c8d39
29bf28f6b3e58fa559ec24d690ded1c70e1fa9e9bc4e58abf5368a864c8119f6
0f2f6aed547125c5cd4e74cdc5882acf7416f602f6723ad2233d13bdf031c438
21952dfbbb9a306743211ea86ee29729f53931ba64081f0b10696040d5173bd8
5ed5a041b8aa425072a136c977f897f3f372e1498ebb875088855ec72d56fde9
637d25887bbc0c3d97d4c5cbfbc54a430a9b10012d540c39793916e679cb7eb9"

# --- sha256 コマンドを見つける -------------------------------------------
if command -v sha256sum >/dev/null 2>&1; then
  sha256of() { sha256sum "$1" | cut -d' ' -f1; }
elif command -v shasum >/dev/null 2>&1; then
  sha256of() { shasum -a 256 "$1" | cut -d' ' -f1; }
else
  echo "エラー: sha256sum も shasum も見つかりません。" >&2
  exit 1
fi

sizeof() { wc -c < "$1" | tr -d ' '; }

# --- 1. パーツの存在確認 --------------------------------------------------
echo "[1/4] パーツを確認しています..."
missing=0
i=0
while [ $i -le 7 ]; do
  f="${BASE}.part-0${i}.bin"
  if [ ! -f "$f" ]; then
    echo "  ✗ 見つかりません: $f"
    missing=1
  fi
  i=$((i + 1))
done
if [ $missing -eq 1 ]; then
  echo ""
  echo "パーツが足りません。Drive から取り直してください。" >&2
  echo "https://drive.google.com/drive/folders/1BwpEpgVjfd5aLJRp1fL8SwKiKnxt-Hpp" >&2
  exit 1
fi

# --- 2. パーツ個別のハッシュ照合 ------------------------------------------
echo "[2/4] パーツのSHA-256を照合しています（8個）..."
bad=0
i=0
for expect in $PART_HASHES; do
  f="${BASE}.part-0${i}.bin"
  actual=$(sha256of "$f")
  if [ "$actual" = "$expect" ]; then
    echo "  ✓ part-0${i}"
  else
    echo "  ✗ part-0${i} が一致しません（サイズ $(sizeof "$f") バイト）"
    echo "      期待: $expect"
    echo "      実際: $actual"
    bad=1
  fi
  i=$((i + 1))
done
if [ $bad -eq 1 ]; then
  echo ""
  echo "壊れたパーツがあります。上の ✗ のファイルだけ Drive から取り直してください。" >&2
  exit 1
fi

# --- 3. 結合 --------------------------------------------------------------
echo "[3/4] 結合しています（再エンコードなし）..."
cat "${BASE}.part-00.bin" \
    "${BASE}.part-01.bin" \
    "${BASE}.part-02.bin" \
    "${BASE}.part-03.bin" \
    "${BASE}.part-04.bin" \
    "${BASE}.part-05.bin" \
    "${BASE}.part-06.bin" \
    "${BASE}.part-07.bin" \
    > "$OUT"

# --- 4. 原本ハッシュ照合 --------------------------------------------------
echo "[4/4] 復元後のSHA-256を照合しています..."
actual_size=$(sizeof "$OUT")
actual=$(sha256of "$OUT")

echo ""
echo "  ファイル : $OUT"
echo "  サイズ   : $actual_size バイト（期待: $EXPECTED_SIZE）"
echo "  SHA-256  : $actual"
echo "  期待値   : $EXPECTED"
echo ""

if [ "$actual" = "$EXPECTED" ] && [ "$actual_size" = "$EXPECTED_SIZE" ]; then
  echo "✅ 完全に一致しました。高画質版の復元に成功しています。"
  echo "   このファイルをそのまま YouTube と GitHub Release に使ってください。"
  exit 0
else
  echo "❌ 一致しません。" >&2
  echo "   再エンコードせず、docs/RESTORE.md の「4. 一致しなかったとき」を読んでください。" >&2
  exit 1
fi
