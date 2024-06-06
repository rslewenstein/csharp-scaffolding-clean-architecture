#!/bin/bash

cat << EOT 

/*************************************/
/* C# Clean Architecture Scaffolding */
/* .Net >= 6                         */
/* Version: 0.0.1                    */
/*                                   */
/* Author: Rafael S. Lewenstein      */
/* https://github.com/rslewenstein   */
/*************************************/

EOT

read -p "Type the project name: " projectName

if [ "$projectName" = "" ]; 
then
    echo -e "\033[1;91mEnter a valid name\033"
    exit 0
fi

read -p "Do you want enable CORS? (Type Y to accept or press ENTER to skip): " optionEnableCors

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
    
    if [ $optionEnableCors = "y" ] || [ $optionEnableCors = "Y" ]; 
    then
        enableCors
    fi

    echo -e "\033[1;32mProjects were created!\033"
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

    sed -i "1i var  MyAllowSpecificOrigins = "'"_myAllowSpecificOrigins"'";" Program.cs
    sed -i "9i\ " Program.cs
    sed -i "4i // Habilitando CORS" Program.cs
    sed -i "5i builder.Services.AddCors(options => {options.AddPolicy(MyAllowSpecificOrigins, policy =>{policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();});});" Program.cs
    sed -i "6i\ " Program.cs

    sed -i "21i\ " Program.cs
    sed -i "14i\ " Program.cs
    sed -i "15i\ // Habilitando CORS" Program.cs
    sed -i "16i\ app.UseCors(MyAllowSpecificOrigins);" Program.cs
    sed -i "17i\ " Program.cs

    echo -e "\033[1;32mCORS were enabled!\033"

    cd ..
}

###
createMain