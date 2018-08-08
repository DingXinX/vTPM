# Install dependent packages 

#sudo apt-get update
#sudo apt-get install automake expect gnutls-bin libgnutls-dev git gawk m4 socat fuse libfuse-dev tpm-tools libgmp-dev libtool libglib2.0-dev libnspr4-dev libnss3-dev libssl-dev libtasn1-6-dev

# Configure locales (optional)
#locale-gen en_US.UTF-8 && \
#    dpkg-reconfigure locales

PWD=`pwd`
src=$PWD

libtpms_path=$src/libtpms
swtpm_path=$src/swtpm

# Download libtpms and swtpm code from github

function download_tpm(){

git clone https://github.com/stefanberger/libtpms.git ${src}/libtpms   
git clone https://github.com/stefanberger/swtpm.git ${src}/swtpm

}

# install libtpms thanks to stefanberger

function build_libtpms(){
cd $libtpms_path
./bootstrap.sh
./configure  --with-openssl --with-tpm2                     # support TPM2.0
make -j4
sudo make install
# we need to install again to default dir or swtpm will not install
# see https://github.com/stefanberger/swtpm/issues/18
}

# install swtpm thanks to stefanberger

function build_swtpm(){
cd $swtpm_path
./bootstrap.sh
./configure  --prefix=/usr --with-openssl --with-tpm2
make -j4
sudo make check
sudo make install
sudo cp /usr/etc/swtpm_setup.conf /etc/swtpm_setup.conf
}

read -p "Please input your choice(1|2|3):" num 

case $num in 
    "1")
            download_tpm
            ;;
    "2")
            build_libtpms
            ;;
    "3")
            build_swtpm
            ;;
esac
