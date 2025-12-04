# src/Samo.jl
module Samo

# 1. Include the file you just made
include("Types.jl")

# 2. Use the module we defined in that file
using .Types

# 3. Re-export the Types so the user (and Person B/C) can use them directly
export AbstractActivity, StrengthExercise, CardioExercise, WorkoutSession

# (Person B and C will add their includes here later)

end