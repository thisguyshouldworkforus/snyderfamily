function FolderFromFiles(){
while IFS= read -r BAREFILE
    do
        FOLDERPATH=$(echo "$BAREFILE" | awk -F '/' '{$(NF) = "";print $0}' | tr ' ' '/' | sed 's/\/\//\//g' | sed 's/\/$//g')
        OLDBEAR=$(echo "$BAREFILE" | awk -F '/' '{print $(NF)}')
        NEWBEAR=$(echo "$BAREFILE" | awk -F '/' '{print $(NF)}' | tr "\(\)\'\{\}\,\-\_\ " "." | sed -r 's/\.{2,}/\./g' | sed 's/\.$//g' | tr '[:upper:]' '[:lower:]')
        NEWFOLDER=$(echo "$BAREFILE" | awk -F '/' '{print $(NF)}' | tr "\(\)\'\{\}\,\-\_\ " "." | sed -r 's/\.{2,}/\./g' | sed 's/\.$//g' | tr '[:upper:]' '[:lower:]' | sed -r 's/....$//g')
        mv "${FOLDERPATH}/${OLDBEAR}" "${FOLDERPATH}/${NEWBEAR}"
        mkdir -p "${FOLDERPATH}/${NEWFOLDER}"
        mv "${FOLDERPATH}/${NEWBEAR}" "${FOLDERPATH}/${NEWFOLDER}/"
    done < <(find /opt/apps/nzb_appdata/torrents/complete/ -maxdepth 1 -type f)
}

function FixFiles(){
while IFS= read -r FILE
    do
        FOLDERPATH=$(echo "$FILE" | awk -F '/' '{$(NF) = "";print $0}' | tr ' ' '/' | sed 's/\/\//\//g' | sed 's/\/$//g')
        OLDFILE=$(echo "$FILE" | awk -F '/' '{print $(NF)}')
        NEWFILE=$(echo "$FILE" | awk -F '/' '{print $(NF)}' | tr "\(\)\'\{\}\,\-\_\ " "." | sed -r 's/\.{2,}/\./g' | tr '[:upper:]' '[:lower:]')
        mv "${FOLDERPATH}/${OLDFILE}" "${FOLDERPATH}/${NEWFILE}"
    done < <(find /opt/apps/nzb_appdata/torrents/complete/ -maxdepth 2 -type f)
}

function FixFolders(){
find /opt/apps/nzb_appdata/torrents/complete/ -type d -iname 'screens' -exec rm -rf '{}' \;
find /opt/apps/nzb_appdata/torrents/complete/ -exec chown transmission:media '{}' \;
find /opt/apps/nzb_appdata/torrents/complete/ -type d -exec chmod 770 '{}' \;
find /opt/apps/nzb_appdata/torrents/complete/ -type f -exec chmod 770 '{}' \;
while IFS= read -r FOLDER
    do
        FOLDERPATH=$(echo "$FOLDER" | awk -F '/' '{$(NF) = "";print $0}' | tr ' ' '/' | sed 's/\/\//\//g' | sed 's/\/$//g')
        OLDFOLDER=$(echo "$FOLDER" | awk -F '/' '{print $(NF)}')
        NEWFOLDER=$(echo "$FOLDER" | awk -F '/' '{print $(NF)}' | tr "\(\)\'\{\}\,\-\_\ " "." | sed -r 's/\.{2,}/\./g' | sed 's/\.$//g' | tr '[:upper:]' '[:lower:]')
        mv "${FOLDERPATH}/${OLDFOLDER}" "${FOLDERPATH}/${NEWFOLDER}"
    done < <(find /opt/apps/nzb_appdata/torrents/complete/ -maxdepth 1 -type d | awk 'NR>=2')
}