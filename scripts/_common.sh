download_monero () {
    architecture=$(dpkg --print-architecture)

    case "$architecture" in
        "amd64")
            wget --content-disposition -P "$install_dir" "https://downloads.getmonero.org/cli/linux64"
            ;;
        "aarch64" | "arm64")
            wget --content-disposition -P "$install_dir" "https://downloads.getmonero.org/cli/linuxarm8"
            ;;
        "riscv64")
            wget --content-disposition -P "$install_dir" "https://downloads.getmonero.org/cli/linuxriscv64"
            ;;
        "i386")
            wget --content-disposition -P "$install_dir" "https://downloads.getmonero.org/cli/linux32"
            ;;
        # idk which one is the correct one but at least one will work
        "armhf" | "armel" | "armv7")
            wget --content-disposition -P "$install_dir" "https://downloads.getmonero.org/cli/linuxarm7"
            ;;
        *)
            ynh_die "Unsupported architecture: $architecture"
            ;;
    esac
}

extract_monero () {
    # we don't delete the other monero binaries but it should be okay i think. we should have storage for an extra 150~ MB
    find "$install_dir" -type f -name "monero-linux*tar.bz2" -execdir tar xvf {} \;
    find "$install_dir" -type f -name "monero-linux*tar.bz2" -execdir ynh_safe_rm {} \;

    monero_dir=$(find "$install_dir" -type d -name "monero-*")
    find "$monero_dir" -type f -exec mv {} . \;
    ynh_safe_rm "$monero_dir"
}

# making a function that's just this feels bad but idc i like it
download_and_extract_monero () {
    download_monero
    cd "$install_dir"
    sha256sum -c "hashes.txt" --ignore-missing
    extract_monero
}