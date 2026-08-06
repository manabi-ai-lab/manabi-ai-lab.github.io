# 制作・公開手順（PLAYBOOK）

1曲を作って公開しきるまでの全工程。**ここから読む。**
第1作『放課後トークルーム』の実作業をもとにしています。

各工程の詳細は個別の文書へ。この文書は**順番と抜け漏れ防止**が役目です。

---

## 全体像

```
1. 企画       どんな場面で使うBGMか決める
2. 作曲       Suno で作る → v1/v2 を比べて採用を決める
3. 1時間化    短いクリップをループして1時間にする
4. 映像       ループアニメーションを作る
5. 書き出し   H.264 / AAC / -14 LUFS 前後で1本のMP4にする
6. 検品       仕様・ハッシュ・再生の3点で確認する
7. 退避       分割してDriveへ。ハッシュを記録する
8. 記録       tracks/<slug>/ を埋める
9. Release    GitHub Release に高画質MP4を添付する
10. YouTube   限定公開 → 確認 → 一般公開
11. 後始末    URLの相互リンク、権限の締め、次の一歩
```

---

## 1. 企画

- [ ] **使われる場面**を1つに決める（例：雑談配信の後ろで会話を邪魔しない）
- [ ] 曲名と slug を決める（slug は英小文字とハイフン。例 `after-school-talk-room`）
- [ ] `templates/` から `tracks/<slug>/` を作る

```sh
mkdir -p tracks/<slug>
cp templates/TRACK_README.md      tracks/<slug>/README.md
cp templates/TRACK_SUNO.md        tracks/<slug>/SUNO.md
cp templates/TRACK_YOUTUBE.md     tracks/<slug>/YOUTUBE.md
cp templates/TRACK_VIDEO_SPEC.md  tracks/<slug>/VIDEO_SPEC.md
cp templates/TRACK_CHECKSUMS.md   tracks/<slug>/CHECKSUMS.md
```

## 2. 作曲（Suno）

- [ ] スタイルプロンプトを書く。**会話用なら「声とぶつからない」ことを優先**
- [ ] インストゥルメンタルで生成する
- [ ] 複数バージョンを作り、**実際に喋りながら**聴いて選ぶ
- [ ] `SUNO.md` に生成日・プラン・モデル・プロンプト・採用理由を**その場で**書く

> Suno の商用利用可否は「生成時点で有料プランだったか」で決まります。
> あとから思い出せないので、**生成日とプランは必ず記録**します。

## 3. 1時間化

- [ ] ループの継ぎ目を確認する（クロスフェードの要否）
- [ ] 1時間（3600秒前後）に伸ばす
- [ ] ラウドネスを **-14 LUFS 前後 / True Peak -1.0 dBFS** に整える

```sh
# ラウドネス測定
ffmpeg -i in.wav -af ebur128=peak=true -f null - 2>&1 | tail -20
```

## 4. 映像

- [ ] キャラクター（こよみ／トワイライツ）のループアニメーションを作る
- [ ] **少し動く**程度に留める。動きすぎると会話の邪魔になる
- [ ] 1時間ぶんループさせる

## 5. 書き出し

| 項目 | 値 |
| --- | --- |
| 映像 | H.264 |
| 解像度 | 1280×720 以上（第1作は 1264×720） |
| fps | 24 |
| 音声 | AAC / 48kHz / ステレオ |
| ラウドネス | -14 LUFS 前後 / True Peak -1.0 dBFS |

- [ ] 1本のMP4に書き出す
- [ ] **書き出しは1回だけ。** 以降は絶対に再エンコードしない

## 6. 検品

- [ ] `ffprobe` で仕様を確認する
- [ ] **SHA-256 を取って記録する**（これが以降すべての基準になる）
- [ ] 0:00 / 0:10 / 1:59前後 / 30:00 / 59:55 を再生し、音切れ・映像の跳び・音量の急変を確認

詳細 → [`../tracks/after-school-talk-room/VIDEO_SPEC.md`](../tracks/after-school-talk-room/VIDEO_SPEC.md)

## 7. 退避（分割バックアップ）

PC↔スマホ↔クラウドの受け渡しで**画質を落とさない**ための工程です。
「スマホに送るために圧縮する」を一度やると、どれが原本か分からなくなります。**分割して運ぶ。**

```sh
sh scripts/split-for-backup.sh "<書き出したMP4>" backup <slug>
```

- [ ] `backup/` の中身をまるごと Google Drive にアップロード
- [ ] Drive の共有権限を **「閲覧者」** にする（**編集者にしない**）
- [ ] `CHECKSUMS.md` にハッシュを転記

## 8. 記録

- [ ] `tracks/<slug>/README.md` — 曲の概要
- [ ] `tracks/<slug>/SUNO.md` — 制作情報（空欄を残さない）
- [ ] `tracks/<slug>/YOUTUBE.md` — タイトル・概要欄・タグ
- [ ] `tracks/<slug>/VIDEO_SPEC.md` — 仕様と検品結果
- [ ] `tracks/<slug>/CHECKSUMS.md` — ハッシュ
- [ ] `assets/thumbnails/<slug>.jpg` — サムネイル
- [ ] ルート `README.md` のシリーズ一覧に1行足す

## 9. GitHub Release

- [ ] 復元 → **SHA-256照合**（[`RESTORE.md`](RESTORE.md)）
- [ ] Release作成（[`RELEASE.md`](RELEASE.md)）
- [ ] **公開後にダウンロードし直して再照合**

## 10. YouTube

- [ ] 限定公開でアップロード（[`YOUTUBE.md`](YOUTUBE.md)）
- [ ] 設定：音楽 / 子ども向けでない / 合成コンテンツ「はい」 / 自動チャプターオフ / 標準ライセンス
- [ ] スマホ・PCで確認
- [ ] 一般公開へ切り替え
- [ ] 概要欄のURL置換 → 固定コメント投稿

## 11. 後始末

- [ ] YouTube URL を Release ノートと `tracks/<slug>/` に追記
- [ ] Release URL を YouTube 概要欄に追記（希望する場合）
- [ ] Drive の共有権限が「閲覧者」になっているか**もう一度**確認
- [ ] `STATUS.md` に結果と**次の一歩**を書く

---

## 落とし穴（第1作で分かったこと）

| 落とし穴 | 対策 |
| --- | --- |
| スマホ受け渡しのために圧縮した版が混ざる | ファイル名に `_高画質版` / `_スマホ版` を必ず入れ、**SHA-256で判別**する |
| どれが原本か分からなくなる | 書き出した直後に SHA-256 を取り、`CHECKSUMS.md` に書く |
| Drive の共有が「編集者」のまま | 退避直後に「閲覧者」へ落とす |
| 大きいMP4を git にコミットしてしまう | `.gitignore` で `*.mp4` を弾く。配布は Release |
| 概要欄の「この動画のURL」が置換されないまま | 公開直後のチェックリストに入れる |
| 自動チャプターが勝手に付く | 詳細設定でオフ |
| Suno のプラン・生成日を忘れる | 生成した**その場で** `SUNO.md` に書く |
