# ComiketBrowser for Linux

コミケブラウザがwineでもぜんぶ文字化けして使えないのでLinuxでも使えるコミケブラウザを作ります

## setup
    bundle install
    rake setup /media/cdrom

## run
    ./app.rb (-p PORT_NUM ; default: 3000)

## use
    chromium-browser http://localhost:3000(OR PORT_NUM)/
