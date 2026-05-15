#!/bin/bash

echo "----------- Delete Test Folders -----------"

echo  "test_clean_safe_mode"
rm -rf test_clean_safe_mode

echo "test_converting_documents"
rm -rf test_converting_documents

echo "test_deleting_files_and_folders"
rm -rf test_deleting_files_and_folders

echo "test_folder_creation"
rm -rf test_folder_creation

echo "test_move_files_into_matching_folders"
rm -rf test_move_files_into_matching_folders

echo "test_project_status"
rm -rf test_project_status

echo "----------- clean_safe_mode -----------"
./clean_safe_mode.sh

echo "----------- converting_documents -----------"
./converting_documents.sh 1
./converting_documents.sh 2

echo "----------- deleting_files_and_folders -----------"
./deleting_files_and_folders.sh 1
./deleting_files_and_folders.sh 2

echo "----------- folder_creation -----------"
./folder_creation.sh


echo "----------- move_files_into_matching_folders -----------"
./move_files_into_matching_folders.sh


echo "----------- project_status -----------"
./project_status.sh












