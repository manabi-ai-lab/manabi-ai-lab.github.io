# GitHub Release の作り方

649MiB の MP4 は **git の履歴に入れず**、Release のアセットとして配布します。

- GitHub の Release アセットは **1ファイル 2GiB まで**。649MiB は余裕で収まります
- Git LFS は不要（むしろ帯域を消費するので使いません）
- リポジトリのクローンが重くならないのが最大の利点

---

## 第1作の設定値

| 項目 | 値 |
| --- | --- |
| リポジトリ | `manabi-ai-lab/manabi-bgm` |
| タグ | `v1.0.0-after-school-talk-room` |
| タイトル | `放課後トークルーム — 1時間BGM` |
| アセット | `放課後トークルーム_1時間_高画質版.mp4`（679,926,904 バイト） |
| 公開範囲 | Public |

---

## 手順

### 前提：先に復元と照合を終える

[`RESTORE.md`](RESTORE.md) の手順で SHA-256 が
`118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc`
と一致することを確認してから始めます。**未照合のファイルをアップロードしない。**

### A. コマンドで作る（推奨）

`gh`（GitHub CLI）が入っていれば一発です。復元したMP4のあるフォルダで：

```sh
sh scripts/create-release.sh "放課後トークルーム_1時間_高画質版.mp4"
```

スクリプトは、アップロード前にハッシュを照合してから Release を作ります。

手で叩く場合：

```sh
gh release create v1.0.0-after-school-talk-room \
  "放課後トークルーム_1時間_高画質版.mp4" \
  --repo manabi-ai-lab/manabi-bgm \
  --title "放課後トークルーム — 1時間BGM" \
  --notes-file templates/RELEASE_NOTES.md
```

### B. ブラウザで作る

1. <https://github.com/manabi-ai-lab/manabi-bgm/releases/new> を開く
2. **Choose a tag** → `v1.0.0-after-school-talk-room` と入力 → *Create new tag on publish*
3. **Release title** → `放課後トークルーム — 1時間BGM`
4. 本文 → [`../templates/RELEASE_NOTES.md`](../templates/RELEASE_NOTES.md) の内容を貼り、埋める
5. **Attach binaries** に `放課後トークルーム_1時間_高画質版.mp4` をドロップ
   - 649MiB なので回線によっては10〜30分かかります。**完了表示まで待つ**
6. *Set as the latest release* にチェック
7. **Publish release**

---

## 公開後にやること（必須）

Release からダウンロードし直して、**バイト列が変わっていないこと**を確認します。

```sh
curl -L -o check.mp4 \
  "https://github.com/manabi-ai-lab/manabi-bgm/releases/download/v1.0.0-after-school-talk-room/%E6%94%BE%E8%AA%B2%E5%BE%8C%E3%83%88%E3%83%BC%E3%82%AF%E3%83%AB%E3%83%BC%E3%83%A0_1%E6%99%82%E9%96%93_%E9%AB%98%E7%94%BB%E8%B3%AA%E7%89%88.mp4"

shasum -a 256 check.mp4
# => 118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc
```

一致したら `tracks/after-school-talk-room/CHECKSUMS.md` の「照合の記録」に追記します。

---

## スマホから使えるURL

Release のアセットURLは、**そのままスマホでタップして再生・ダウンロードできます**。
CloudFront などを別に立てなくても、これで用は足ります。

```
https://github.com/manabi-ai-lab/manabi-bgm/releases/download/v1.0.0-after-school-talk-room/放課後トークルーム_1時間_高画質版.mp4
```

- ✅ 再エンコードなし。**アップロードしたバイト列がそのまま返る**
- ✅ 認証不要（Publicリポジトリのため）
- ✅ CDN 経由で配信される
- ⚠️ ファイル名が日本語なので、リンクとして貼るときは上のURLエンコード済みの形が確実です

日本語ファイル名を避けたい場合は、アップロード時に
`after-school-talk-room-1h-hq.mp4` へ**リネームだけ**しても構いません（中身は変わらないのでハッシュは同じ）。

---

## ファイル名についての注意

**リネームはしてよい。再エンコードはしてはいけない。**
リネームしてもバイト列は変わらないので SHA-256 は一致したままです。
逆に、少しでも変換をかけると `118de0f3…` は一致しなくなります。

---

## 次作以降のタグ規則

```
v<メジャー>.<マイナー>.<パッチ>-<slug>
```

例：`v1.0.0-after-school-talk-room` / `v1.0.0-morning-study-room`

- 同じ曲を差し替えたら **パッチ**を上げる（`v1.0.1-after-school-talk-room`）
- 尺違い・別バージョンを足したら **マイナー**を上げる
- Release タイトルは `曲名 — 尺BGM` の形に揃える
