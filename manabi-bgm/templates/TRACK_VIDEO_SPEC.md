# 動画仕様と検品 — <曲名>

---

## 仕様

| 項目 | 値 | 目標 |
| --- | --- | --- |
| 解像度 | | 1280×720 以上 |
| フレームレート | | 24 fps |
| 映像コーデック | | H.264 |
| 音声コーデック | | AAC |
| サンプリング周波数 | | 48 kHz |
| チャンネル | | ステレオ |
| 長さ | | |
| ファイルサイズ | | |
| Integrated loudness | | -14 LUFS 前後 |
| True peak | | -1.0 dBFS |

ラウドネスは YouTube の基準に合わせます。合っていれば**そのまま上げるのが正解**で、
YouTube側の正規化による音量変更はほとんど起きません。

---

## 検品手順

### 1. ファイルの同一性

```sh
shasum -a 256 "<ファイル名>"
# => CHECKSUMS.md の原本値と一致すること
```

### 2. 仕様の確認

```sh
ffprobe -v error -show_entries format=duration,size,bit_rate \
  -show_entries stream=codec_name,width,height,r_frame_rate,sample_rate,channels \
  -of default=noprint_wrappers=1 "<ファイル名>"
```

### 3. ラウドネスの確認

```sh
ffmpeg -i "<ファイル名>" -af ebur128=peak=true -f null - 2>&1 | tail -20
```

### 4. 目と耳での確認（必須）

**音切れ・映像の跳び・音量の急変**がないこと。

- [ ] 0:00（頭。無音から始まっていないか）
- [ ] 0:10
- [ ] ループの継ぎ目が出やすい位置
- [ ] 中間
- [ ] 終端5秒前（尻切れしていないか）

### 5. サムネイル

- [ ] 文字がスマホ表示でも読める
- [ ] 1280×720 以上・2MB以下・JPG/PNG

---

## 検品記録

| 日付 | 誰が | 対象 | 結果 |
| --- | --- | --- | --- |
| | | | |
