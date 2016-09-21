# Update an existing video village install that doesn't have new system requirements


unzip-strip() (
    local zip=$1
    local dest=${2:-.}
    local temp=$(mktemp -d) && unzip -d "$temp" "$zip" && mkdir -p "$dest" &&
    shopt -s dotglob && local f=("$temp"/*) &&
    if (( ${#f[@]} == 1 )) && [[ -d "${f[0]}" ]] ; then
        mv "$temp"/*/* "$dest"
    else
        mv "$temp"/* "$dest"
    fi && rmdir "$temp"/* "$temp"
)

sudo systemctl stop pivideo.service
sudo systemctl stop ngrok.service

sudo rm pivideo -r
sudo rm systemd -r
sudo rm tests -r



curl -L https://github.com/hub-ology/video-village-pi/archive/master.zip -o video-village-pi.zip
unzip-strip video-village-pi.zip

source video-env/bin/activate
pip install -r requirements.txt

# set up file cache directory
sudo mkdir -p /file_cache
sudo chmod 777 /file_cache

sudo systemctl start ngrok.service
sudo systemctl start pivideo.service

deactivate
