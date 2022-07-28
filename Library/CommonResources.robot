*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     OperatingSystem
Library     String

Resource     ../APIUtility/Books_API_utility.robot
Resource     ../TestCases/Books_API_Tests.robot
Resource    ../TestCases/Gherkin_StyleP_Test.robot
Library     ../Resources/Utility_Functions.py

*** Variables ***
${baseurl}      https://simple-books-api.glitch.me/