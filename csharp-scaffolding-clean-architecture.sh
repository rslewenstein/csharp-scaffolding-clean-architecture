#!/bin/bash

################################
# Author: Rafael S. Lewenstein
# Version: 0.0.1
# https://github.com/rslewenstein
################################

read -p "Type the project name: " projectName
read -p "Do you want enable cors? (0-No, 1-yes) " enableCors

createMainFolder(){
    mkdir $projectName
    cd $projectName
    createOtherFiles

    dotnet new classlib -n $projectName.Domain
}

createOtherFiles(){
    touch README.md
    echo "# $projectName" >> README.md

    touch .gitignore
    cat > '.gitignore' << EOT

    # .NET Core
    project.lock.json
    project.fragment.lock.json
    artifacts/

    # VS Code files for those working on multiple tools
    .vscode
    .vscode/*
    !.vscode/settings.json
    !.vscode/tasks.json
    !.vscode/launch.json
    !.vscode/extensions.json
    *.code-workspace

    # Local History for Visual Studio Code
    .history/

    # Windows Installer files from build outputs
    *.cab
    *.msi
    *.msix
    *.msm
    *.msp

    ### DotnetCore ###
    # .NET Core build folders
    bin/
    obj/

    csharp-scaffolding-clean-architecture.sh
EOT
}

createDomainProject(){
   dotnet new classlib -n $projectName.Domain
}

createApplicationProject(){
    dotnet new classlib -n $projectName.Application
}

createInfrastructureProject(){
    dotnet new classlib -n $projectName.Infrastructure
}

createWebApiProject(){
    dotnet new classlib -n $projectName.WebApi
}

# enableCors(){

# }

# addDependenciesBetweenProjects(){

# }

# createSolution(){

# }

###
createMainFolder
createDomainProject
createApplicationProject
createInfrastructureProject
createWebApiProject