app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br",
    jd: "DataTypes/main.roc",
}
import "DataTypes/StudentData.json" as students : Str
import pf.Stdout
import pf.Task
import jd.StudentHandler

main =
    Stdout.line! "$(students)"

expect StudentHandler.getListStudents input == Ok expected
# expected Student output
expected = [
    {
        name: "Amy",
        modules: [{ name: "Maths 101", credits: 200 }, { name: "Physics 101", credits: 100 }],
    },
    {
        name: "John",
        modules: [{ name: "Maths 101", credits: 200 }],
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
        )
johnObj =
    Object
        (
            Dict.empty {}
            |> Dict.insert "name" (String "John")
            |> Dict.insert "modules" (johnMod)
        )
amyMods = Arr ([mathsMod, physicsMod])
johnMod = Arr ([mathsMod])

mathsMod = Object
    (
        Dict.empty {}
        |> Dict.insert "name" (String "Maths 101")
        |> Dict.insert "credits" (Number 200)
    )
physicsMod = Object
    (
        Dict.empty {}
        |> Dict.insert "name" (String "Physics 101")
        |> Dict.insert "credits" (Number 100)
    )
