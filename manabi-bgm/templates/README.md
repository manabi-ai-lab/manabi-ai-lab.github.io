# テンプレート

新しいBGMを作るときに、ここから `tracks/<slug>/` へコピーします。

```sh
SLUG=morning-study-room   # 例

mkdir -p tracks/$SLUG
cp templates/TRACK_README.md      tracks/$SLUG/README.md
cp templates/TRACK_SUNO.md        tracks/$SLUG/SUNO.md
cp templates/TRACK_YOUTUBE.md     tracks/$SLUG/YOUTUBE.md
cp templates/TRACK_VIDEO_SPEC.md  tracks/$SLUG/VIDEO_SPEC.md
cp templates/TRACK_CHECKSUMS.md   tracks/$SLUG/CHECKSUMS.md
```

そのあと、各ファイルの `<曲名>` `<slug>` `<...>` を置き換えていきます。

| テンプレート | 用途 |
| --- | --- |
| `TRACK_README.md` | 曲の概要 |
| `TRACK_SUNO.md` | Suno制作情報。**生成したその場で書く** |
| `TRACK_YOUTUBE.md` | タイトル・概要欄・タグ・Studio設定 |
| `TRACK_VIDEO_SPEC.md` | 動画仕様と検品記録 |
| `TRACK_CHECKSUMS.md` | SHA-256 |
| `RELEASE_NOTES.md` | GitHub Release の本文 |

実例は [`../tracks/after-school-talk-room/`](../tracks/after-school-talk-room/) を見てください。
迷ったら第1作をまるごとコピーして書き換えるのが早いです。

工程の順番は [`../docs/PLAYBOOK.md`](../docs/PLAYBOOK.md)。
