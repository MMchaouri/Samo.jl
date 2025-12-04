# src/Samo.jl
module Samo

include("Types.jl")
using .Types
export AbstractActivity, StrengthExercise, CardioExercise, WorkoutSession

include("Logic.jl")
using .Logic
export calculate_load, summarize

end