#!/bin/sh
# ==========================================
# Zapret
# =========================================
ZAPRET_MANAGER_VERSION="0.1"; ZAPRET_VERSION="72.20260226"; ZAPRET2_VERSION="0.9.20260226"; STR_VERSION_AUTOINSTALL="v1"
TEST_HOST="https://rr1---sn-gvnuxaxjvh-jx3z.googlevideo.com"; LAN_IP=$(uci get network.lan.ipaddr 2>/dev/null | cut -d/ -f1)
GREEN="\033[1;32m"; RED="\033[1;31m"; CYAN="\033[1;36m"; YELLOW="\033[1;33m"; MAGENTA="\033[1;35m"; BLUE="\033[0;34m"; NC="\033[0m"; DGRAY="\033[38;5;244m"
CONF="/etc/config/zapret"; CUSTOM_DIR="/opt/zapret/init.d/openwrt/custom.d/"; HOSTLIST_FILE="/opt/zapret/ipset/zapret-hosts-user.txt"
STR_URL="https://raw.githubusercontent.com/StressOzz/Zapret-Manager/refs/heads/main/ListStrYou"
TMP_SF="/tmp/zapret_temp"; HOSTS_FILE="/etc/hosts"; TMP_LIST="$TMP_SF/zapret_yt_list.txt"
SAVED_STR="$TMP_SF/StrYou.txt"; HOSTS_USER="$TMP_SF/hosts-user.txt"; OUT_DPI="$TMP_SF/dpi_urls.txt"; OUT="$TMP_SF/str_flow.txt"; ZIP="$TMP_SF/repo.zip"
BACKUP_FILE="/opt/zapret/tmp/hosts_temp.txt"; STR_FILE="$TMP_SF/str_test.txt"; TEMP_FILE="$TMP_SF/str_temp.txt"
RESULTS="/opt/zapret/tmp/zapret_bench.txt"; BACK="$TMP_SF/zapret_back.txt"; TMP_RES="$TMP_SF/zapret_results_all.$$"
FINAL_STR="$TMP_SF/StrFINAL.txt"; NEW_STR="$TMP_SF/StrNEW.txt"; OLD_STR="$TMP_SF/StrOLD.txt"
RES1="/opt/zapret/tmp/results_flowseal.txt"; RES2="/opt/zapret/tmp/results_versions.txt"; RES3="/opt/zapret/tmp/results_all.txt"
Fin_IP_Dis="104\.25\.158\.178 finland[0-9]\{5\}\.discord\.media"; PARALLEL=8
RAW="https://raw.githubusercontent.com/hyperion-cs/dpi-checkers/refs/heads/main/ru/tcp-16-20/suite.json"
EXCLUDE_FILE="/opt/zapret/ipset/zapret-hosts-user-exclude.txt"; fileDoH="/etc/config/https-dns-proxy"
RKN_URL="https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/extra_strats/TCP/RKN/List.txt"
EXCLUDE_URL="https://raw.githubusercontent.com/StressOzz/Zapret-Manager/refs/heads/main/zapret-hosts-user-exclude.txt"
INSTAGRAM="#Instagram&Facebook\n57.144.222.34 instagram.com www.instagram.com\n157.240.9.174 instagram.com www.instagram.com\n157.240.245.174 instagram.com www.instagram.com b.i.instagram.com z-p42-chat-e2ee-ig.facebook.com help.instagram.com
157.240.205.174 instagram.com www.instagram.com\n57.144.244.192 static.cdninstagram.com graph.instagram.com i.instagram.com api.instagram.com edge-chat.instagram.com\n31.13.66.63 scontent.cdninstagram.com scontent-hel3-1.cdninstagram.com
57.144.244.1 facebook.com www.facebook.com fb.com fbsbx.com\n57.144.244.128 static.xx.fbcdn.net scontent.xx.fbcdn.net\n31.13.67.20 scontent-hel3-1.xx.fbcdn.net"
TGWeb="#TelegramWeb\n149.154.167.220 api.telegram.org flora.web.telegram.org kws1-1.web.telegram.org kws1.web.telegram.org kws2-1.web.telegram.org kws2.web.telegram.org kws4-1.web.telegram.org
149.154.167.220 kws4.web.telegram.org kws5-1.web.telegram.org kws5.web.telegram.org pluto-1.web.telegram.org pluto.web.telegram.org td.telegram.org telegram.dog
149.154.167.220 telegram.me telegram.org telegram.space telesco.pe venus.web.telegram.org web.telegram.org zws1-1.web.telegram.org zws1.web.telegram.org
149.154.167.220 tg.dev t.me zws2-1.web.telegram.org zws2.web.telegram.org zws4-1.web.telegram.org zws5-1.web.telegram.org zws5.web.telegram.org"
PDA="#4pda\n185.87.51.182 4pda.to www.4pda.to"; NTC="#ntc.party\n130.255.77.28 ntc.party"; TWCH="#Twitch\n45.155.204.190 usher.ttvnw.net gql.twitch.tv"
RUTOR="#rutor\n173.245.58.219 rutor.info d.rutor.info"; LIBRUSEC="#lib.rus.ec\n185.39.18.98 lib.rus.ec www.lib.rus.ec"
AI="#Gemini\n45.155.204.190 gemini.google.com\n#Grok\n45.155.204.190 grok.com accounts.x.ai assets.grok.com
#OpenAI\n45.155.204.190 chatgpt.com ab.chatgpt.com auth.openai.com auth0.openai.com platform.openai.com cdn.oaistatic.com
45.155.204.190 tcr9i.chat.openai.com webrtc.chatgpt.com android.chat.openai.com api.openai.com operator.chatgpt.com
45.155.204.190 sora.chatgpt.com sora.com videos.openai.com ios.chat.openai.com cdn.auth0.com files.oaiusercontent.com
#Microsoft\n45.155.204.190 copilot.microsoft.com sydney.bing.com edgeservices.bing.com rewards.bing.com
45.155.204.190 xsts.auth.xboxlive.com xgpuwebf2p.gssv-play-prod.xboxlive.com xgpuweb.gssv-play-prod.xboxlive.com
#ElevenLabs\n45.155.204.190 elevenlabs.io api.us.elevenlabs.io elevenreader.io api.elevenlabs.io help.elevenlabs.io
#DeepL\n45.155.204.190 deepl.com www.deepl.com www2.deepl.com login-wall.deepl.com w.deepl.com dict.deepl.com ita-free.www.deepl.com
45.155.204.190 write-free.www.deepl.com experimentation.deepl.com experimentation-grpc.deepl.com ita-free.app.deepl.com
45.155.204.190 ott.deepl.com api-free.deepl.com backend.deepl.com clearance.deepl.com errortracking.deepl.com
45.155.204.190 oneshot-free.www.deepl.com checkout.www.deepl.com gtm.deepl.com auth.deepl.com shield.deepl.com
#Claude\n45.155.204.190 claude.ai console.anthropic.com api.anthropic.com
#Trae.ai\n45.155.204.190 trae-api-sg.mchost.guru api.trae.ai api-sg-central.trae.ai api16-normal-alisg.mchost.guru
#Windsurf\n45.155.204.190 windsurf.com codeium.com server.codeium.com web-backend.codeium.com  marketplace.windsurf.com
45.155.204.190 unleash.codeium.com inference.codeium.com windsurf-stable.codeium.com
144.31.14.104 windsurf-telemetry.codeium.com\n#Manus\n45.155.204.190 manus.im api.manus.im\n#Notion\n45.155.204.190 www.notion.so calendar.notion.so
#AIStudio\n45.155.204.190 aistudio.google.com generativelanguage.googleapis.com aitestkitchen.withgoogle.com aisandbox-pa.googleapis.com xsts.auth.xboxlive.com
45.155.204.190 webchannel-alkalimakersuite-pa.clients6.google.com alkalimakersuite-pa.clients6.google.com assistant-s3-pa.googleapis.com
45.155.204.190 proactivebackend-pa.googleapis.com robinfrontend-pa.googleapis.com o.pki.goog labs.google labs.google.com notebooklm.google
45.155.204.190 notebooklm.google.com jules.google.com stitch.withgoogle.com gemini.google.com copilot.microsoft.com edgeservices.bing.com
45.155.204.190 rewards.bing.com sydney.bing.com xboxdesignlab.xbox.com xgpuweb.gssv-play-prod.xboxlive.com xgpuwebf2p.gssv-play-prod.xboxlive.com"
ALL_BLOCKS="$AI\n$INSTAGRAM\n$NTC\n$RUTOR\n$LIBRUSEC\n$TGWeb\n$TWCH"
hosts_enabled() { grep -q "45.144.222.34\|4pda.to\|instagram.com\|rutor.info\|lib.rus.ec\|ntc.party\|twitch.tv\|web.telegram.org" /etc/hosts; }
hosts_add() { printf "%b\n" "$1" | while IFS= read -r L; do grep -qxF "$L" /etc/hosts || echo "$L" >> /etc/hosts; done; /etc/init.d/dnsmasq restart >/dev/null 2>&1; }

# ==========================================
# Функция определения активного init-скрипта
# ==========================================
get_init_script() {
    if [ -f /etc/init.d/zapret2 ]; then
        echo "zapret2"
    elif [ -f /etc/init.d/zapret ]; then
        echo "zapret"
    else
        echo ""
    fi
}

# ==========================================
# Функция получения базового пути
# ==========================================
get_zapret_base() {
    local init_script=$(get_init_script)
    if [ "$init_script" = "zapret2" ]; then
        echo "/opt/zapret2"
    elif [ "$init_script" = "zapret" ]; then
        echo "/opt/zapret"
    else
        echo "/opt/zapret"
    fi
}

# ==========================================
# Перезапуск Zapret (универсальная функция)
# ==========================================
ZAPRET_RESTART () {
    local init_script=$(get_init_script)
    local zapret_base=$(get_zapret_base)
    if [ -n "$init_script" ]; then
        chmod +x "$zapret_base/sync_config.sh" 2>/dev/null
        "$zapret_base/sync_config.sh" 2>/dev/null
        "/etc/init.d/$init_script" restart >/dev/null 2>&1
        sleep 1
    fi
}

# ==========================================
# Получение версии Zapret
# ==========================================
get_versions() {
    LOCAL_ARCH=$(awk -F\' '/DISTRIB_ARCH/ {print $2}' /etc/openwrt_release); [ -z "$LOCAL_ARCH" ] && LOCAL_ARCH=$(opkg print-architecture | grep -v "noarch" | sort -k3 -n | tail -n1 | awk '{print $2}'); USED_ARCH="$LOCAL_ARCH"
    LATEST_URL="https://github.com/remittor/zapret-openwrt/releases/download/v${ZAPRET_VERSION}/zapret_v${ZAPRET_VERSION}_${LOCAL_ARCH}.zip";
    if [ "$PKG_IS_APK" -eq 1 ]; then
        INSTALLED_VER=$(apk info -v | grep '^zapret-' | grep -v '^zapret2-' | head -n1 | cut -d'-' -f2 | sed 's/-r[0-9]\+$//')
        [ -z "$INSTALLED_VER" ] && INSTALLED_VER="не найдена";
    else
        INSTALLED_VER=$(opkg list-installed zapret 2>/dev/null | grep -v '^zapret2' | awk '{sub(/-r[0-9]+$/, "", $3); print $3}');
        [ -z "$INSTALLED_VER" ] && INSTALLED_VER="не найдена";
    fi
    # Используем универсальную проверку для zapret/zapret2
    local init_script=$(get_init_script)
    if [ "$init_script" = "zapret2" ]; then
        NFQ_RUN=$(pgrep -f nfqws2 2>/dev/null | wc -l); NFQ_RUN=${NFQ_RUN:-0};
        NFQ_ALL=$(/etc/init.d/zapret2 info 2>/dev/null | grep -o 'instance[0-9]\+' | wc -l); NFQ_ALL=${NFQ_ALL:-0};
    else
        NFQ_RUN=$(pgrep -f nfqws 2>/dev/null | wc -l); NFQ_RUN=${NFQ_RUN:-0};
        NFQ_ALL=$(/etc/init.d/zapret info 2>/dev/null | grep -o 'instance[0-9]\+' | wc -l); NFQ_ALL=${NFQ_ALL:-0};
    fi
    NFQ_STAT="";
    if [ "$NFQ_ALL" -gt 0 ]; then
        [ "$NFQ_RUN" -eq "$NFQ_ALL" ] && NFQ_CLR="$GREEN" || NFQ_CLR="$RED";
        NFQ_STAT="${NFQ_CLR}[${NFQ_RUN}/${NFQ_ALL}]${NC}";
    fi;
    if [ -n "$init_script" ]; then
        "/etc/init.d/$init_script" status >/dev/null 2>&1 && ZAPRET_STATUS="${GREEN}запущен $NFQ_STAT${NC}" || ZAPRET_STATUS="${RED}остановлен${NC}"
    else
        ZAPRET_STATUS="";
    fi;
    [ "$INSTALLED_VER" = "$ZAPRET_VERSION" ] && INST_COLOR=$GREEN || INST_COLOR=$RED;
    INSTALLED_DISPLAY=${INSTALLED_VER:-"не найдена"};
}

# ==========================================
# Получение версии Zapret2
# ==========================================
get_versions2() { 
    LOCAL_ARCH=$(awk -F\' '/DISTRIB_ARCH/ {print $2}' /etc/openwrt_release); [ -z "$LOCAL_ARCH" ] && LOCAL_ARCH=$(opkg print-architecture | grep -v "noarch" | sort -k3 -n | tail -n1 | awk '{print $2}'); USED_ARCH="$LOCAL_ARCH"
    LATEST_URL2="https://github.com/remittor/zapret-openwrt/releases/download/v${ZAPRET2_VERSION}/zapret2_v${ZAPRET2_VERSION}_${LOCAL_ARCH}.zip"; 
    if [ "$PKG_IS_APK" -eq 1 ]; then 
        INSTALLED_VER2=$(apk info -v | grep '^zapret2-' | head -n1 | cut -d'-' -f2 | sed 's/-r[0-9]\+$//')
        [ -z "$INSTALLED_VER2" ] && INSTALLED_VER2="не найдена"; 
    else 
        INSTALLED_VER2=$(opkg list-installed zapret2 2>/dev/null | awk '{sub(/-r[0-9]+$/, "", $3); print $3}'); 
        [ -z "$INSTALLED_VER2" ] && INSTALLED_VER2="не найдена"; 
    fi
    # Для zapret2 используем свой init-скрипт
    local init_script=$(get_init_script)
    if [ "$init_script" = "zapret2" ]; then
        NFQ_RUN=$(pgrep -f nfqws2 2>/dev/null | wc -l); NFQ_RUN=${NFQ_RUN:-0}; 
        NFQ_ALL=$(/etc/init.d/zapret2 info 2>/dev/null | grep -o 'instance[0-9]\+' | wc -l); NFQ_ALL=${NFQ_ALL:-0}; 
    else
        NFQ_RUN=$(pgrep -f nfqws 2>/dev/null | wc -l); NFQ_RUN=${NFQ_RUN:-0}; 
        NFQ_ALL=$(/etc/init.d/zapret info 2>/dev/null | grep -o 'instance[0-9]\+' | wc -l); NFQ_ALL=${NFQ_ALL:-0}; 
    fi
    NFQ_STAT=""; 
    if [ "$NFQ_ALL" -gt 0 ]; then
        [ "$NFQ_RUN" -eq "$NFQ_ALL" ] && NFQ_CLR="$GREEN" || NFQ_CLR="$RED"; 
        NFQ_STAT="${NFQ_CLR}[${NFQ_RUN}/${NFQ_ALL}]${NC}"; 
    fi; 
    if [ -f /etc/init.d/zapret2 ]; then 
        /etc/init.d/zapret2 status >/dev/null 2>&1 && ZAPRET_STATUS="${GREEN}запущен $NFQ_STAT${NC}" || ZAPRET_STATUS="${RED}остановлен${NC}"
    elif [ -f /etc/init.d/zapret ]; then
        /etc/init.d/zapret status >/dev/null 2>&1 && ZAPRET_STATUS="${GREEN}запущен $NFQ_STAT${NC}" || ZAPRET_STATUS="${RED}остановлен${NC}"
    else 
        ZAPRET_STATUS=""; 
    fi; 
    [ "$INSTALLED_VER2" = "$ZAPRET2_VERSION" ] && INST_COLOR=$GREEN || INST_COLOR=$RED; 
    INSTALLED_DISPLAY=${INSTALLED_VER2:-"не найдена"}; 
}

# ==========================================
# Установка пакетов
# ==========================================
install_pkg() { 
    local display_name="$1"; 
    local pkg_file="$2"; 
    if [ "$PKG_IS_APK" -eq 1 ]; then 
        echo -e "${CYAN}Устанавливаем ${NC}$display_name"; 
        apk add --allow-untrusted "$pkg_file" >/dev/null 2>&1 || { echo -e "\n${RED}Не удалось установить $display_name!${NC}\n"; PAUSE; return 1; } 
    else 
        echo -e "${CYAN}Устанавливаем ${NC}$display_name"; 
        opkg install --force-reinstall "$pkg_file" >/dev/null 2>&1 || { echo -e "\n${RED}Не удалось установить $display_name!${NC}\n"; PAUSE; return 1; }; 
    fi; 
}

# ==========================================
# Установка Zapret
# ==========================================
install_Zapret() { 
    mkdir -p "$TMP_SF"; 
    local NO_PAUSE=$1; 
    get_versions; 
    [ "$INSTALLED_VER" = "$ZAPRET_VERSION" ] && { echo -e "\n${GREEN}Zapret уже установлен!${NC}\n"; [ "$NO_PAUSE" != "1" ] && PAUSE; return; }; 
    [ "$NO_PAUSE" != "1" ] && echo; 
    echo -e "${MAGENTA}Устанавливаем ZAPRET${NC}"
    
    # Удаляем Zapret2 если установлен
    if [ "$PKG_IS_APK" -eq 1 ]; then 
        INST_VER2=$(apk info -v | grep '^zapret2-' | head -n1 | cut -d'-' -f2 | sed 's/-r[0-9]\+$//'); 
    else 
        INST_VER2=$(opkg list-installed zapret2 2>/dev/null | awk '{sub(/-r[0-9]+$/, "", $3); print $3}'); 
    fi
    if [ -n "$INST_VER2" ]; then 
        echo -e "${CYAN}Удаляем ${NC}Zapret2${CYAN} перед установкой ${NC}Zapret"; 
        uninstall_zapret "1"; 
    fi
    
    # Останавливаем правильный init-скрипт
    local init_script=$(get_init_script)
    if [ -n "$init_script" ]; then
        echo -e "${CYAN}Останавливаем ${NC}$init_script"; 
        "/etc/init.d/$init_script" stop >/dev/null 2>&1; 
    fi
    for pid in $(pgrep -f /opt/zapret 2>/dev/null); do kill -9 "$pid" 2>/dev/null; done; 
    echo -e "${CYAN}Обновляем список пакетов${NC}"
    
    if [ "$PKG_IS_APK" -eq 1 ]; then 
        apk update >/dev/null 2>&1 || { echo -e "\n${RED}Ошибка при обновлении apk!${NC}\n"; PAUSE; return; }; 
    else 
        opkg update >/dev/null 2>&1 || { echo -e "\n${RED}Ошибка при обновлении opkg!${NC}\n"; PAUSE; return; }; 
    fi
    
    rm -f "$TMP_SF"/* 2>/dev/null; 
    cd "$TMP_SF" || return; 
    FILE_NAME=$(basename "$LATEST_URL"); 
    if ! command -v unzip >/dev/null 2>&1; then 
        echo -e "${CYAN}Устанавливаем ${NC}unzip"; 
        if [ "$PKG_IS_APK" -eq 1 ]; then
            apk add unzip >/dev/null 2>&1 || { echo -e "\n${RED}Не удалось установить unzip!${NC}\n"; PAUSE; return; }; 
        else 
            opkg install unzip >/dev/null 2>&1 || { echo -e "\n${RED}Не удалось установить unzip!${NC}\n"; PAUSE; return; }; 
        fi; 
    fi
    echo -e "${CYAN}Скачиваем архив ${NC}$FILE_NAME"; 
    wget -q -U "Mozilla/5.0" -O "$FILE_NAME" "$LATEST_URL" || { echo -e "\n${RED}Не удалось скачать $FILE_NAME${NC}\n"; PAUSE; return; }; 
    echo -e "${CYAN}Распаковываем архив${NC}"
    unzip -o "$FILE_NAME" >/dev/null; 
    if [ "$PKG_IS_APK" -eq 1 ]; then 
        PKG_PATH="$TMP_SF/apk"; 
        for PKG in "$PKG_PATH"/zapret*; do [ -f "$PKG" ] || continue; echo "$PKG" | grep -q "luci" && continue; install_pkg "$(basename "$PKG")" "$PKG" || return; done
        for PKG in "$PKG_PATH"/luci*; do [ -f "$PKG" ] || continue; install_pkg "$(basename "$PKG")" "$PKG" || return; done; 
    else 
        PKG_PATH="$TMP_SF"; 
        for PKG in "$PKG_PATH"/zapret_*.ipk; do [ -f "$PKG" ] || continue; install_pkg "$(basename "$PKG")" "$PKG" || return; done
        for PKG in "$PKG_PATH"/luci-app-zapret_*.ipk; do [ -f "$PKG" ] || continue; install_pkg "$(basename "$PKG")" "$PKG" || return; done; 
    fi; 
    echo -e "${CYAN}Удаляем временные файлы${NC}"; 
    cd /
    rm -rf "$TMP_SF" /tmp/*.ipk /tmp/*.zip /tmp/*zapret* 2>/dev/null; 
    echo -e "Zapret ${GREEN}установлен!${NC}\n"; 
    [ "$NO_PAUSE" != "1" ] && PAUSE; 
}

# ==========================================
# Установка Zapret2
# ==========================================
install_Zapret2() { 
    mkdir -p "$TMP_SF"; 
    local NO_PAUSE=$1; 
    get_versions2; 
    [ "$INSTALLED_VER2" = "$ZAPRET2_VERSION" ] && { echo -e "\n${GREEN}Zapret2 уже установлен!${NC}\n"; [ "$NO_PAUSE" != "1" ] && PAUSE; return; }; 
    [ "$NO_PAUSE" != "1" ] && echo; 
    echo -e "${MAGENTA}Устанавливаем ZAPRET2${NC}"
    
    # Удаляем Zapret если установлен
    if [ "$PKG_IS_APK" -eq 1 ]; then 
        INST_VER1=$(apk info -v | grep '^zapret-' | grep -v '^zapret2-' | head -n1 | cut -d'-' -f2 | sed 's/-r[0-9]\+$//'); 
    else 
        INST_VER1=$(opkg list-installed zapret 2>/dev/null | grep -v '^zapret2' | awk '{sub(/-r[0-9]+$/, "", $3); print $3}'); 
    fi
    if [ -n "$INST_VER1" ] && [ "$INST_VER1" != "не найдена" ]; then 
        echo -e "${CYAN}Удаляем ${NC}Zapret${CYAN} перед установкой ${NC}Zapret2"; 
        uninstall_zapret "1"; 
    fi
    
    # Останавливаем правильный init-скрипт
    local init_script=$(get_init_script)
    if [ -n "$init_script" ]; then
        echo -e "${CYAN}Останавливаем ${NC}$init_script"; 
        "/etc/init.d/$init_script" stop >/dev/null 2>&1; 
    fi
    for pid in $(pgrep -f /opt/zapret 2>/dev/null); do kill -9 "$pid" 2>/dev/null; done; 
    echo -e "${CYAN}Обновляем список пакетов${NC}"
    
    if [ "$PKG_IS_APK" -eq 1 ]; then 
        apk update >/dev/null 2>&1 || { echo -e "\n${RED}Ошибка при обновлении apk!${NC}\n"; PAUSE; return; }; 
    else 
        opkg update >/dev/null 2>&1 || { echo -e "\n${RED}Ошибка при обновлении opkg!${NC}\n"; PAUSE; return; }; 
    fi
    
    rm -f "$TMP_SF"/* 2>/dev/null; 
    cd "$TMP_SF" || return; 
    FILE_NAME=$(basename "$LATEST_URL2"); 
    if ! command -v unzip >/dev/null 2>&1; then 
        echo -e "${CYAN}Устанавливаем ${NC}unzip"; 
        if [ "$PKG_IS_APK" -eq 1 ]; then
            apk add unzip >/dev/null 2>&1 || { echo -e "\n${RED}Не удалось установить unzip!${NC}\n"; PAUSE; return; }; 
        else 
            opkg install unzip >/dev/null 2>&1 || { echo -e "\n${RED}Не удалось установить unzip!${NC}\n"; PAUSE; return; }; 
        fi; 
    fi
    echo -e "${CYAN}Скачиваем архив ${NC}$FILE_NAME"; 
    wget -q -U "Mozilla/5.0" -O "$FILE_NAME" "$LATEST_URL2" || { echo -e "\n${RED}Не удалось скачать $FILE_NAME${NC}\n"; PAUSE; return; }; 
    echo -e "${CYAN}Распаковываем архив${NC}"
    unzip -o "$FILE_NAME" >/dev/null; 
    if [ "$PKG_IS_APK" -eq 1 ]; then 
        PKG_PATH="$TMP_SF/apk"; 
        for PKG in "$PKG_PATH"/zapret2*; do [ -f "$PKG" ] || continue; echo "$PKG" | grep -q "luci" && continue; install_pkg "$(basename "$PKG")" "$PKG" || return; done
        for PKG in "$PKG_PATH"/luci*; do [ -f "$PKG" ] || continue; install_pkg "$(basename "$PKG")" "$PKG" || return; done; 
    else 
        PKG_PATH="$TMP_SF"; 
        for PKG in "$PKG_PATH"/zapret2_*.ipk; do [ -f "$PKG" ] || continue; install_pkg "$(basename "$PKG")" "$PKG" || return; done
        for PKG in "$PKG_PATH"/luci-app-zapret2_*.ipk; do [ -f "$PKG" ] || continue; install_pkg "$(basename "$PKG")" "$PKG" || return; done; 
    fi; 
    echo -e "${CYAN}Удаляем временные файлы${NC}"; 
    cd /
    rm -rf "$TMP_SF" /tmp/*.ipk /tmp/*.zip /tmp/*zapret* 2>/dev/null; 
    echo -e "Zapret2 ${GREEN}установлен!${NC}\n"; 
    [ "$NO_PAUSE" != "1" ] && PAUSE; 
    return 0; 
}

# ==========================================
# Универсальная функция остановки Zapret/Zapret2
# ==========================================
stop_zapret() { 
    local NO_PAUSE=$1; 
    local init_script=$(get_init_script)
    local zapret_base=$(get_zapret_base)
    
    if [ -z "$init_script" ]; then
        echo -e "\n${RED}Zapret не установлен!${NC}\n"; 
        [ "$NO_PAUSE" != "1" ] && PAUSE; 
        return; 
    fi
    
    echo -e "\n${MAGENTA}Останавливаем Zapret${NC}\n${CYAN}Останавливаем ${NC}$init_script"; 
    "/etc/init.d/$init_script" stop >/dev/null 2>&1
    for pid in $(pgrep -f "$zapret_base" 2>/dev/null); do kill -9 "$pid" 2>/dev/null; done; 
    echo -e "Zapret ${GREEN}остановлен!${NC}\n"; 
    [ "$NO_PAUSE" != "1" ] && PAUSE; 
}

# ==========================================
# Универсальная функция запуска Zapret/Zapret2
# ==========================================
start_zapret() { 
    local init_script=$(get_init_script)
    local zapret_base=$(get_zapret_base)
    
    if [ -z "$init_script" ]; then
        echo -e "\n${RED}Zapret не установлен!${NC}\n"; 
        [ "$NO_PAUSE" != "1" ] && PAUSE; 
        return; 
    fi
    
    echo -e "\n${MAGENTA}Запускаем Zapret${NC}"; 
    echo -e "${CYAN}Запускаем ${NC}$init_script"; 
    "/etc/init.d/$init_script" start >/dev/null 2>&1; 
    ZAPRET_RESTART
    echo -e "Zapret ${GREEN}запущен!${NC}\n"; 
    [ "$NO_PAUSE" != "1" ] && PAUSE; 
}

# ==========================================
# Удаление Zapret (универсальная функция)
# ==========================================
pkg_remove() { 
    local pkg_name="$1"; 
    if [ "$PKG_IS_APK" -eq 1 ]; then 
        apk del "$pkg_name" >/dev/null 2>&1 || true; 
    else 
        opkg remove --force-depends "$pkg_name" >/dev/null 2>&1 || true; 
    fi; 
}

uninstall_zapret() { 
    local NO_PAUSE=$1; 
    [ "$NO_PAUSE" != "1" ] && echo; 
    echo -e "${MAGENTA}Удаляем ZAPRET${NC}\n${CYAN}Останавливаем ${NC}zapret"; 
    
    # Определяем активный init-скрипт и останавливаем его
    local init_script=$(get_init_script)
    if [ -n "$init_script" ]; then
        "/etc/init.d/$init_script" stop >/dev/null 2>&1; 
    fi
    
    echo -e "${CYAN}Убиваем процессы${NC}"
    for pid in $(pgrep -f /opt/zapret 2>/dev/null); do kill -9 "$pid" 2>/dev/null; done; 
    echo -e "${CYAN}Удаляем пакеты${NC}"; 
    pkg_remove zapret; 
    pkg_remove zapret2; 
    pkg_remove luci-app-zapret; 
    pkg_remove luci-app-zapret2; 
    
    echo -e "${CYAN}Удаляем временные файлы${NC}"
    rm -rf /opt/zapret /opt/zapret2 /etc/config/zapret /etc/firewall.zapret /etc/init.d/zapret /etc/init.d/zapret2 /tmp/*zapret* /var/run/*zapret* /tmp/*.ipk /tmp/*.zip 2>/dev/null; 
    crontab -l 2>/dev/null | grep -v -i "zapret" | crontab - 2>/dev/null
    nft list tables 2>/dev/null | awk '{print $2}' | grep -E '(zapret|ZAPRET)' | while read t; do [ -n "$t" ] && nft delete table "$t" 2>/dev/null; done; 
    rm -rf -- "$TMP_SF"; 
    echo -e "Zapret ${GREEN}удалён!${NC}\n"; 
    [ "$NO_PAUSE" != "1" ] && PAUSE; 
}

# ==========================================
# Discord menu - исправленная версия
# ==========================================
show_script_50() { 
    local zapret_base=$(get_zapret_base)
    [ -f "$zapret_base/init.d/openwrt/custom.d/50-script.sh" ] || return; 
    line=$(head -n1 "$zapret_base/init.d/openwrt/custom.d/50-script.sh")
    name=$(case "$line" in *QUIC*) echo "50-quic4all";; *stun*) echo "50-stun4all";; *"discord media"*) echo "50-discord-media";; *"discord subnets"*) echo "50-discord";; *) echo "";; esac); 
}

Discord_menu() {
    # Проверка для Zapret
    if [ -f /etc/init.d/zapret ]; then ZAPRET1_INST="${GREEN}установлен${NC}"; else ZAPRET1_INST="${RED}не установлен${NC}"; fi
    # Проверка для Zapret2
    if [ -f /etc/init.d/zapret2 ]; then ZAPRET2_INST="${GREEN}установлен${NC}"; else ZAPRET2_INST="${RED}не установлен${NC}"; fi
    
    local NO_PAUSE=$1;
    while true; do
        [ "$NO_PAUSE" != "1" ] && clear && echo -e "${MAGENTA}Меню настройки Discord${NC}\n"
        echo -e "${YELLOW}Zapret:${NC}   $ZAPRET1_INST"
        echo -e "${YELLOW}Zapret2:${NC}  $ZAPRET2_INST\n"
        output_shown=false

        # Определяем активный init-скрипт для проверок
        local init_script=$(get_init_script)
        local zapret_base=$(get_zapret_base)

        [ "$NO_PAUSE" != "1" ] && [ -n "$init_script" ] && show_script_50 && [ -n "$name" ] && echo -e "${YELLOW}Установлен скрипт:${NC} $name" && output_shown=true
        [ "$NO_PAUSE" != "1" ] && grep -q "$Fin_IP_Dis" /etc/hosts && echo -e "${YELLOW}Финские IP для Discord: ${GREEN}включены${NC}" && output_shown=true
        [ "$NO_PAUSE" != "1" ] && [ -n "$init_script" ] && NUMDv=$(grep -o -E '^#[[:space:]]*Dv[0-9][0-9]*' "$CONF" | sed 's/[^0-9]//g' | head -n1) && [ -n "$NUMDv" ] && echo -e "${YELLOW}Стратегия для discord.media: ${CYAN}Dv$NUMDv${NC}"  && output_shown=true
        $output_shown && echo;
        
        if [ "$NO_PAUSE" = "1" ]; then 
            SELECTED="50-stun4all"; 
            URL="https://raw.githubusercontent.com/bol-van/zapret/master/init.d/custom.d.examples.linux/50-stun4all"; 
        else
            echo -e "${CYAN}1) ${GREEN}Установить скрипт ${NC}50-stun4all\n${CYAN}2) ${GREEN}Установить скрипт ${NC}50-quic4all\n${CYAN}3) ${GREEN}Установить скрипт ${NC}50-discord-media\n${CYAN}4) ${GREEN}Установить скрипт ${NC}50-discord\n${CYAN}5) ${GREEN}Удалить скрипт${NC}"
            grep -q '104\.25\.158\.178 finland[0-9]\{5\}\.discord\.media' /etc/hosts && FIN_TXT="${GREEN}Удалить Финские ${NC}IP ${GREEN}из ${NC}hosts" || FIN_TXT="${GREEN}Добавить ${NC}Финские IP ${GREEN}в ${NC}hosts"
            echo -ne "${CYAN}6) $FIN_TXT\n${CYAN}7) ${GREEN}Выбрать и установить стратегию для ${NC}discord.media\n${CYAN}8) ${GREEN}Настройки Discord для Zapret2${NC} ${RED}(в разработке)${NC}\n${CYAN}Enter) ${GREEN}Выход в главное меню${NC}\n\n${YELLOW}Выберите пункт:${NC} " && read choiceSC; 
            case "$choiceSC" in
                1) SELECTED="50-stun4all"; URL="https://raw.githubusercontent.com/bol-van/zapret/master/init.d/custom.d.examples.linux/50-stun4all";; 
                2) SELECTED="50-quic4all"; URL="https://raw.githubusercontent.com/bol-van/zapret/master/init.d/custom.d.examples.linux/50-quic4all";;
                3) SELECTED="50-discord-media"; URL="https://raw.githubusercontent.com/bol-van/zapret/master/init.d/custom.d.examples.linux/50-discord-media";; 
                4) SELECTED="50-discord"; URL="https://raw.githubusercontent.com/bol-van/zapret/v70.5/init.d/custom.d.examples.linux/50-discord";;
                5) 
                    # Проверка для любого из init-скриптов
                    if [ -z "$init_script" ]; then 
                        echo -e "\n${RED}Zapret не установлен!${NC}\n"; 
                        PAUSE; 
                        continue; 
                    fi
                    echo -e "\n${MAGENTA}Удаляем скрипт${NC}"; 
                    rm -f "$zapret_base/init.d/openwrt/custom.d/50-script.sh" 2>/dev/null; 
                    sed -i "/DISABLE_CUSTOM/s/'0'/'1'/" /etc/config/zapret; 
                    ZAPRET_RESTART; 
                    echo -e "${GREEN}Скрипт удалён!${NC}\n"; 
                    PAUSE; 
                    continue;;
                6) toggle_finland_hosts; continue;; 
                7) switch_Dv; continue;; 
                8) echo -e "\n${YELLOW}Настройки Discord для Zapret2${NC}\n\n${RED}Функционал в разработке!${NC}\n"; PAUSE; continue;; 
                *) return;; 
            esac; 
        fi; 
        
        # Проверка для любого из init-скриптов
        if [ -z "$init_script" ]; then 
            echo -e "\n${RED}Zapret не установлен!${NC}\n"; 
            PAUSE; 
            continue; 
        fi
        
        if wget -q -U "Mozilla/5.0" -O "$zapret_base/init.d/openwrt/custom.d/50-script.sh" "$URL"; then 
            [ "$NO_PAUSE" != "1" ] && echo; 
            echo -e "${MAGENTA}Устанавливаем скрипт${NC}\n${GREEN}Скрипт ${NC}$SELECTED${GREEN} успешно установлен!${NC}\n"; 
        else 
            echo -e "\n${RED}Ошибка при скачивании скрипта!${NC}\n"; 
            PAUSE; 
            continue; 
        fi
        sed -i "/DISABLE_CUSTOM/s/'1'/'0'/" /etc/config/zapret; 
        ZAPRET_RESTART; 
        [ "$NO_PAUSE" != "1" ] && PAUSE; 
        [ "$NO_PAUSE" = "1" ] && break; 
    done 
}

# ==========================================
# FIX GAME - исправленная версия
# ==========================================
fix_GAME() { 
    local NO_PAUSE=$1; 
    local init_script=$(get_init_script)
    
    if [ -z "$init_script" ]; then 
        echo -e "\n${RED}Zapret не установлен!${NC}\n"; 
        PAUSE; 
        return; 
    fi
    
    [ "$NO_PAUSE" != "1" ] && echo; 
    echo -e "${MAGENTA}Настраиваем стратегию для игр${NC}"; 
    
    if grep -q "option NFQWS_PORTS_UDP.*88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535" "$CONF" && grep -q -- "--filter-udp=88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535" "$CONF"; then 
        echo -e "${CYAN}Удаляем настройки для игр${NC}"
        sed -i ':a;N;$!ba;s|#Gv1\n--new\n--filter-udp=88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535\n--dpi-desync=fake\n--dpi-desync-cutoff=d2\n--dpi-desync-any-protocol=1\n--dpi-desync-fake-unknown-udp=/opt/zapret/files/fake/quic_initial_www_google_com\.bin\n--new\n--filter-tcp=25565,50001\n--dpi-desync-any-protocol=1\n--dpi-desync-cutoff=n5\n--dpi-desync=multisplit\n--dpi-desync-split-seqovl=582\n--dpi-desync-split-pos=1\n--dpi-desync-split-seqovl-pattern=/opt/zapret/files/fake/4pda\.bin\n*||g' "$CONF"
        sed -i "s/,88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535//" "$CONF"; 
        sed -i "/^[[:space:]]*option NFQWS_PORTS_TCP '/s/,25565,50001//" "$CONF"; 
        ZAPRET_RESTART; 
        echo -e "${GREEN}Игровая стратегия удалена!${NC}\n"; 
        PAUSE; 
        return; 
    fi
    
    if ! grep -q "option NFQWS_PORTS_UDP.*88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535" "$CONF"; then 
        sed -i "/^[[:space:]]*option NFQWS_PORTS_UDP '/s/'$/,88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535'/" "$CONF"; 
    fi; 
    
    if ! grep -q -- "--filter-udp=88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535" "$CONF"; then 
        last_line=$(grep -n "^'$" "$CONF" | tail -n1 | cut -d: -f1); 
        if [ -n "$last_line" ]; then 
            sed -i "${last_line},\$d" "$CONF"; 
        fi
        printf "%s\n" "#Gv1" "--new" "--filter-udp=88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535" "--dpi-desync=fake" "--dpi-desync-cutoff=d2" "--dpi-desync-any-protocol=1" "--dpi-desync-fake-unknown-udp=/opt/zapret/files/fake/quic_initial_www_google_com.bin" "--new" "--filter-tcp=25565,50001" "--dpi-desync-any-protocol=1" "--dpi-desync-cutoff=n5" "--dpi-desync=multisplit" "--dpi-desync-split-seqovl=582" "--dpi-desync-split-pos=1" "--dpi-desync-split-seqovl-pattern=/opt/zapret/files/fake/4pda.bin" "'" >> "$CONF"; 
    fi
    
    echo -e "${CYAN}Включаем настройки для игр${NC}"; 
    if ! grep -q "option NFQWS_PORTS_TCP.*,25565,50001" "$CONF"; then 
        sed -i "/^[[:space:]]*option NFQWS_PORTS_TCP '/s/'$/,25565,50001'/" "$CONF"; 
    fi; 
    ZAPRET_RESTART; 
    echo -e "${GREEN}Игровая стратегия включена!${NC}\n";
    [ "$NO_PAUSE" != "1" ] && PAUSE; 
}

# ==========================================
# Zapret под ключ - исправленная версия
# ==========================================
zapret_key() { 
    clear; 
    echo -e "${MAGENTA}Удаление, установка и настройка Zapret${NC}\n"; 
    get_versions; 
    uninstall_zapret "1"; 
    install_Zapret "1"
    
    local init_script=$(get_init_script)
    if [ -z "$init_script" ]; then 
        echo -e "${RED}Zapret не установлен!${NC}\n"; 
        PAUSE; 
        return; 
    fi
    
    install_strategy $STR_VERSION_AUTOINSTALL "1"; 
    echo -e "\n${MAGENTA}Редактируем hosts${NC}\n${CYAN}Добавляем IP и домены в${NC} hosts"
    hosts_add "$ALL_BLOCKS"; 
    echo -e "IP ${GREEN}и${NC} домены ${GREEN}добавлены в ${NC}hosts${GREEN}!${NC}\n"; 
    Discord_menu "1"; 
    fix_GAME "1"; 
    echo -e "Zapret ${GREEN}установлен и настроен!${NC}\n"; 
    PAUSE; 
}

# ==========================================
# Меню настроек - исправленные функции
# ==========================================
restore_default() { 
    local zapret_base=$(get_zapret_base)
    
    if [ -f "$zapret_base/restore-def-cfg.sh" ]; then 
        echo -e "\n${MAGENTA}Возвращаем настройки по умолчанию${NC}"; 
        rm -f "$zapret_base/init.d/openwrt/custom.d/50-script.sh"; 
        for i in 1 2 3 4; do rm -f "$zapret_base/ipset/cust$i.txt"; done
        
        local init_script=$(get_init_script)
        if [ -n "$init_script" ]; then
            "/etc/init.d/$init_script" stop >/dev/null 2>&1; 
        fi
        
        echo -e "${CYAN}Возвращаем ${NC}настройки${CYAN}, ${NC}стратегию${CYAN} и ${NC}hostlist${CYAN} к значениям по умолчанию${NC}"; 
        cp -f "$zapret_base/ipset_def/*" "$zapret_base/ipset/" 2>/dev/null
        chmod +x "$zapret_base/restore-def-cfg.sh" && "$zapret_base/restore-def-cfg.sh"; 
        ZAPRET_RESTART; 
        echo -e "${GREEN}Настройки по умолчанию возвращены!${NC}\n"; 
    else 
        echo -e "\n${RED}Zapret не установлен!${NC}\n"; 
    fi; 
    PAUSE; 
}

save_backup() { 
    local init_script=$(get_init_script)
    local zapret_base=$(get_zapret_base)
    
    if [ -z "$init_script" ]; then 
        echo -e "\n${RED}Zapret не установлен!${NC}\n"; 
        PAUSE; 
        return; 
    fi
    
    rm -rf "$BACKUP_DIR"; 
    mkdir -p "$BACKUP_DIR"; 
    tar -czf "$BACKUP_DIR/zapret.tar.gz" -C /opt zapret 2>/dev/null
    cp -p /etc/config/zapret "$BACKUP_DIR/"; 
    printf '%s / %s\n' "$(date '+%d.%m.%y')" "$(du -sh /opt/zapret_backup 2>/dev/null | cut -f1 | sed -E 's/\.0K$/K/;s/K$/ КБ/;s/M$/ МБ/')" > "$DATE_FILE"
    echo -e "\n${GREEN}Настройки сохранены в${NC} $BACKUP_DIR\n"; 
    PAUSE; 
}

restore_backup() { 
    local init_script=$(get_init_script)
    
    if [ -z "$init_script" ]; then 
        echo -e "\n${RED}Zapret не установлен!${NC}\n"; 
        PAUSE; 
        return; 
    fi
    
    [ ! -f "$BACKUP_DIR/zapret.tar.gz" ] && { echo -e "\n${RED}Резервная копия не найдена!${NC}\n"; PAUSE; return; }
    echo -e "\n${MAGENTA}Восстанавливаем настройки из резервной копии${NC}"; 
    "/etc/init.d/$init_script" stop >/dev/null 2>&1; 
    rm -rf /opt/zapret /opt/zapret2; 
    rm -f /etc/config/zapret; 
    mkdir -p /opt; 
    tar -xzf "$BACKUP_DIR/zapret.tar.gz" -C /opt 2>/dev/null
    [ -f "$BACKUP_DIR/zapret" ] && cp -p "$BACKUP_DIR/zapret" /etc/config/zapret; 
    echo -e "${CYAN}Применяем настройки${NC}"; 
    ZAPRET_RESTART; 
    echo -e "${GREEN}Настройки восстановлены из резервной копии!${NC}\n"; 
    PAUSE; 
}

# ==========================================
# check_zpr_off - исправленная версия
# ==========================================
check_zpr_off() { 
    echo -e "\n${CYAN}Контрольный тест: ${YELLOW}Zapret выключен${NC}"; 
    local init_script=$(get_init_script)
    if [ -n "$init_script" ]; then
        "/etc/init.d/$init_script" stop >/dev/null 2>&1; 
    fi
    OK=0; 
    check_all_urls; 
    if [ "$OK" -eq "$TOTAL" ]; then 
        COLOR="${GREEN}"; 
    elif [ "$OK" -ge $((TOTAL/2)) ]; then 
        COLOR="${YELLOW}"; 
    else 
        COLOR="${RED}"; 
    fi; 
    echo -e "${CYAN}Результат теста: ${COLOR}$OK/$TOTAL${NC}"; 
    echo -e "Контрольный тест (Zapret выключен) → ${OK}/${TOTAL}" >> "$RESULTS"; 
    if [ -n "$init_script" ]; then
        "/etc/init.d/$init_script" start >/dev/null 2>&1; 
    fi
}
