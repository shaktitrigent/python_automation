*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  OperatingSystem
Library  String
Library  ../Resources/Utility_Functions.py
Resource  ../APIUtility/Books_API_utility.robot

*** Variables ***
${baseUrl}      https://simple-books-api.glitch.me/