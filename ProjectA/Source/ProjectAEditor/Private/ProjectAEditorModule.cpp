// Copyright 1998-2018 Epic Games, Inc. All Rights Reserved.

#include "ProjectAEditorModule.h"
#include "ProjectAEditor.h"

IMPLEMENT_GAME_MODULE(FProjectAEditorModule, ProjectAEditor);
DEFINE_LOG_CATEGORY(ProjectAEditor)

#define LOCTEXT_NAMESPACE "ProjectAEditor"

void FProjectAEditorModule::StartupModule()
{
	UE_LOG(ProjectAEditor, Warning, TEXT("EditorModule Start"));
}

void FProjectAEditorModule::ShutdownModule()
{
	UE_LOG(ProjectAEditor, Warning, TEXT("EditorModule Shutdown"));
}

#undef LOCTEXT_NAMESPACE