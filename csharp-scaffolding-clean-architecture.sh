#!/bin/bash

################################
# Author: Rafael S. Lewenstein
# Version: 0.0.1
# https://github.com/rslewenstein
################################

read -p "Type the project name: " projectName
read -p "Do you want enable cors? (yes | no) " enableCors

createMain(){
    mkdir $projectName
    cd $projectName
    createOtherFiles

    createDomainProject
    createApplicationProject
    createInfrastructureProject
    createWebApiProject
    addDependenciesBetweenProjects
    createSolution
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

addDependenciesBetweenProjects(){
    dotnet add $projectName.Application/$projectName.Application.csproj reference $projectName.Domain/$projectName.Domain.csproj
    dotnet add $projectName.Application/$projectName.Application.csproj reference $projectName.Infrastructure/$projectName.Infrastructure.csproj

    dotnet add $projectName.Infrastructure/$projectName.Infrastructure.csproj reference $projectName.Domain/$projectName.Domain.csproj

    dotnet add $projectName.WebApi/$projectName.WebApi.csproj reference $projectName.Application/$projectName.Application.csproj 
    dotnet add $projectName.WebApi/$projectName.WebApi.csproj reference $projectName.Infrastructure/$projectName.Infrastructure.csproj
}

createSolution(){
    dotnet new sln
}

# enableCors(){
#     cd $projectName.WebApi

#     cat program.cs

#     cd ..
# }


###
createMain