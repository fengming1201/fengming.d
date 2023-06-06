# fengming.d
this dir save mybashrc and help file




first time init linux envirence to mybash
step 1:download fengming.d
$cd /etc
$sudo git clone https://github.com/fengming1201/fengming.d.git

make sure download completed
/etc/fengming.d/
├── bash_function_lib
├── cmd_help
├── documents
├── mybashrc
├── README.md
├── sorftware_toolket
├── tmp
└── what_is_by_keyword

step 2:install mybashrc
$bash /etc/fengming.d/sorftware_toolket/install_script/script_install_bashrc_env.sh

check exec result:
if [ -f /etc/fengming.d/mybashrc ];then
        . /etc/fengming.d/mybashrc
fi

step 3:relogin
logout


step 4:install base sorftware with level 1


step 5:install sorftarw packet
$bash sorftware_pagke_install.sh
















