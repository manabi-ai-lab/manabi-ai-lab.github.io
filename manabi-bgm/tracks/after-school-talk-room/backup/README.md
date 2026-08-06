# backup/ — 復元一式（パーツ本体は入っていません）

Google Drive の分割バックアップに同梱されている**補助ファイルの写し**です。
Drive 側が消えたり書き換えられたりしても、ここに残るようにコピーしてあります。

| ファイル | 中身 |
| --- | --- |
| `ORIGINAL_SHA256.txt` | 原本MP4の SHA-256 |
| `PARTS_SHA256.txt` | 8パーツそれぞれの SHA-256 |
| `restore-windows.bat` | Windows用の結合スクリプト（`copy /b`） |
| `restore-mac-linux.sh` | Mac / Linux用の結合スクリプト（`cat`） |
| `README_復元方法.txt` | Drive に置いてある復元手順 |

**`.bin` パーツ本体（合計649MiB）はここにはありません。** Drive から取得してください。

<https://drive.google.com/drive/folders/1BwpEpgVjfd5aLJRp1fL8SwKiKnxt-Hpp>

---

## 使い方

この5つと、Drive から落とした8個の `.bin` を**同じフォルダ**に置いて実行します。

より確実なのは、リポジトリ同梱の [`../../../scripts/restore-and-verify.sh`](../../../scripts/restore-and-verify.sh) です。
こちらは**結合前にパーツ個別のハッシュを照合**するので、壊れたパーツをその場で特定できます。

手順の全体 → [`../../../docs/RESTORE.md`](../../../docs/RESTORE.md)

---

## 検証済みの内容（2026-08-06）

- 8パーツ合計 **679,926,904 バイト**（648.4 MiB）＝ 原本の想定サイズと一致
- 結合順は `part-00` → `part-07`。**単純バイナリ連結のみ。再エンコードなし**
- 原本SHA-256 `118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc` が
  `README_復元方法.txt` / `ORIGINAL_SHA256.txt` / 依頼内容の3か所で一致
