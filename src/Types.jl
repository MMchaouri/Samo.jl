# src/Types.jl
module Types

# We export these so the Main Module (and the user) can see them
export AbstractActivity, StrengthExercise, CardioExercise, WorkoutSession

# 1. The Parent (Abstract Type)
# This is the "Bucket" that will hold both Strength and Cardio.
abstract type AbstractActivity end

# 2. Strength Exercise (Immutable Struct)
# We use {T <: Real} so 'weight' can be an Int (100) or Float (100.5)
struct StrengthExercise{T <: Real} <: AbstractActivity
    name::String
    weight::T
    reps::Int
    sets::Int
    rpe::Union{Int, Nothing} # Optional! Can be an Integer OR Nothing
end

# 3. Cardio Exercise (Immutable Struct)
struct CardioExercise <: AbstractActivity
    name::String
    duration::Int      # Minutes
    distance::Float64  # Kilometers
end

# 4. The Session (Mutable Struct)
# It is "mutable" because we will ADD exercises to the vector later.
mutable struct WorkoutSession
    date::String
    activities::Vector{AbstractActivity} # Polymorphism! Holds both types.
end

end