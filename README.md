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

### use
    chromium-browser http://localhost:4567(OR PORT_NUM)/

## Help!
フロントのコード書ける人助けてください
http://twitter.com/masarakki
