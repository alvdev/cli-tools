function playground() {
    case "$1" in
    dart)
        code ~/dev/learning/dart/playground/bin/.
        ;;
    flutter)
        code ~/dev/learning/flutter/playground/lib/.
        ;;
    php)
        code ~/dev/learning/php/playground/.
        ;;
    js)
        code ~/dev/learning/js/playground/.
        ;;
    *)
        echo
        echo "Open playground in VSCode"
        echo "Usage: playground [dart|flutter|php|js]"
        ;;
    esac
}
