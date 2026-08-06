# チェックサム — 放課後トークルーム 1時間版

配布してよいのは、ここに載っている **原本SHA-256 と一致するファイルだけ**です。

---

## 原本（配布する高画質版）

| 項目 | 値 |
| --- | --- |
| 制作時のファイル名 | `after-school-talk-room-one-hour-youtube.mp4` |
| 復元後のファイル名 | `放課後トークルーム_1時間_高画質版.mp4` |
| サイズ | 679,926,904 バイト（648.4 MiB） |
| SHA-256 | `118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc` |

```
118de0f31bca5de2386e4099df674d67cc40a59dbf9ddf11443b887211605cfc  after-school-talk-room-one-hour-youtube.mp4
```

---

## 分割バックアップの各パーツ

Google Drive: <https://drive.google.com/drive/folders/1BwpEpgVjfd5aLJRp1fL8SwKiKnxt-Hpp>

| パーツ | サイズ（バイト） | SHA-256 |
| --- | --- | --- |
| part-00 | 94,371,840 | `738a9fcf8427dc22e679c568311f3d58121d30a69ee75082d90b523c7422d658` |
| part-01 | 94,371,840 | `7471b94f39e82e177269efc720b625c7594c06a68ad032cf005131b2424422ba` |
| part-02 | 94,371,840 | `4d8c880af1a2bc8ee21da87c28f91d6e0159f59fdeda4c4bb7d65bfa742c8d39` |
| part-03 | 94,371,840 | `29bf28f6b3e58fa559ec24d690ded1c70e1fa9e9bc4e58abf5368a864c8119f6` |
| part-04 | 94,371,840 | `0f2f6aed547125c5cd4e74cdc5882acf7416f602f6723ad2233d13bdf031c438` |
| part-05 | 94,371,840 | `21952dfbbb9a306743211ea86ee29729f53931ba64081f0b10696040d5173bd8` |
| part-06 | 94,371,840 | `5ed5a041b8aa425072a136c977f897f3f372e1498ebb875088855ec72d56fde9` |
| part-07 | 19,324,024 | `637d25887bbc0c3d97d4c5cbfbc54a430a9b10012d540c39793916e679cb7eb9` |
| **合計** | **679,926,904** | ＝ 原本サイズと一致 |

機械可読な一覧は [`backup/PARTS_SHA256.txt`](backup/PARTS_SHA256.txt) と [`backup/ORIGINAL_SHA256.txt`](backup/ORIGINAL_SHA256.txt)。

---

## 配布してはいけないファイル

| ファイル | 理由 |
| --- | --- |
| `放課後トークルーム_1時間_スマホDrive版.mp4` | スマホ受け渡し用に **HEVC・約101.6MB** まで強く圧縮した低画質版。映像が劣化している |

サイズが 649MiB 前後でない、あるいは SHA-256 が上の原本値と違うファイルは、**すべて配布対象外**です。

---

## 照合のしかた

```sh
# Mac / Linux
shasum -a 256 "放課後トークルーム_1時間_高画質版.mp4"

# Windows (PowerShell)
Get-FileHash "放課後トークルーム_1時間_高画質版.mp4" -Algorithm SHA256
```

自動でやるなら [`../../scripts/restore-and-verify.sh`](../../scripts/restore-and-verify.sh)。

---

## 照合の記録

作業のたびに追記します。

| 日付 | 誰が / どこで | 対象 | 結果 |
| --- | --- | --- | --- |
| 2026-08-06 | Claude（リモート実行環境） | `backup/` のハッシュ一覧・復元スクリプト | ✅ 内容を検証。8個のパーツ合計 679,926,904 バイト＝原本サイズと一致。結合順とスクリプトの正当性を確認 |
| 2026-08-06 | Claude（リモート実行環境） | 原本MP4そのもの | ⚠️ **未照合**。実行環境から Google Drive へ接続できず、パーツをダウンロードできなかった（`docs/HANDOFF.md` 参照） |
| | あっきー | 復元後のMP4 | ⬜ 未実施 |
| | あっきー | Release からダウンロードし直したMP4 | ⬜ 未実施 |
