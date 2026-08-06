# STATUS

作業ログ。単位ごとに追記し、**「次の一歩」を必ず書く**。（ganjin の流儀に合わせています）

---

## いまの状態

| | 状態 |
| --- | --- |
| 第1作 | **放課後トークルーム**で確定。1時間・会話用BGM |
| 音源 | 完成（Suno v2）。1時間版まで書き出し済み |
| 映像 | 完成（1264×720 / 24fps / H.264、ループアニメーション） |
| 高画質版の所在 | **Google Drive に8分割で退避済み**。復元は未実施 |
| リポジトリ | **未作成**（`manabi-ai-lab/manabi-bgm`）。中身はこのフォルダに用意済み |
| Release | 未作成（`v1.0.0-after-school-talk-room`） |
| YouTube | 未投稿。投稿文と設定は確定済み |
| サムネイル | Drive にある。リポジトリへは未配置 |

---

## 次の一歩

**あっきーが空のPublicリポジトリ `manabi-bgm` を作る。** それ以外は全部その後ろに並んでいます。

---

## あっきーの作業手順

### ① リポジトリを作る

<https://github.com/organizations/manabi-ai-lab/repositories/new>

| 欄 | 値 |
| --- | --- |
| Repository name | `manabi-bgm` |
| Description | `manabi-ai-lab のフリーBGMシリーズ｜配信・動画の会話用BGM（こよみ＆トワイライツ）` |
| 公開範囲 | **Public** |
| Add a README file | **チェックしない**（中身は用意済みのため） |
| .gitignore / license | **なし** |

### ② 中身を push する

このフォルダ一式は、`manabi-ai-lab.github.io` リポジトリの
`claude/manabi-bgm-youtube-release-dkojhi` ブランチの `manabi-bgm/` に入っています。

```sh
# 作業用に取り出す
git clone -b claude/manabi-bgm-youtube-release-dkojhi \
  https://github.com/manabi-ai-lab/manabi-ai-lab.github.io.git tmp-site
cp -r tmp-site/manabi-bgm ./manabi-bgm
rm -rf tmp-site

# 新しいリポジトリとして push
cd manabi-bgm
git init -b main
git add -A
git commit -m "放課後トークルーム：BGMシリーズ第1作の制作記録と公開手順"
git remote add origin https://github.com/manabi-ai-lab/manabi-bgm.git
git push -u origin main
```

> Claude に続きを頼む場合は、リポジトリを作ったあとに
> 「manabi-bgm を作ったので push して」と伝えてください。以降はこちらで実行できます。

### ③ 以降

[`docs/HANDOFF.md`](docs/HANDOFF.md) の「あっきーがやること」に従ってください。

---

## ログ

### 2026-08-06 — Claude（リモート実行環境）

**やったこと**

- Drive バックアップフォルダ（`1BwpEpgVjfd5aLJRp1fL8SwKiKnxt-Hpp`）を確認。13ファイル、欠品なし
- 小さいメタデータ5点を取得して検証
  - 8パーツ合計 **679,926,904 バイト**＝648.4 MiB。「約649MiB」と一致
  - 復元スクリプトは part-00→07 の順で**単純バイナリ連結**。再エンコードなしを確認
  - 原本SHA-256 `118de0f3…` が README・ORIGINAL_SHA256.txt・依頼内容の3か所で一致
- `scripts/restore-and-verify.sh` を作成。**正常系／欠品／破損の3経路を実行して検証**
- `scripts/split-for-backup.sh` を作成。250MBのファイルで**分割→復元がバイト単位で完全一致**することを実測
- リポジトリ一式を作成（README / 利用条件 / docs 5点 / tracks 5点＋backup / templates / scripts）
- Drive の YouTube投稿文資料を取り込み、`tracks/after-school-talk-room/YOUTUBE.md` を正本化

**できなかったこと**

- 高画質版の実復元と照合 — **この環境から Drive に到達できない**（`drive.google.com` は 403）
- スマホ用URLの作成 — 元ファイルが手元に来ないため
- `manabi-bgm` リポジトリの作成 — GitHub App に org のリポジトリ作成権限がない（403）
- Release 作成・YouTube投稿 — 上記に依存、およびログインが必要
- サムネイルのリポジトリ配置 — バイナリを会話経由で運ぶと破損リスクがあるため見送り

詳細と代替案は [`docs/HANDOFF.md`](docs/HANDOFF.md)。

**メモ**

- Drive バックアップフォルダは「リンクを知っている全員」＝編集者。**意図した設定**とあっきーに確認済み。変更しない

**次の一歩**

- あっきー：`manabi-bgm` リポジトリを作る（そのあとの push は Claude が実行できる）

---

### （次の記入欄）

**日付 — 誰が**

- やったこと：
- 次の一歩：
