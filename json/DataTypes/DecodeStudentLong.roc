module [readStudents]

import JsonData exposing [Json]
import Student exposing [Student, Module]

JsonErrors : [
    FieldNotFound Str,
    ExpectedJsonObject Str,
    ExpectedJsonArray Str,
]

Students : List Student

readStudents : Json -> Result Students JsonErrors
readStudents = \json ->
    when json is
        Object obj ->
            when Dict.get obj "students" is
                Ok students -> checkStudentArr students
                Err KeyNotFound -> Err (FieldNotFound "Expected field with name students in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")

checkStudentArr : Json -> Result Students JsonErrors
checkStudentArr = \json ->
    when json is
        Arr students ->
            List.mapTry students readStudent

        _ -> Err (ExpectedJsonArray "Expected an Array")

readStudent : Json -> Result Student JsonErrors
readStudent = \json ->
    when json is
        Object obj ->
            when Dict.get obj "name" is
                Ok (String name) ->
                    when Dict.get obj "modules" is
                        Ok modules ->
                            when checkModulesArr modules is
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

checkModulesArr : Json -> Result (List Module) JsonErrors
checkModulesArr = \json ->
    when json is
        Arr modules ->
            List.mapTry modules readModule

        _ -> Err (ExpectedJsonArray "Expected an Array")

readModule : Json -> Result Module JsonErrors
readModule = \json ->
    when json is
        Object fields ->
            when Dict.get fields "name" is
                Ok (String name) ->
                    when Dict.get fields "credits" is
                        Ok (Number credits) ->
                            when Dict.get fields "enrolled" is
                                Ok (Boolean enrolled) ->
                                    Ok ({ name, credits, enrolled })

                                _ -> Err (FieldNotFound "Expected field with name \"credits\" in object")

                        _ -> Err (FieldNotFound "Expected field with name \"credits\" in object")

                _ -> Err (FieldNotFound "Expected field with name \"name\" in object")

        _ -> Err (ExpectedJsonObject "Expected an Object")
