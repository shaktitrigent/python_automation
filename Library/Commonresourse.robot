*** Settings ***
Documentation  All the required libraries for the project
Library  RequestsLibrary
Library  Collections
Library  OperatingSystem
Library  String

Library  ../Resource/Utility_Function.py

Resource  ../Api_Utility/Books_Api_Helper.robot


*** Variables ***
${base_url}     https://simple-books-api.glitch.me