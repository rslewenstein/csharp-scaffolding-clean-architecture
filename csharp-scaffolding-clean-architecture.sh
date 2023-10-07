#!/bin/bash

################################
# Author: Rafael S. Lewenstein
# Version: 0.0.1
# https://github.com/rslewenstein
################################

read -p "Type the project name: " projectName
# read -p "Do you want enable cors? (yes = 1 | no = 0): " OptionEnableCors

# if ((! $OptionEnableCors  == yes) || ($OptionEnableCors == no)); then
#     echo "Type yes or no."
#     exit 0
# fi

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
    enableCors
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
    dotnet new webapi -n $projectName.WebApi
}

addDependenciesBetweenProjects(){
    dotnet add $projectName.Application/$projectName.Application.csproj reference $projectName.Domain/$projectName.Domain.csproj
    dotnet add $projectName.Application/$projectName.Application.csproj reference $projectName.Infrastructure/$projectName.Infrastructure.csproj

    dotnet add $projectName.Infrastructure/$projectName.Infrastructure.csproj reference $projectName.Domain/$projectName.Domain.csproj

    dotnet add $projectName.WebApi/$projectName.WebApi.csproj reference $projectName.Application/$projectName.Application.csproj 
    dotnet add $projectName.WebApi/$projectName.WebApi.csproj reference $projectName.Infrastructure/$projectName.Infrastructure.csproj
}

addProjectsDependenciesIntoSln(){
    dotnet sln $projectName.sln add $projectName.Application/$projectName.Application.csproj
    dotnet sln $projectName.sln add $projectName.Infrastructure/$projectName.Infrastructure.csproj
    dotnet sln $projectName.sln add $projectName.WebApi/$projectName.WebApi.csproj
    dotnet sln $projectName.sln add $projectName.Domain/$projectName.Domain.csproj  
}

createSolution(){
    dotnet new sln
    addProjectsDependenciesIntoSln
}

enableCors(){
    cd $projectName.WebApi

    sed -i "9i\ " Program.cs
    sed -i "10i // Habilitando CORS" Program.cs
    sed -i "11i builder.Services.AddCors();" Program.cs

    sed -i "21i\ " Program.cs
    sed -i "22i\ // Habilitando CORS" Program.cs
    sed -i "23i\ app.UseCors(options => options.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());" Program.cs

    cd ..
}


###
createMain