module [Student, Module]
 
Student : {
    name : Str,
    modules : List (Module)
}

Module : {
    name : Str,
    credits : U64
}