module [getListStudents]

import JsonData exposing [Json]
import Student exposing [Student, Module]

JsonErrors : [
    FieldNotFound Str,
    ExpectedJsonObject Str,
    ExpectedJsonArray Str,
]

getListStudents : Json -> Result (List Student) JsonErrors
getListStudents = \json ->
    when json is
        Object obj ->
            when Dict.get obj "students" is
                Ok students -> checkStudentList students
                _ -> Err (FieldNotFound "Expected field with name students in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")

checkStudentList : Json -> Result (List Student) JsonErrors
checkStudentList = \json ->
    when json is
        Arr students ->
            List.mapTry (List.map students checkStudentObj) \x -> x

        _ -> Err (ExpectedJsonArray "Expected an Array")

checkStudentObj : Json -> Result Student JsonErrors
checkStudentObj = \json ->
    when json is
        Object obj ->
            when Dict.get obj "name" is
                Ok (String name) ->
                    when Dict.get obj "modules" is
                        Ok modules ->
                            when checkModulesList modules is
                                Ok goodMods ->
                                    when Dict.get obj "finalGrade" is
                                        Ok (Number fg) -> Ok (GraduatedStudent { name: name, modules: goodMods, finalGrade: fg })
                                        _ ->
                                            when Dict.get obj "currentGrade" is
                                                Ok (Number cg) -> Ok (CurrentStudent { name: name, modules: goodMods, currentGrade: cg })
                                                _ -> Err (FieldNotFound "Expected field ")

                                Err e -> Err e

                        _ -> Err (FieldNotFound "Expected field with name modules in object")

                _ -> Err (FieldNotFound "Expected field with name name in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")

checkModulesList : Json -> Result (List Module) JsonErrors
checkModulesList = \json ->
    when json is
        Arr modules ->
            List.mapTry (List.map modules readModuleObject) \x -> x

        _ -> Err (ExpectedJsonArray "Expected an Array")

readModuleObject : Json -> Result Module JsonErrors
readModuleObject = \json ->
    when json is
        Object fields ->
            when Dict.get fields "name" is
                Ok (String name) ->
                    when Dict.get fields "credits" is
                        Ok (Number credits) ->
                            when Dict.get fields "enrolled" is
                                Ok (Boolean enrolled) ->
                                    Ok ({ name: name, credits: credits, enrolled: enrolled })

                                _ -> Err (FieldNotFound "Expected field with name \"credits\" in object")

                        _ -> Err (FieldNotFound "Expected field with name \"credits\" in object")

                _ -> Err (FieldNotFound "Expected field with name \"name\" in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")
