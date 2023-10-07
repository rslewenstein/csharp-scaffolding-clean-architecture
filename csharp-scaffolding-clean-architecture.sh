#!/bin/bash

################################
# Author: Rafael S. Lewenstein
# Version: 0.1
# https://github.com/rslewenstein
################################

read -p "Type the project name: " projectName
read -p "Do you want enable cors? (0-No, 1-yes) " enableCors

createMainFolder(){
    mkdir $projectName
    cd $projectName
}

createOtherFiles(){
    touch README.md
    echo "# $projectName" >> README.md

    touch .gitignore
    cat > '.gitignore' << EOT
    .vscode
    csharp-scaffolding-clean-architecture.sh
EOT
}


createMainFolder
createOtherFiles
