# ComiketBrowser for Linux

コミケブラウザがwineでもぜんぶ文字化けして使えないのでLinuxでも使えるコミケブラウザを作ります

## 仕様
### やること
- ブラウジング
- サークルチェックcsvファイル読み込み
- サークルチェックcsvファイル出力

### やらないこと
- 地図を見る
- 印刷

## Usage
### setup
    bundle install
    rake setup /media/cdrom

### run
    ./app.rb (-p PORT_NUM ; default: 4567)

### load csv
    rake checklist:load[/path/to/csv]

### use
    chromium-browser http://localhost:4567(OR PORT_NUM)/

#### キーバインド
- n: 次のページ
- p: 前のページ
- サークル選択状態で
  - 1-8 チェック
  - 0, del, escape チェック外す

## Help!
フロントのコード書ける人助けてください
http://twitter.com/masarakki
