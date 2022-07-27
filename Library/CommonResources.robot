*** Settings ***
Documentation   Common variables and keywords files

Library  RequestsLibrary
Library  Collections
Library  OperatingSystem
Library  String
Library  SeleniumLibrary

Library  ../Resources/Utility_Functions.py

Resource  ../TestCases/SimpleBookAPITests.robot
Resource  ../APIUtility/Simple_Book_API.robot
Resource  TestDataGenerator.robot
Library  ../Resources/Get_Bearer_Token.py


*** Variables ***
${base_url}     https://simple-books-api.glitch.me/
