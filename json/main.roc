app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br",
    jd: "DataTypes/main.roc",
}
import "DataTypes/StudentData.json" as students : Str
import pf.Stdout
import pf.Task
import jd.DecodeStudent
import jd.DecodeStudentLong

main =
    Stdout.line! "$(students)"

expect DecodeStudent.readStudents input == Ok expected
expect DecodeStudentLong.getListStudents input == Ok expected
# expected Student output
expected = [
    CurrentStudent {
        name: "Amy",
        modules: [{ name: "Maths 101", credits: 200, enrolled: Bool.true }, { name: "Physics 101", credits: 100, enrolled: Bool.false }],
        currentGrade: 75,
    },
    GraduatedStudent {
        name: "John",
        modules: [{ name: "Maths 101", credits: 200, enrolled: Bool.true }],
        finalGrade: 65,
    },
]
# JsonData representation for input
input = Object (Dict.empty {} |> Dict.insert "students" (Arr [amyObj, johnObj]))
amyObj =
    Object
        (
            Dict.empty {}
            |> Dict.insert "name" (String "Amy")
            |> Dict.insert "modules" (amyMods)
            |> Dict.insert "currentGrade" (Number 75)
        )
johnObj =
    Object
        (
            Dict.empty {}
            |> Dict.insert "name" (String "John")
            |> Dict.insert "modules" (johnMod)
            |> Dict.insert "finalGrade" (Number 65)
        )
amyMods = Arr ([mathsMod, physicsMod])
johnMod = Arr ([mathsMod])

mathsMod = Object
    (
        Dict.empty {}
        |> Dict.insert "name" (String "Maths 101")
        |> Dict.insert "credits" (Number 200)
        |> Dict.insert "enrolled" (Boolean Bool.true)
    )
physicsMod = Object
    (
        Dict.empty {}
        |> Dict.insert "name" (String "Physics 101")
        |> Dict.insert "credits" (Number 100)
        |> Dict.insert "enrolled" (Boolean Bool.false)
    )
