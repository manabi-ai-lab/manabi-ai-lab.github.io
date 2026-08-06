# 高画質版の復元手順

『放課後トークルーム』1時間・高画質版 MP4 を、Google Drive の分割バックアップから復元します。

**再エンコードは一切しません。** 8個のバイナリを順番につなぐだけで、元のファイルとビット単位で同一のMP4が戻ります。

---

## 0. 前提

| 項目 | 値 |
| --- | --- |
| 復元後のファイル名 | `放課後トークルーム_1時間_高画質版.mp4` |
| 復元後のサイズ | **679,926,904 バイト**（648.4 MiB） |
| 復元後の SHA-256 | `118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc` |
| 必要な空き容量 | 約 1.3 GB（パーツ 649MiB ＋ 復元後 649MiB） |
| 所要時間 | ダウンロード次第。結合そのものは数十秒 |

バックアップフォルダ：
<https://drive.google.com/drive/folders/1BwpEpgVjfd5aLJRp1fL8SwKiKnxt-Hpp>

---

## 1. ダウンロード

フォルダ内の**13個すべて**を、空のフォルダにダウンロードします。

### パーツ（この8個が本体）

| ファイル | サイズ（バイト） | Drive |
| --- | --- | --- |
| `after-school-talk-room-one-hour-youtube.part-00.bin` | 94,371,840 | [開く](https://drive.google.com/file/d/1hkAIF0g_DRjpVVP0gPONBcpbTTd72UHt/view) |
| `after-school-talk-room-one-hour-youtube.part-01.bin` | 94,371,840 | [開く](https://drive.google.com/file/d/1ZDel0_50R3f1zLZBFaUJSQu863fT1IjM/view) |
| `after-school-talk-room-one-hour-youtube.part-02.bin` | 94,371,840 | [開く](https://drive.google.com/file/d/1BIYgUl_1Lt7tZ_AfPOWM7NTDtMC_7Klz/view) |
| `after-school-talk-room-one-hour-youtube.part-03.bin` | 94,371,840 | [開く](https://drive.google.com/file/d/1lfPN6GUuBXnHqcadtOm8fqgk-RuVzgLO/view) |
| `after-school-talk-room-one-hour-youtube.part-04.bin` | 94,371,840 | [開く](https://drive.google.com/file/d/1JQsK0lbO6OCVRy8rYubycjWLqdmqSRRZ/view) |
| `after-school-talk-room-one-hour-youtube.part-05.bin` | 94,371,840 | [開く](https://drive.google.com/file/d/14tfjaDE9X31DBGtOQP6BhO2vtZqrzPCp/view) |
| `after-school-talk-room-one-hour-youtube.part-06.bin` | 94,371,840 | [開く](https://drive.google.com/file/d/19pfwG37_E0W6VSW4f9-PhZGEyOkyieex/view) |
| `after-school-talk-room-one-hour-youtube.part-07.bin` | 19,324,024 | [開く](https://drive.google.com/file/d/1gemj9-DSHiG0RPjDg6puikZTeV-0-yTT/view) |
| **合計** | **679,926,904** | |

### 補助ファイル

`README_復元方法.txt` / `restore-windows.bat` / `restore-mac-linux.sh` / `ORIGINAL_SHA256.txt` / `PARTS_SHA256.txt`

これら5つは、このリポジトリの [`tracks/after-school-talk-room/backup/`](../tracks/after-school-talk-room/backup/) にも同じものが入っています。
**パーツ（.bin）はリポジトリには入っていません。** Drive からしか取れません。

> **フォルダごと一括ダウンロードする場合の注意**
> Drive の「フォルダをダウンロード」は ZIP にまとめます。**ZIP を必ず展開してから**結合してください。
> また、8個のパーツが**すべて揃っていること**をサイズ表で確認してください。1個でも欠けると壊れたMP4ができます。

---

## 2. 結合する

### Windows

1. 8個のパーツと `restore-windows.bat` を**同じフォルダ**に置く
2. `restore-windows.bat` をダブルクリック

中身は `copy /b` による単純なバイナリ連結です。

### Mac / Linux

ターミナルでそのフォルダを開いて：

```sh
sh restore-mac-linux.sh
```

### 手で行う場合（どのOSでも）

part-00 から part-07 まで**番号順に**バイナリ連結するだけです。

```sh
cat after-school-talk-room-one-hour-youtube.part-0{0,1,2,3,4,5,6,7}.bin \
  > "放課後トークルーム_1時間_高画質版.mp4"
```

```powershell
# PowerShell
cmd /c copy /b (Get-ChildItem *.part-*.bin | Sort-Object Name | % Name) -join '+' "放課後トークルーム_1時間_高画質版.mp4"
```

---

## 3. SHA-256 を照合する（必ずやる）

結合しただけでは「正しく戻ったか」は分かりません。**必ずハッシュを照合してください。**

### Mac / Linux

```sh
shasum -a 256 "放課後トークルーム_1時間_高画質版.mp4"
# Linux では sha256sum でも可
```

### Windows（PowerShell）

```powershell
Get-FileHash "放課後トークルーム_1時間_高画質版.mp4" -Algorithm SHA256
```

出力が次と**完全に一致**すれば成功です（大文字小文字は無視してよい）。

```
118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc
```

### まとめて自動でやる

このリポジトリの [`scripts/restore-and-verify.sh`](../scripts/restore-and-verify.sh) は、
**パーツ個別のハッシュ照合 → 結合 → 原本ハッシュ照合**まで一気にやります。パーツと同じフォルダに置いて実行してください。

```sh
sh restore-and-verify.sh
```

---

## 4. 一致しなかったとき

慌てて再エンコードしないでください。**原因はほぼ必ずダウンロードの失敗です。**

1. `PARTS_SHA256.txt` を使って、**どのパーツが壊れているか**を特定する

   ```sh
   # Mac / Linux：パーツ個別のハッシュを出す
   shasum -a 256 after-school-talk-room-one-hour-youtube.part-*.bin
   ```

   期待値は [`tracks/after-school-talk-room/CHECKSUMS.md`](../tracks/after-school-talk-room/CHECKSUMS.md) にも一覧があります。

2. まずサイズを見る。94,371,840 バイト（最後だけ 19,324,024）でないパーツは**ダウンロード途中**です
3. 壊れたパーツだけ Drive から取り直して、もう一度結合する
4. それでも合わないときは、8個の**順番**と、`.bin` 以外のファイル（README など）が混ざっていないかを確認する

---

## 5. やってはいけないこと

- ❌ 再エンコードして容量を小さくする
- ❌ `放課後トークルーム_1時間_スマホDrive版.mp4`（HEVC・約101.6MB）を代わりに使う
- ❌ ハッシュ照合を省いて YouTube に上げる
- ❌ 649MiB の MP4 を git にコミットする

---

## 6. Drive の共有設定について

バックアップフォルダは「リンクを知っている全員」が**編集者**の設定です。
これは受け渡しの都合による**意図した設定**なので、変更不要です。

リンクの取り扱いにだけ注意してください。
