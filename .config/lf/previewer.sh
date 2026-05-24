#!/bin/bash

case "$1" in

    *.pdf)
        author=$(exiftool -Author -T -f "$1"); [[ $author == "-" ]] && author=""
        title=$(exiftool -Title -T -f "$1"); [[ $title == "-" ]] && title=""
        printf "\033[30;47;1mPDF\033[0m "
        if [[ -n $author && -n $title ]]; then
            printf "\033[0;3;4m$author: \033[0m\033[0;4;1m$title\033[0m"
        elif [[ -n $author ]]; then
            printf "\033[0;3;4m$author\033[0m"
        elif [[ -n $title ]]; then
            printf "\033[0;4;1m$title\033[0m"
        fi
        printf "\n\n"
        pdftotext -l 5 "$1" - ;;

    *.png | *.jpg | *.jpeg | *.webp | *.svg | *.gif)
        printf "\033[30;47;1mIMAGE\033[0m\n\n"
        exiftool -FileType -ImageSize -Megapixels -Compression "$1" ;;

    *.mp4 | *.mkv | *.mov)
        printf "\033[30;47;1mVIDEO\033[0m\n\n"
        exiftool -FileType -Duration -ImageSize -CompressorID -AudioFormat \
            -AvgBitrate "$1" ;;

    *.mp3 | *.wav | *.m4a | *.m4b | *.flac | *.opus)
        printf "\033[30;47;1mAUDIO\033[0m\n\n"
        exiftool -Artist -Title -Year -Album -Genre -Comment -Duration \
            -FileType -SampleRate -ChannelMode -AudioBitrate "$1" ;;

    *.mobi | *.epub)
        printf "\033[30;47;1mBOOK\033[0m\n\n" ;;

    *.zip)
        printf "\033[30;47;1mZIP\033[0m \033[0;3;4mOpen to Extract\033[0m\n\n"
        unzip -l "$1" | tail -n +2 ;;

    *.tar* | *.rar | *.7z | *.gz | *.tgz)
        printf "\033[30;47;1mARCHIVE\033[0m" ;;

    *)
        printf "\033[30;47;1mTEXT\033[0m\n\n"
        highlight -O ansi --max-size 64M --line-length=60 --wrap-simple "$1" ;;

esac
