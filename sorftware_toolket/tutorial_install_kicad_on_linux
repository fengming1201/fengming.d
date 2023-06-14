#！/bin/sh


function install_on_ubuntu
{
    #
    #KiCad operates PPAs that can be used to install KiCad along with its required dependencies. 
    #We recommend that users install from these PPAs rather than the base Ubuntu repository as the latter is usually outdated.
    #

    #Stable Release

    sudo add-apt-repository ppa:kicad/kicad-7.0-releases
    sudo apt update
    sudo apt install kicad

    return 0
}

function install_on_debian
{

    #
    #Debian
    #Stable Release
    #Bookworm (via Backports)
    #Add Backports to sources.list
    # deb http://deb.debian.org/debian bullseye-backports main
    # to sources.list (or add a new file with the ".list" extension to /etc/apt/sources.list.d/).
    # Run apt update or apt-get update
    #
    #

    sudo apt install kicad

    return 0
}

