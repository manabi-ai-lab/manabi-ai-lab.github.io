# manabi-ai-lab.github.io

**MANABI LAB** — 教育 × AI の公開サイト。

https://manabi-ai-lab.github.io/

## 構成

静的HTMLのみ。ビルド不要で、`main` に push すると GitHub Pages に反映される。

```
index.html        トップ（二つの入口）
kids/             まなびソング（子ども・家族向け）
educators/        教育 × AI 実践ノート（大人向け）
projects/         制作実績（工程の記録）
about/            このサイトについて
style.css         全ページ共通
404.html          存在しないURL用（GitHub Pagesが自動で使う）
favicon.svg       ファビコン
sitemap.xml       検索エンジン用。ページを増やしたらここにも1行足す
robots.txt        sitemap.xml の場所を知らせるだけ
.nojekyll         GitHub Pages の Jekyll ビルドを止める
```

フレームワークは意図的に入れていない。1ページ足せば即公開できる軽さを優先する。
移行を検討するのは、ページが20枚を超えるか、検索・タグ絞り込みが必要になったとき。

## 更新のしかた

- 作品が増えたら … `kids/` と `projects/` にカードを1枚ずつ
- 制作で新しく詰まったことがあれば … `educators/` に `.memo` を1つ
- **新しいページを作る前に、既存ページに足せないか考える**
- 新しいページを作ったら … `sitemap.xml` に1行、各ページのフッターに1リンク足す

## 公開前に必ず

作業手順・設計図・現場の資料は**別の非公開リポジトリ**にあり、
公開してよい内容の判断基準もそちらに置いている。

コミット前に非公開リポジトリの `docs/PUBLICATION_CHECKLIST.md` を通すこと。
特に、学校名・地域・個人が特定される記述と、画像のExifメタデータに注意する。
