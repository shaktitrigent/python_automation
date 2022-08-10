*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  OperatingSystem
Library  String

Library  ../Resources/Utility_Functions.py
Resource  ../APIUtility/Books_API_utility.robot
#Resource  ../TestCases/Books_API_Tests.robot
*** Variables ***
${baseUrl}      https://simple-books-api.glitch.me/