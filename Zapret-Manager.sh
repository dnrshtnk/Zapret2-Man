# ==========================================
# Переменные версий
# ==========================================
ZAPRET_MANAGER_VERSION="9.1"
ZAPRET_VERSION="72.20260226"
ZAPRET2_VERSION="0.9.20260226"
STR_VERSION_AUTOINSTALL="v1"

# ==========================================
# Получение версии
# ==========================================
get_versions() {
    LOCAL_ARCH=$(awk -F\' '/DISTRIB_ARCH/ {print $2}' /etc/openwrt_release)
    [ -z "$LOCAL_ARCH" ] && LOCAL_ARCH=$(opkg print-architecture | grep -v "noarch" | sort -k3 -n | tail -n1 | awk '{print $2}')
    USED_ARCH="$LOCAL_ARCH"
    
    LATEST_URL="https://github.com/remittor/zapret-openwrt/releases/download/v${ZAPRET_VERSION}/zapret_v${ZAPRET_VERSION}_${LOCAL_ARCH}.zip"
    LATEST_URL2="https://github.com/remittor/zapret-openwrt/releases/download/v${ZAPRET2_VERSION}/zapret2_v${ZAPRET2_VERSION}_${LOCAL_ARCH}.zip"
    
    if [ "$PKG_IS_APK" -eq 1 ]; then
        INSTALLED_VER=$(apk info -v | grep '^zapret-' | head -n1 | cut -d'-' -f2 | sed 's/-r[0-9]\+$//')
        INSTALLED_VER2=$(apk info -v | grep '^zapret2-' | head -n1 | cut -d'-' -f2 | sed 's/-r[0-9]\+$//')
    else
        INSTALLED_VER=$(opkg list-installed zapret 2>/dev/null | awk '{sub(/-r[0-9]+$/, "", $3); print $3}')
        INSTALLED_VER2=$(opkg list-installed zapret2 2>/dev/null | awk '{sub(/-r[0-9]+$/, "", $3); print $3}')
    fi
    
    [ -z "$INSTALLED_VER" ] && INSTALLED_VER="не найдена"
    [ -z "$INSTALLED_VER2" ] && INSTALLED_VER2="не найдена"
    
    NFQ_RUN=$(pgrep -f nfqws 2>/dev/null | wc -l)
    NFQ_RUN=${NFQ_RUN:-0}
    NFQ_ALL=$(/etc/init.d/zapret info 2>/dev/null | grep -o 'instance[0-9]\+' | wc -l)
    NFQ_ALL=${NFQ_ALL:-0}
    NFQ_STAT=""
    if [ "$NFQ_ALL" -gt 0 ]; then
        [ "$NFQ_RUN" -eq "$NFQ_ALL" ] && NFQ_CLR="$GREEN" || NFQ_CLR="$RED"
        NFQ_STAT="${NFQ_CLR}[${NFQ_RUN}/${NFQ_ALL}]${NC}"
    fi
    
    if [ -f /etc/init.d/zapret ]; then
        /etc/init.d/zapret status >/dev/null 2>&1 && ZAPRET_STATUS="${GREEN}запущен $NFQ_STAT${NC}" || ZAPRET_STATUS="${RED}остановлен${NC}"
    else
        ZAPRET_STATUS=""
    fi
    
    [ "$INSTALLED_VER" = "$ZAPRET_VERSION" ] && INST_COLOR=$GREEN || INST_COLOR=$RED
    [ "$INSTALLED_VER2" = "$ZAPRET2_VERSION" ] && INST_COLOR2=$GREEN || INST_COLOR2=$RED
    
    INSTALLED_DISPLAY=${INSTALLED_VER:-"не найдена"}
    INSTALLED_DISPLAY2=${INSTALLED_VER2:-"не найдена"}
}

# ==========================================
# Установка Zapret
# ==========================================
install_pkg() {
    local display_name="$1"
    local pkg_file="$2"
    if [ "$PKG_IS_APK" -eq 1 ]; then
        echo -e "${CYAN}Устанавливаем ${NC}$display_name"
        apk add --allow-untrusted "$pkg_file" >/dev/null 2>&1 || {
            echo -e "\n${RED}Не удалось установить $display_name!${NC}\n"
            PAUSE
            return 1
        }
    else
        echo -e "${CYAN}Устанавливаем ${NC}$display_name"
        opkg install --force-reinstall "$pkg_file" >/dev/null 2>&1 || {
            echo -e "\n${RED}Не удалось установить $display_name!${NC}\n"
            PAUSE
            return 1
        }
    fi
}

install_Zapret() {
    local TYPE=${1:-1}
    local NO_PAUSE=${2:-0}
    mkdir -p "$TMP_SF"
    get_versions
    
    if [ "$TYPE" = "2" ]; then
        VER_USE="$ZAPRET2_VERSION"
        PKG_BASE="zapret2"
        URL_BASE="zapret2_v"
        URL_USE="$LATEST_URL2"
    else
        VER_USE="$ZAPRET_VERSION"
        PKG_BASE="zapret"
        URL_BASE="zapret_v"
        URL_USE="$LATEST_URL"
    fi
    
    if [ "$TYPE" = "1" ] && [ "$INSTALLED_VER" = "$VER_USE" ]; then
        echo -e "\n${GREEN}Zapret уже установлен!${NC}\n"
        [ "$NO_PAUSE" != "1" ] && PAUSE
        return
    fi
    
    if [ "$TYPE" = "2" ] && [ "$INSTALLED_VER2" = "$VER_USE" ]; then
        echo -e "\n${GREEN}Zapret2 уже установлен!${NC}\n"
        [ "$NO_PAUSE" != "1" ] && PAUSE
        return
    fi
    
    [ "$NO_PAUSE" != "1" ] && echo
    echo -e "${MAGENTA}Устанавливаем ZAPRET ${TYPE}${NC}"
    
    if [ -f /etc/init.d/zapret ]; then
        echo -e "${CYAN}Останавливаем ${NC}zapret"
        /etc/init.d/zapret stop >/dev/null 2>&1
        for pid in $(pgrep -f /opt/zapret 2>/dev/null); do
            kill -9 "$pid" 2>/dev/null
        done
    fi
    
    echo -e "${CYAN}Обновляем список пакетов${NC}"
    if [ "$PKG_IS_APK" -eq 1 ]; then
        apk update >/dev/null 2>&1 || {
            echo -e "\n${RED}Ошибка при обновлении apk!${NC}\n"
            PAUSE
            return
        }
    else
        opkg update >/dev/null 2>&1 || {
            echo -e "\n${RED}Ошибка при обновлении opkg!${NC}\n"
            PAUSE
            return
        }
    fi
    
    rm -f "$TMP_SF"/* 2>/dev/null
    cd "$TMP_SF" || return
    FILE_NAME=$(basename "$URL_USE")
    
    if ! command -v unzip >/dev/null 2>&1; then
        echo -e "${CYAN}Устанавливаем ${NC}unzip"
        if [ "$PKG_IS_APK" -eq 1 ]; then
            apk add unzip >/dev/null 2>&1 || {
                echo -e "\n${RED}Не удалось установить unzip!${NC}\n"
                PAUSE
                return
            }
        else
            opkg install unzip >/dev/null 2>&1 || {
                echo -e "\n${RED}Не удалось установить unzip!${NC}\n"
                PAUSE
                return
            }
        fi
    fi
    
    echo -e "${CYAN}Скачиваем архив ${NC}$FILE_NAME"
    wget -q -U "Mozilla/5.0" -O "$FILE_NAME" "$URL_USE" || {
        echo -e "\n${RED}Не удалось скачать $FILE_NAME${NC}\n"
        PAUSE
        return
    }
    
    echo -e "${CYAN}Распаковываем архив${NC}"
    unzip -o "$FILE_NAME" >/dev/null
    
    if [ "$PKG_IS_APK" -eq 1 ]; then
        PKG_PATH="$TMP_SF/apk"
        for PKG in "$PKG_PATH"/${PKG_BASE}*; do
            [ -f "$PKG" ] || continue
            echo "$PKG" | grep -q "luci" && continue
            install_pkg "$(basename "$PKG")" "$PKG" || return
        done
        for PKG in "$PKG_PATH"/luci*; do
            [ -f "$PKG" ] || continue
            install_pkg "$(basename "$PKG")" "$PKG" || return
        done
    else
        PKG_PATH="$TMP_SF"
        for PKG in "$PKG_PATH"/${PKG_BASE}_*.ipk; do
            [ -f "$PKG" ] || continue
            install_pkg "$(basename "$PKG")" "$PKG" || return
        done
        for PKG in "$PKG_PATH"/luci-app-${PKG_BASE}_*.ipk; do
            [ -f "$PKG" ] || continue
            install_pkg "$(basename "$PKG")" "$PKG" || return
        done
    fi
    
    echo -e "${CYAN}Удаляем временные файлы${NC}"
    cd /
    rm -rf "$TMP_SF" /tmp/*.ipk /tmp/*.zip /tmp/*zapret* 2>/dev/null
    echo -e "Zapret ${TYPE} ${GREEN}установлен!${NC}\n"
    [ "$NO_PAUSE" != "1" ] && PAUSE
}

# ==========================================
# Удаление Zapret
# ==========================================
pkg_remove() {
    local pkg_name="$1"
    if [ "$PKG_IS_APK" -eq 1 ]; then
        apk del "$pkg_name" >/dev/null 2>&1 || true
    else
        opkg remove --force-depends "$pkg_name" >/dev/null 2>&1 || true
    fi
}

uninstall_zapret() {
    local TYPE=${1:-1}
    local NO_PAUSE=$2
    [ "$NO_PAUSE" != "1" ] && echo
    echo -e "${MAGENTA}Удаляем ZAPRET ${TYPE}${NC}\n${CYAN}Останавливаем ${NC}zapret"
    /etc/init.d/zapret stop >/dev/null 2>&1
    
    echo -e "${CYAN}Убиваем процессы${NC}"
    for pid in $(pgrep -f /opt/zapret 2>/dev/null); do
        kill -9 "$pid" 2>/dev/null
    done
    
    echo -e "${CYAN}Удаляем пакеты${NC}"
    if [ "$TYPE" = "2" ]; then
        pkg_remove zapret2
        pkg_remove luci-app-zapret2
    else
        pkg_remove zapret
        pkg_remove luci-app-zapret
    fi
    
    echo -e "${CYAN}Удаляем временные файлы${NC}"
    rm -rf /opt/zapret /etc/config/zapret /etc/firewall.zapret /etc/init.d/zapret /tmp/*zapret* /var/run/*zapret* /tmp/*.ipk /tmp/*.zip 2>/dev/null
    crontab -l 2>/dev/null | grep -v -i "zapret" | crontab - 2>/dev/null
    nft list tables 2>/dev/null | awk '{print $2}' | grep -E '(zapret|ZAPRET)' | while read t; do
        [ -n "$t" ] && nft delete table "$t" 2>/dev/null
    done
    rm -rf -- "$TMP_SF"
    echo -e "Zapret ${TYPE} ${GREEN}удалён!${NC}\n"
    [ "$NO_PAUSE" != "1" ] && PAUSE
}

# ==========================================
# Меню установки
# ==========================================
install_menu() {
    while true; do
        get_versions
        clear
        echo -e "${MAGENTA}Управление установкой Zapret${NC}\n"
        echo -e "${YELLOW}Zapret 1:${NC} ${INST_COLOR}$INSTALLED_DISPLAY${NC} | ${YELLOW}Zapret 2:${NC} ${INST_COLOR2}$INSTALLED_DISPLAY2${NC}\n"
        
        if [ "$INSTALLED_VER" != "не найдена" ]; then
            ACT1="${GREEN}Удалить${NC}"
        else
            ACT1="${GREEN}Установить${NC}"
        fi
        
        if [ "$INSTALLED_VER2" != "не найдена" ]; then
            ACT2="${GREEN}Удалить${NC}"
        else
            ACT2="${GREEN}Установить${NC}"
        fi
        
        echo -e "${CYAN}1) ${ACT1} Zapret 1 (v${ZAPRET_VERSION})"
        echo -e "${CYAN}2) ${ACT2} Zapret 2 (v${ZAPRET2_VERSION})"
        echo -e "${CYAN}Enter) ${GREEN}Выход в главное меню${NC}"
        echo -ne "${YELLOW}Выберите пункт:${NC} " && read choiceIM
        
        case "$choiceIM" in
            1)
                if [ "$INSTALLED_VER" != "не найдена" ]; then
                    uninstall_zapret 1
                else
                    install_Zapret 1
                fi
                ;;
            2)
                if [ "$INSTALLED_VER2" != "не найдена" ]; then
                    uninstall_zapret 2
                else
                    install_Zapret 2
                fi
                ;;
            *)
                return
                ;;
        esac
    done
}

# ==========================================
# Zapret под ключ
# ==========================================
zapret_key() {
    clear
    echo -e "${MAGENTA}Удаление, установка и настройка Zapret${NC}\n"
    get_versions
    uninstall_zapret 1 "1"
    install_Zapret 1 "1"
    
    [ ! -f /etc/init.d/zapret ] && {
        echo -e "${RED}Zapret не установлен!${NC}\n"
        PAUSE
        return
    }
    
    install_strategy $STR_VERSION_AUTOINSTALL "1"
    echo -e "\n${MAGENTA}Редактируем hosts${NC}\n${CYAN}Добавляем IP и домены в${NC} hosts"
    hosts_add "$ALL_BLOCKS"
    echo -e "IP ${GREEN}и${NC} домены ${GREEN}добавлены в ${NC}hosts${GREEN}!\n"
    Discord_menu "1"
    fix_GAME "1"
    echo -e "Zapret ${GREEN}установлен и настроен!${NC}\n"
    PAUSE
}

# ==========================================
# Главное меню
# ==========================================
show_menu() {
    get_versions
    get_doh_status
    show_current_strategy
    RKN_Check
    mkdir -p "$TMP_SF"
    CURR=$(curr_MIR)
    clear
    
    echo -e "╔════════════════════════════════════╗"
    echo -e "║     ${BLUE}Zapret on remittor Manager${NC}     ║"
    echo -e "╚════════════════════════════════════╝"
    echo -e "${DGRAY}by StressOzz v$ZAPRET_MANAGER_VERSION${NC}"
    
    if [ ! -f /etc/init.d/zapret ]; then
        Z_ACTION_TEXT="Установить"
    elif [ "$INSTALLED_VER" = "$ZAPRET_VERSION" ]; then
        Z_ACTION_TEXT="Удалить"
    else
        Z_ACTION_TEXT="Обновить"
    fi
    
    for pkg in byedpi youtubeUnblock; do
        if [ "$PKG_IS_APK" -eq 1 ]; then
            apk info -e "$pkg" >/dev/null 2>&1 && echo -e "\n${RED}Найден установленный ${NC}$pkg${RED}!${NC}\nZapret${RED} может работать некорректно с ${NC}$pkg${RED}!${NC}"
        else
            opkg list-installed | grep -q "^$pkg" && echo -e "\n${RED}Найден установленный ${NC}$pkg${RED}!${NC}\nZapret${RED} может работать некорректно с ${NC}$pkg${RED}!${NC}"
        fi
    done
    
    if uci get firewall.@defaults[0].flow_offloading 2>/dev/null | grep -q '^1$' || uci get firewall.@defaults[0].flow_offloading_hw 2>/dev/null | grep -q '^1$'; then
        if ! grep -q 'meta l4proto { tcp, udp } ct original packets ge 30 flow offload @ft;' /usr/share/firewall4/templates/ruleset.uc; then
            echo -e "\n${RED}Включён ${NC}Flow Offloading${RED}!${NC}\n${NC}Zapret${RED} некорректно работает с включённым ${NC}Flow Offloading${RED}!\nПримените ${NC}FIX${RED} в системном меню!${NC}"
        fi
    fi
    
    pgrep -f "/opt/zapret" >/dev/null 2>&1 && str_stp_zpr="Остановить" || str_stp_zpr="Запустить"
    
    echo -e "\n${YELLOW}Zapret 1: ${INST_COLOR}$INSTALLED_DISPLAY${NC} | ${YELLOW}Zapret 2: ${INST_COLOR2}$INSTALLED_DISPLAY2${NC}"
    [ -n "$ZAPRET_STATUS" ] && echo -e "${YELLOW}Статус Zapret:${NC}           $ZAPRET_STATUS"
    
    if hosts_enabled; then
        echo -e "${YELLOW}Домены в hosts:          ${GREEN}добавлены${NC}"
    fi
    
    [ -f "$DATE_FILE" ] && echo -e "${YELLOW}Резервная копия:${NC}         ${GREEN}сохранена"
    show_script_50 && [ -n "$name" ] && echo -e "${YELLOW}Установлен скрипт:${NC}       $name"
    grep -q "$Fin_IP_Dis" /etc/hosts && echo -e "${YELLOW}Финские IP для Discord:  ${GREEN}включены${NC}"
    
    [ -f "$CONF" ] && grep -q "option NFQWS_PORTS_UDP.*88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535" "$CONF" && grep -q -- "--filter-udp=88,1024-2407,2409-4499,4501-19293,19345-49999,50101-65535" "$CONF" && echo -e "${YELLOW}Стратегия для игр:${NC}       ${GREEN}включена${NC}"
    
    if [ -n "$DOH_STATUS" ]; then
        if [ "$PKG_IS_APK" -eq 1 ]; then
            apk info -e https-dns-proxy >/dev/null 2>&1 && echo -e "${YELLOW}DNS over HTTPS:${NC}          $DOH_STATUS"
        else
            opkg list-installed | grep -q '^https-dns-proxy ' && echo -e "${YELLOW}DNS over HTTPS:${NC}          $DOH_STATUS"
        fi
    fi
    
    if web_is_enabled; then
        echo -e "${YELLOW}Доступ из браузера:${NC}      $LAN_IP:7681"
    fi
    
    quic_is_blocked && echo -e "${YELLOW}Блокировка QUIC:${NC}         ${GREEN}включена${NC}"
    grep -q 'ct original packets ge 30 flow offload @ft;' /usr/share/firewall4/templates/ruleset.uc && echo -e "${YELLOW}FIX для Flow Offloading:${NC} ${GREEN}включён${NC}"
    [ "$CURR" != "default / OpenWrt" ] && echo -e "${YELLOW}Используется зеркало:${NC}    $CURR"
    
    [ -f "$CONF" ] && line=$(grep -m1 '^#general' "$CONF") && [ -n "$line" ] && echo -e "${YELLOW}Используется стратегия:${NC}  ${CYAN}${line#?}${NC}"
    
    if [ -f "$CONF" ]; then
        current="$ver$( [ -n "$ver" ] && [ -n "$yv_ver" ] && echo " / " )$yv_ver"
        DV=$(grep -o -E '^#[[:space:]]*Dv[0-9][0-9]*' "$CONF" | sed 's/^#[[:space:]]*/\/ /' | head -n1)
        if [ -n "$current" ]; then
            echo -e "${YELLOW}Используется стратегия:${NC}  ${CYAN}$current${DV:+ $DV}${RKN_STATUS:+ $RKN_STATUS}${NC}"
        elif [ -n "$RKN_STATUS" ]; then
            echo -e "${YELLOW}Используется стратегия:${NC}${CYAN}  РКН${DV:+ $DV}${NC}"
        fi
    fi
    
    echo -e "\n${CYAN}1) ${GREEN}Управление установкой Zapret${NC}"
    echo -e "${CYAN}2) ${GREEN}$str_stp_zpr ${NC}Zapret"
    echo -e "${CYAN}3) ${GREEN}Меню стратегий${NC}"
    echo -e "${CYAN}4) ${GREEN}Меню ${NC}DNS over HTTPS"
    echo -e "${CYAN}5) ${GREEN}Меню настройки ${NC}Discord"
    echo -e "${CYAN}6) ${GREEN}Меню управления настройками"
    echo -e "${CYAN}7) ${GREEN}Меню управления доменами в ${NC}hosts"
    echo -e "${CYAN}8) ${GREEN}Удалить ${NC}→${GREEN} установить ${NC}→${GREEN} настроить${NC} Zapret"
    echo -e "${CYAN}0) ${GREEN}Системное меню${NC}"
    echo -ne "${CYAN}Enter) ${GREEN}Выход${NC}\n${YELLOW}Выберите пункт:${NC} " && read choice
    
    case "$choice" in
        888)
            echo
            uninstall_zapret 1 "1"
            install_Zapret 1 "1"
            curl -fsSL https://raw.githubusercontent.com/StressOzz/Test/refs/heads/main/zapret -o "$CONF"
            hosts_add "$ALL_BLOCKS"
            rm -f "$EXCLUDE_FILE"
            wget -q -U "Mozilla/5.0" -O "$EXCLUDE_FILE" "$EXCLUDE_URL"
            ZAPRET_RESTART
            PAUSE
            ;;
        1) install_menu ;;
        2) pgrep -f /opt/zapret >/dev/null 2>&1 && stop_zapret || start_zapret ;;
        3) menu_str ;;
        4) DoH_menu ;;
        5) Discord_menu ;;
        6) backup_menu ;;
        7) menu_hosts ;;
        8) zapret_key ;;
        0) sys_menu ;;
        *) echo; exit 0 ;;
    esac
}

while true; do
    show_menu
done
