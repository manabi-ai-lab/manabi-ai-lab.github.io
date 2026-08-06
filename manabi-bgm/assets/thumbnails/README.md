# サムネイル

YouTube に設定するサムネイル画像を置きます。

| ファイル名 | 曲 | 状態 |
| --- | --- | --- |
| `after-school-talk-room.jpg` | 放課後トークルーム | ⬜ **未配置** |

---

## 放課後トークルーム のサムネイル

Drive にあります（265,782 バイト / JPEG）：

<https://drive.google.com/file/d/1cviVqBQ1hGlBI7BaEy-AX816QVMoSRHv/view>

制作時のファイル名は `放課後トークルーム_サムネイル.jpg`
（Drive上の元名）／`after-school-talk-room-thumbnail.jpg`（制作データ上の名前）です。

### 置き方

1. 上のリンクからダウンロードする
2. `after-school-talk-room.jpg` にリネームして、このフォルダに置く
3. コミットする

```sh
git add assets/thumbnails/after-school-talk-room.jpg
git commit -m "放課後トークルームのサムネイルを追加"
```

> `.gitignore` は画像を通すように設定済みなので、`-f` は不要です。

### なぜ Claude が置いていないか

作業した実行環境から Google Drive へネットワーク接続できず、画像を取得できませんでした。
Drive連携経由で base64 として読むことはできますが、**画像は1バイト狂うと壊れる**ため、
会話をまたいで転記する方法は取っていません。詳細は [`../../docs/HANDOFF.md`](../../docs/HANDOFF.md)。

---

## サムネイルの決まり

| 項目 | 値 |
| --- | --- |
| 解像度 | 1280×720 以上（16:9） |
| 形式 | JPG または PNG |
| サイズ | 2MB以下（YouTubeの上限） |
| ファイル名 | `<slug>.jpg` |
| 確認 | **スマホ表示で文字が読めること** |
