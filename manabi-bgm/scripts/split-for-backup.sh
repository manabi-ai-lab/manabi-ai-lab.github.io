#!/bin/sh
# 高画質MP4を90MiBずつの .bin に分割し、復元一式（スクリプト＋ハッシュ）を作る。
#
#   sh scripts/split-for-backup.sh <入力MP4> [出力フォルダ] [ベース名]
#
# 例：
#   sh scripts/split-for-backup.sh output/morning-study-room.mp4 backup morning-study-room
#
# 分割は再エンコードではなく単純なバイト分割なので、結合すれば原本に完全に戻る。
# Drive などスマホ経由で受け渡すときの、劣化させない標準手段。

set -e

SRC="$1"
OUTDIR="${2:-backup}"
BASE="${3:-}"
CHUNK=94371840   # 90 MiB

if [ -z "$SRC" ] || [ ! -f "$SRC" ]; then
  echo "使い方: sh scripts/split-for-backup.sh <入力MP4> [出力フォルダ] [ベース名]" >&2
  exit 1
fi

# ベース名を省略したら拡張子を取った入力ファイル名を使う
if [ -z "$BASE" ]; then
  BASE=$(basename "$SRC")
  BASE=${BASE%.*}
fi

if command -v sha256sum >/dev/null 2>&1; then
  sha256of() { sha256sum "$1" | cut -d' ' -f1; }
elif command -v shasum >/dev/null 2>&1; then
  sha256of() { shasum -a 256 "$1" | cut -d' ' -f1; }
else
  echo "エラー: sha256sum も shasum も見つかりません。" >&2
  exit 1
fi

mkdir -p "$OUTDIR"

echo "[1/4] 分割しています（${CHUNK} バイトずつ）..."
python3 - "$SRC" "$OUTDIR" "$BASE" "$CHUNK" <<'PY'
import sys, os
src, outdir, base, chunk = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
n = 0
with open(src, 'rb') as f:
    while True:
        buf = f.read(chunk)
        if not buf:
            break
        path = os.path.join(outdir, "%s.part-%02d.bin" % (base, n))
        with open(path, 'wb') as out:
            out.write(buf)
        print("  %s (%d bytes)" % (os.path.basename(path), len(buf)))
        n += 1
if n > 100:
    sys.exit("パーツが100個を超えました。CHUNKを大きくしてください。")
print("  合計 %d パーツ" % n)
PY

echo "[2/4] ハッシュ一覧を作っています..."
( cd "$OUTDIR" && : > PARTS_SHA256.txt )
for f in "$OUTDIR/$BASE".part-*.bin; do
  echo "$(sha256of "$f")  $(basename "$f")" >> "$OUTDIR/PARTS_SHA256.txt"
done
ORIG_HASH=$(sha256of "$SRC")
ORIG_SIZE=$(wc -c < "$SRC" | tr -d ' ')
echo "$ORIG_HASH  $(basename "$SRC")" > "$OUTDIR/ORIGINAL_SHA256.txt"

echo "[3/4] 復元スクリプトを作っています..."
PARTS=$(cd "$OUTDIR" && ls "$BASE".part-*.bin | sort)

# --- Mac / Linux ---
{
  echo "#!/bin/sh"
  echo "cat \\"
  for p in $PARTS; do echo "    $p \\"; done
  echo "    > \"${BASE}_restored.mp4\""
  echo "echo \"復元が完了しました。\""
} > "$OUTDIR/restore-mac-linux.sh"

# --- Windows ---
{
  printf '@echo off\r\n'
  printf 'copy /b '
  first=1
  for p in $PARTS; do
    if [ $first -eq 1 ]; then printf '%s' "$p"; first=0; else printf '+%s' "$p"; fi
  done
  printf ' "%s_restored.mp4"\r\n' "$BASE"
  printf 'echo.\r\n'
  printf 'echo 復元が完了しました。\r\n'
  printf 'pause\r\n'
} > "$OUTDIR/restore-windows.bat"

# --- README ---
{
  echo "『${BASE}』のバックアップです。"
  echo ""
  echo "part ファイルは、元のMP4を分割したものです。"
  echo "映像・音声は再圧縮していないため、結合すると元の高画質版を完全復元できます。"
  echo ""
  echo "【Windows】"
  echo "すべての part ファイルと restore-windows.bat を同じフォルダに置き、"
  echo "restore-windows.bat をダブルクリックしてください。"
  echo ""
  echo "【Mac / Linux】"
  echo "ターミナルでこのフォルダを開き、次を実行してください。"
  echo "sh restore-mac-linux.sh"
  echo ""
  echo "復元後のファイル名："
  echo "${BASE}_restored.mp4"
  echo ""
  echo "復元後のサイズ：${ORIG_SIZE} バイト"
  echo ""
  echo "復元後のSHA-256："
  echo "$ORIG_HASH"
} > "$OUTDIR/README_復元方法.txt"

echo "[4/4] 完了"
echo ""
echo "  出力先   : $OUTDIR"
echo "  原本      : $SRC"
echo "  サイズ    : $ORIG_SIZE バイト"
echo "  SHA-256   : $ORIG_HASH"
echo ""
echo "次にやること："
echo "  1. $OUTDIR の中身をまるごと Google Drive にアップロードする"
echo "  2. Drive の共有権限は「閲覧者」にする（編集者にしない）"
echo "  3. tracks/<slug>/CHECKSUMS.md にハッシュを転記する"
