// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;

public class ProjectAEditor : ModuleRules
{
	public ProjectAEditor(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

        //IncludePaths
        PublicIncludePaths.AddRange(new string[] { "ProjectAEditor/Public" });
        PrivateIncludePaths.AddRange(new string[] { "ProjectAEditor/Private" });

        //DependencyModuleNames
        PublicDependencyModuleNames.AddRange(new string[] { "ProjectA", "Core" });
		PrivateDependencyModuleNames.AddRange(new string[] { "UnrealEd" });

        //PrivateIncludePathModuleNames
        PrivateIncludePathModuleNames.AddRange(new string[] { });

        //DynamicallyLoadedModuleNames
        DynamicallyLoadedModuleNames.AddRange(new string[] { });
    }
}
