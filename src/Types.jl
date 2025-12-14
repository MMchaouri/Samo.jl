module Types

# Gestion des unités et autres trucs
using Unitful 

export AbstractActivity, StrengthExercise, CardioExercise, WorkoutSession

abstract type AbstractActivity end

# ==============================================================================
# 1. StrengthExercise
# ==============================================================================
struct StrengthExercise{T <: Number} <: AbstractActivity
    name::String
    weight::T
    reps::Int
    sets::Int
    rpe::Union{Int, Nothing}
end

# Constructeur externe pour gérer le RPE optionnel
StrengthExercise(name, weight, reps, sets) = StrengthExercise(name, weight, reps, sets, nothing)

# ==============================================================================
# 2. CardioExercise
# ==============================================================================
# l'utilisateur doit fournir des unités (ex: 30u"minute")
struct CardioExercise <: AbstractActivity
    name::String
    duration::Unitful.Time    # Le type doit être une durée (s, min, hr...)
    distance::Unitful.Length  # Le type doit être une distance (m, km, mi...)
end

# ==============================================================================
# 3. WorkoutSession
# ==============================================================================
mutable struct WorkoutSession
    date::String
    activities::Vector{AbstractActivity}
end

# Constructeur Slurping (pour passer les exercices sans créer de liste manuelle)
function WorkoutSession(date::String, args::AbstractActivity...)
    return WorkoutSession(date, collect(args))
end

end