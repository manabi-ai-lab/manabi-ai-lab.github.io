# manabi-bgm

manabi-ai-lab のフリーBGMシリーズ。配信・動画の**会話用BGM**を作って、YouTubeで無料公開します。

- 音楽：Suno（有料プラン契約期間中に制作したオリジナル）
- 映像：少し動くループアニメーション。オリジナルキャラクター **こよみ** と **トワイライツ**
- 公開先：YouTube（本編）／ GitHub Release（高画質MP4の配布）
- 制作：あっきー（manabi-ai-lab）

このリポジトリは **Public**。音源そのものではなく、**制作記録・公開手順・利用条件**を置く場所です。

---

## シリーズ一覧

| # | 曲名 | 長さ | 状態 | Release | YouTube |
| --- | --- | --- | --- | --- | --- |
| 1 | [放課後トークルーム](tracks/after-school-talk-room/) | 1時間 | 公開準備中 | `v1.0.0-after-school-talk-room`（未作成） | 未投稿 |

新しい曲を足すときは [`templates/`](templates/) をコピーして `tracks/<slug>/` を作ります。

---

## ここから読む

| 目的 | ファイル |
| --- | --- |
| いま何が終わっていて、次に何をするか | [`STATUS.md`](STATUS.md) |
| 制作から公開までの全工程 | [`docs/PLAYBOOK.md`](docs/PLAYBOOK.md) |
| 引き継ぎ（担当の分担・未完了の理由） | [`docs/HANDOFF.md`](docs/HANDOFF.md) |
| 高画質版の復元手順（**最重要**） | [`docs/RESTORE.md`](docs/RESTORE.md) |
| GitHub Release の作り方 | [`docs/RELEASE.md`](docs/RELEASE.md) |
| YouTube投稿の設定 | [`docs/YOUTUBE.md`](docs/YOUTUBE.md) |
| BGMの利用条件 | [`LICENSE-BGM.md`](LICENSE-BGM.md) |

---

## フォルダ構成

```
manabi-bgm/
├── README.md              このファイル
├── STATUS.md              作業ログ。単位ごとに追記し「次の一歩」を必ず書く
├── LICENSE-BGM.md         BGMの利用条件（配布物の正本）
├── docs/                  シリーズ共通の手順書
│   ├── PLAYBOOK.md        制作→公開の全工程チェックリスト
│   ├── HANDOFF.md         引き継ぎ
│   ├── RESTORE.md         分割バックアップからの高画質版復元
│   ├── RELEASE.md         GitHub Release 作成手順
│   └── YOUTUBE.md         YouTube投稿手順
├── tracks/                曲ごとの制作記録
│   └── after-school-talk-room/
│       ├── README.md      曲の概要
│       ├── SUNO.md        Suno制作情報
│       ├── YOUTUBE.md     投稿文（タイトル・概要欄・タグ）の正本
│       ├── VIDEO_SPEC.md  動画仕様と検品結果
│       ├── CHECKSUMS.md   SHA-256（原本・分割パーツ）
│       └── backup/        復元スクリプトとハッシュ一覧
├── templates/             次のBGM用のひな形
├── scripts/               分割・照合・Release作成の補助スクリプト
└── assets/thumbnails/     サムネイル画像
```

---

## 大きなファイルの扱い（重要）

**649MiB の MP4 を git にコミットしない。** GitHub Release のアセットとして配布します。

| 種類 | 置き場所 |
| --- | --- |
| 本編MP4（約649MiB） | GitHub Release のアセット |
| 分割バックアップ（8個の .bin） | Google Drive |
| サムネイル（約260KB） | このリポジトリ `assets/thumbnails/` |
| 手順・記録・利用条件 | このリポジトリ |

`.gitignore` で `*.mp4` `*.bin` `*.wav` などを弾いています。意図して追加したい場合だけ `git add -f`。

---

## 使ってはいけない動画

`放課後トークルーム_1時間_スマホDrive版.mp4` は、スマホ受け渡しのために **HEVC・約101.6MB まで強く圧縮した低画質版**です。

**YouTube投稿にも GitHub Release にも使わないでください。** 配布に使ってよいのは、SHA-256 が
`118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc`
と一致する高画質版だけです。

---

## 利用条件（要約）

動画・ライブ配信の背景音楽として、収益化された動画でも使えます。可能な範囲でクレジットの記載をお願いします。
再配布・販売・Content IDへの登録・自作と誤認させる表示は禁止です。

正確な条文は [`LICENSE-BGM.md`](LICENSE-BGM.md) を見てください。
なお、このリポジトリ内の**文書・スクリプト**と、**音源・映像**とではライセンスが異なります（同ファイル内に明記）。
